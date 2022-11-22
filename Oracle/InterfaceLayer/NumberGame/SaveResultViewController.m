//
//  SaveResultViewcontrollerViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/5/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "SaveResultViewController.h"
#import "History.h"
#import "LocalStorageManager.h"
#import "IconImageView.h"
#import "UIViewControllerExtension.h"

static const CGFloat kImageViewSize = 220.0f;
static const CGFloat kIndent = 40.0f;

static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:17]; }

@interface SaveResultViewController()<UITextViewDelegate>
{
    IconImageView * _thumbnailImageView;
    UITextView * _noteTextView;
}
@end

@implementation SaveResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 4.0f;
//    self.view.layer.borderColor = [UIColor blackColor].CGColor;
//    self.view.layer.borderWidth = 2.0f;
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_cancelAction:)];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_saveAction)];

    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _thumbnailImageView = [[IconImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewSize, kImageViewSize)];
    [self.view addSubview:_thumbnailImageView];
    
    _noteTextView = [UITextView new];
    _noteTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _noteTextView.layer.borderWidth = 1.0f;
    _noteTextView.layer.cornerRadius = 4.0f;
    _noteTextView.delegate = self;
    _noteTextView.font = _InfoFont();
    _noteTextView.text = NSLocalizedString(@"SaveResultViewController_Placeholder", nil);
    _noteTextView.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_noteTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    _thumbnailImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), kNavigatinBarHeight + 30.0 + kImageViewSize / 2);
    _noteTextView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 2 * kIndent, kIndent * 4);
    _noteTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                       CGRectGetMaxY(_thumbnailImageView.frame) + CGRectGetHeight(_noteTextView.bounds) / 2 + kIndent);
    [super viewDidLayoutSubviews];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _noteTextView)
    {
        if ([_noteTextView.text isEqualToString:NSLocalizedString(@"SaveResultViewController_Placeholder", nil)])
        {
            _noteTextView.text = @"";
            _noteTextView.textColor = [UIColor blackColor];
        }
        else if (_noteTextView.text.length == 0)
        {
            _noteTextView.text = NSLocalizedString(@"SaveResultViewController_Placeholder", nil);
            _noteTextView.textColor = [UIColor lightGrayColor];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
//    CGSize textFieldSize = [textView.text sizeWithAttributes:@{NSFontAttributeName : _InfoFont()}];
//    
//    float newHeight = ceil(ceil(textFieldSize.width) / _noteTextView.bounds.size.width) * ceil(textFieldSize.height);
//    CGFloat noteTextViewHeight = newHeight < indent ? indent : newHeight;
//    CGRect rect = _noteTextView.frame;
//    rect.size.height = noteTextViewHeight;
//    _noteTextView.frame = rect;
}

#pragma mark - Private methods

- (void)_cancelAction:(UIBarButtonItem *)barButtonItem
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SaveResultViewController_Cancel_Alert_Title", nil)
                                                                    message:NSLocalizedString(@"SaveResultViewController_Cancel_Alert_Message", nil)
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    __typeof(self) __weak weakSelf = self;
    UIAlertAction * dontSaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SaveResultViewController_Cancel_Action_Message", nil)
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                            }];
    
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [weakSelf _saveAction];
                                                        }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:dontSaveAction];
    [alertController addAction:saveAction];
    
    UIPopoverPresentationController * popPresenter = [alertController popoverPresentationController];
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popPresenter.barButtonItem = self.navigationItem.leftBarButtonItem;
    popPresenter.sourceRect = self.view.bounds;
    [[UIViewController visibleViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)_saveAction
{
    History * history = [History createNoteInHistory];
    history.date = [NSDate date];
    history.name = _name;
    history.note = _noteTextView.text;
    history.resultKey = @(_resultKey);
    history.birthdayDate = _birthdayDate;
    
    if (_thumbnailImageView.image)
    {
        NSString * imagePath = [_thumbnailImageView imageFileNameInLocalFolder];
        if(imagePath.length > 0)
        {
            history.imagePath = imagePath;
        }
    }
    
    [[LocalStorageManager sharedManager] saveContext];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
