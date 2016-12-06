//
//  SaveResultViewcontrollerViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/5/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import "SaveResultViewController.h"

static const CGFloat imageViewSize = 220.0f;
static const CGFloat navigatinBarHeight = 44.0f;
static const CGFloat indent = 40.0f;

static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:17]; }

@interface SaveResultViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    UIImageView * _thumbnailImageView;
    UILabel * _addIconLabel;
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
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_backAction:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    _thumbnailImageView = [UIImageView new];
    _thumbnailImageView.frame = CGRectMake(0, 0, imageViewSize, imageViewSize);
    _thumbnailImageView.backgroundColor = [UIColor lightGrayColor];
    _thumbnailImageView.layer.cornerRadius = 4.0f;
    _thumbnailImageView.userInteractionEnabled = YES;
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    _thumbnailImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _thumbnailImageView.layer.borderWidth = 2.0f;
    [self.view addSubview:_thumbnailImageView];
    
    _addIconLabel = [UILabel new];
    _addIconLabel.frame = _thumbnailImageView.frame;
    _addIconLabel.text = NSLocalizedString(@"SaveResultViewController_Add_Icon_Label_Text", nil);
    _addIconLabel.textColor = [UIColor whiteColor];
    _addIconLabel.textAlignment = NSTextAlignmentCenter;
    _addIconLabel.userInteractionEnabled = YES;
    _addIconLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_thumbnailImageView addSubview:_addIconLabel];

    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onIconTap:)];
    [_addIconLabel addGestureRecognizer:gestureRecognizer];
    
    
    _noteTextView = [UITextView new];
    _noteTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _noteTextView.layer.borderWidth = 1.0f;
    _noteTextView.layer.cornerRadius = 4.0f;
    _noteTextView.delegate = self;
    _noteTextView.frame = CGRectMake(0, 0, imageViewSize + 4 * indent, indent * 2);
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
    _thumbnailImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), navigatinBarHeight + 30.0 + imageViewSize / 2);
    _noteTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_thumbnailImageView.frame) + 2 * indent);
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if (image)
    {
        _addIconLabel.hidden = YES;
        _thumbnailImageView.backgroundColor = [UIColor whiteColor];
        _thumbnailImageView.image = image;
    }
    [self.navigationController dismissViewControllerAnimated:picker completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:picker completion:nil];
}

#pragma mark - Private methods

- (void)_backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)_onIconTap:(UITapGestureRecognizer *)gestureRecognizer
{
    __typeof(self) weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction * cameraSelectAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SaveResultViewController_Add_Photo_From_Camera", nil)
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        [weakSelf _showImagePickerPopoverWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                                                    }];
        [alertController addAction:cameraSelectAction];
    }
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertAction * librarySelectAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SaveResultViewController_Add_Photo_From_Gallery", nil)
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action) {
                                                                         [weakSelf _showImagePickerPopoverWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                                     }];
        [alertController addAction:librarySelectAction];
    }
    
    UIPopoverPresentationController * popPresenter = [alertController popoverPresentationController];
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popPresenter.sourceView = _thumbnailImageView;
    popPresenter.sourceRect = _thumbnailImageView.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_showImagePickerPopoverWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController * imagePickerPopoverCtrl = [UIImagePickerController new];
    imagePickerPopoverCtrl.delegate = self;
    imagePickerPopoverCtrl.sourceType = sourceType;
    imagePickerPopoverCtrl.allowsEditing = NO;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            imagePickerPopoverCtrl.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    [self.navigationController presentViewController:imagePickerPopoverCtrl animated:YES completion:nil];
}
@end
