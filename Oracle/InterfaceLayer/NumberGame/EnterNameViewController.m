//
//  EnterNameViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/24/15.
//  Copyright © 2015 Bmuse. All rights reserved.
//

#import "EnterNameViewController.h"
#import "HistoryTableViewController.h"
#import "NumericPlayFieldViewController.h"
#import "SaveResultViewController.h"
#import "RulesViewController.h"

static const CGFloat kOffsetBeetwenElements = 10.0f;
static const CGFloat kNavigatinBarHeight = 44.0f;

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
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"images/gameBackground"] drawInRect:self.view.bounds];
    UIImage * backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    self.navigationController.navigationBar.hidden = NO;
    
    UIBarButtonItem * rulesButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"EnterNameViewController_Rules_Button_Title", nil)
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(_rulesButtonTap:)];
    self.navigationItem.rightBarButtonItem = rulesButtonItem;
    
    CGFloat buttonsWidth = 100.0f;
    CGFloat textFieldsHeight = 30.0f;
    CGFloat textFieldsWidth = self.view.bounds.size.width * 3 / 4;
    
    _nameTextField = [UITextField new];
    _nameTextField.frame = CGRectMake(0, 0, textFieldsWidth, textFieldsHeight);
    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
//    _nameTextField.delegate = self;
    [_nameTextField addTarget:self action:@selector(_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_nameTextField becomeFirstResponder];
    _nameTextField.placeholder = NSLocalizedString(@"EnterNameViewController_Name_Text_View_Placeholder", nil);
    [self.view addSubview:_nameTextField];
    
    _datePicker = [UIDatePicker new];
    _datePicker.datePickerMode = UIDatePickerModeDate;
//    _datePicker.date = [NSDate date];
    
    CGFloat toolbarHeight = 44.0f;
    UIToolbar * toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), toolbarHeight)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem * doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(_showSelectedDate)];
    UIBarButtonItem * space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    
    _birthdayDateTextField = [UITextField new];
    _birthdayDateTextField.frame = CGRectMake(0, 0, textFieldsWidth, textFieldsHeight);
    _birthdayDateTextField.borderStyle = UITextBorderStyleRoundedRect;
    _birthdayDateTextField.delegate = self;
//    [_birsdayDateTextField becomeFirstResponder];
    _birthdayDateTextField.placeholder = NSLocalizedString(@"EnterNameViewController_Birthday_Text_View_Placeholder", nil);
    _birthdayDateTextField.inputView = _datePicker;
    _birthdayDateTextField.inputAccessoryView = toolBar;
    [self.view addSubview:_birthdayDateTextField];
    
    _drawPlayFieldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _drawPlayFieldButton.frame = CGRectMake(0, 0, buttonsWidth, textFieldsHeight);
    [_drawPlayFieldButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    [_drawPlayFieldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _drawPlayFieldButton.layer.cornerRadius = 5;
    _drawPlayFieldButton.layer.borderWidth = 2.0;
    _drawPlayFieldButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_drawPlayFieldButton addTarget:self action:@selector(_onDrawPlayFieldButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _drawPlayFieldButton.enabled = NO;
    [self.view addSubview:_drawPlayFieldButton];
    
    _history = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _history.frame = CGRectMake(0, 0, buttonsWidth, textFieldsHeight);
    [_history setTitle:NSLocalizedString(@"EnterNameViewController_History_Button_Title", nil) forState:UIControlStateNormal];
    [_history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _history.layer.cornerRadius = 5;
    _history.layer.borderWidth = 2.0;
    _history.layer.borderColor = [UIColor blackColor].CGColor;
    [_history addTarget:self action:@selector(_onHistoryButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_history];
}

- (void)viewDidLayoutSubviews
{
    CGFloat topIndent = 200.0f;
    _nameTextField.center = CGPointMake(CGRectGetMidX(self.view.bounds), kNavigatinBarHeight + topIndent + CGRectGetHeight(_nameTextField.bounds)/2);
    _birthdayDateTextField.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_nameTextField.frame) + kOffsetBeetwenElements + CGRectGetHeight(_birthdayDateTextField.bounds)/2);
    _drawPlayFieldButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_birthdayDateTextField.frame) + kOffsetBeetwenElements + CGRectGetHeight(_drawPlayFieldButton.bounds)/2);
    _history.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_drawPlayFieldButton.frame) + kOffsetBeetwenElements + CGRectGetHeight(_history.bounds) / 2);

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
    RulesViewController * rulesViewController = [RulesViewController new];
    rulesViewController.text = NSLocalizedString(@"RulesViewController_1", nil);
    [self.navigationController pushViewController:rulesViewController animated:YES];
}
@end
