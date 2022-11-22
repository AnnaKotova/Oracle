//
//  EnterNameViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/24/15.
//  Copyright © 2015 Anna Kotova. All rights reserved.
//

#import "EnterNameViewController.h"
#import "HistoryTableViewController.h"
#import "NumericPlayFieldViewController.h"
#import "SaveResultViewController.h"
#import "UIPagesViewController.h"
#import "AppearanceManager.h"

static const CGFloat kOffsetBeetwenElements = 10.0f;

@interface EnterNameViewController()<NumericPlayFieldViewControllerDelegate>
{
    UITextField * _nameTextField;
    UITextField * _birthdayDateTextField;
    UIDatePicker * _datePicker;
    
    UIButton * _drawPlayFieldButton;
    UIButton * _history;
}
@end

@implementation EnterNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * rulesButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"EnterNameViewController_Rules_Button_Title", nil)
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(_rulesButtonTap:)];
    self.navigationItem.rightBarButtonItem = rulesButtonItem;
    
    _nameTextField = [UITextField new];
    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.font = [AppearanceManager appFontWithSize:20];
//    _nameTextField.delegate = self;
    [_nameTextField addTarget:self action:@selector(_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_nameTextField becomeFirstResponder];
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EnterNameViewController_Name_Text_View_Placeholder", nil)
                                                                           attributes:@{NSFontAttributeName : [[AppearanceManager sharedManager] appFont]}];//[AppearanceManager appFontWithSize:20]
    [self.view addSubview:_nameTextField];
    
    _datePicker = [UIDatePicker new];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    CGFloat toolbarHeight = 44.0f;
    UIToolbar * toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), toolbarHeight)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem * doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(_showSelectedDate)];
    UIBarButtonItem * space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    
    _birthdayDateTextField = [UITextField new];
    _birthdayDateTextField.borderStyle = UITextBorderStyleRoundedRect;
    _birthdayDateTextField.delegate = self;
    _birthdayDateTextField.backgroundColor = [UIColor clearColor];
    _birthdayDateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EnterNameViewController_Birthday_Text_View_Placeholder", nil)
                                                                           attributes:@{NSFontAttributeName : [[AppearanceManager sharedManager] appFont]}];
//    _birthdayDateTextField.font = [AppearanceManager appFontWithSize:20];
    _birthdayDateTextField.inputView = _datePicker;
    _birthdayDateTextField.inputAccessoryView = toolBar;
    [self.view addSubview:_birthdayDateTextField];
    
    _drawPlayFieldButton = [AppearanceManager.sharedManager buttonWithTitle:NSLocalizedString(@"Play", nil)];
    [_drawPlayFieldButton addTarget:self action:@selector(_onDrawPlayFieldButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _drawPlayFieldButton.enabled = NO;
    [self.view addSubview:_drawPlayFieldButton];
    
    _history = [AppearanceManager.sharedManager buttonWithTitle:NSLocalizedString(@"EnterNameViewController_History_Button_Title", nil)];
    [_history addTarget:self action:@selector(_onHistoryButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_history];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLayoutSubviews
{
    CGFloat textFieldsWidth = CGRectGetWidth(self.view.bounds) * 3 / 4;

    _nameTextField.frame = CGRectMake(0, 0, textFieldsWidth, AppearanceManager.sharedManager.textFieldsHeight);
    _birthdayDateTextField.frame = CGRectMake(0, 0, textFieldsWidth, AppearanceManager.sharedManager.textFieldsHeight);
    _drawPlayFieldButton.frame = CGRectMake(0, 0, AppearanceManager.sharedManager.smallButtonsWidth, AppearanceManager.sharedManager.buttonsHeight);
    _history.frame = CGRectMake(0, 0, AppearanceManager.sharedManager.smallButtonsWidth, AppearanceManager.sharedManager.buttonsHeight);
    
    _drawPlayFieldButton.center = self.view.center;
    _history.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_drawPlayFieldButton.frame) + kOffsetBeetwenElements + CGRectGetHeight(_history.bounds) / 2);
    _birthdayDateTextField.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(_drawPlayFieldButton.frame) - kOffsetBeetwenElements - CGRectGetHeight(_birthdayDateTextField.bounds)/2);
    _nameTextField.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(_birthdayDateTextField.frame) - kOffsetBeetwenElements - CGRectGetHeight(_nameTextField.bounds)/2);
    
    [super viewDidLayoutSubviews];
}

#pragma mark - NumericPlayFieldViewControllerDelegate

- (void)numericPlayFieldViewControllerSaveResultWithKey:(NSInteger)key
{
    [self _showSaveResultViewControllerResultKey:key];
}

#pragma mark - UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField == _nameTextField)
//    {
//        [_manager setPlayFieldSizeLetterCount:textField.text.length];
//        _nameString = textField.text;
//        
//        _previousSelectedIndexX = kEmptyCellIndicator;
//        _previousSelectedIndexY = kEmptyCellIndicator;
//        [_labelsArray removeAllObjects];
//        
//        [self _drawInterface];
//        _nameTextField.text = nil;
//    }
}

#pragma mark - private methods
- (void)_textFieldDidChange:(UITextField *)textField
{
    if (textField == _nameTextField)
    {
        _drawPlayFieldButton.enabled = (_nameTextField.text.length > 0);
    }
}

#pragma mark - Handlers
- (void)_onDrawPlayFieldButtonTap:(UIButton *)sender
{
//    [self _showSaveResultViewControllerResultKey:1];
    
    [_nameTextField resignFirstResponder];
    [_birthdayDateTextField resignFirstResponder];
    
    NumericPlayFieldViewController * numericPlayFieldViewController = [[NumericPlayFieldViewController alloc] initWithNameString:_nameTextField.text dateOfBirthday:(_birthdayDateTextField.text.length > 0 ? _datePicker.date : nil)];
    numericPlayFieldViewController.delegate = self;
    [self.navigationController pushViewController:numericPlayFieldViewController animated:YES];
    
//    [self _clearInterface];
//    
//    [_manager setPlayFieldSizeForLettersCount:_nameTextField.text.length dateOfBirthday:(_birthdayDateTextField.text.length > 0 ? _datePicker.date : nil)];
//    _nameString = _nameTextField.text;
//    
//    [self _drawInterface];
//    _nameTextField.text = nil;
}

- (void)_onHistoryButtonTap:(UIButton *)button
{
    HistoryTableViewController * historyTableViewController = [HistoryTableViewController new];
    [self.navigationController pushViewController:historyTableViewController animated:YES];
}

- (void)_showSelectedDate
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.YYYY"];
    _birthdayDateTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
    [_birthdayDateTextField resignFirstResponder];
}

- (void)_showSaveResultViewControllerResultKey:(NSInteger)resultKey
{
    SaveResultViewController * saveResultViewController = [SaveResultViewController new];
    saveResultViewController.name = _nameTextField.text;
    saveResultViewController.resultKey = resultKey;
    saveResultViewController.birthdayDate = _datePicker.date;
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:saveResultViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)_rulesButtonTap:(UIBarButtonItem *)selector
{
    UIPagesViewController * pagesViewController = [UIPagesViewController new];
    [self.navigationController pushViewController:pagesViewController animated:YES];
}
@end
