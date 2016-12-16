//
//  SaveResultViewcontrollerViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/5/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import "SaveResultViewController.h"
#import "NSFileManagerExtension.h"
#import "NSStringExtension.h"
#import "UIImageExtension.h"
#import "History.h"
#import "LocalStorageManager.h"

static const CGFloat kImageViewSize = 220.0f;
static const CGFloat kNavigatinBarHeight = 44.0f;
static const CGFloat kIndent = 40.0f;

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
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_backAction:)];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_saveAction:)];

    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _thumbnailImageView = [UIImageView new];
    _thumbnailImageView.frame = CGRectMake(0, 0, kImageViewSize, kImageViewSize);
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
    _noteTextView.frame = CGRectMake(0, 0, kImageViewSize + 4 * kIndent, kIndent * 4);
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
    _noteTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_thumbnailImageView.frame) + CGRectGetHeight(_noteTextView.bounds) / 2 + kIndent);
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        _addIconLabel.text = @"";
        _thumbnailImageView.backgroundColor = [UIColor whiteColor];
        UIImage * image = [[info objectForKey:UIImagePickerControllerOriginalImage] imageThatFitsSize:CGSizeMake(kImageViewSize, kImageViewSize)];
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

- (void)_saveAction:(UIBarButtonItem *)barButtonItem
{
    History * history = [History createNoteInHistory];
    history.date = [NSDate date];
    history.name = _name;
    history.note = _noteTextView.text;
    history.resultKey = @(_resultKey);
    
    if (_thumbnailImageView.image)
    {
        NSString * imagePath = [self _imageFileNameInLocalFolder];
        if(imagePath.length > 0)
        {
            history.imagePath = imagePath;
        }
    }
    
    [[LocalStorageManager sharedManager] saveContext];
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

- (NSString *)_imageFileNameInLocalFolder
{
    [self _createImagesFolderIfRequired];
    
    NSString * fileName = [[NSString UUID] stringByAppendingPathExtension:@"png"];
    NSString * filePath = [[[NSFileManager defaultManager] imagesDirectory] stringByAppendingString:fileName];
    
    NSData * webData = UIImagePNGRepresentation(_thumbnailImageView.image);
    BOOL fileManagerCompletedSuccessfully = [webData writeToFile:filePath atomically:YES];
    return (fileManagerCompletedSuccessfully ? fileName : nil);
}

- (void)_createImagesFolderIfRequired
{
    NSString * imagesDirectory = [[NSFileManager defaultManager] imagesDirectory];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: imagesDirectory])
    {
        NSError * fileManagerError = nil;
        BOOL fileManagerCompletedSuccessfully = [[NSFileManager defaultManager] createDirectoryAtPath: imagesDirectory
                                                                          withIntermediateDirectories: YES
                                                                                           attributes: nil
                                                                                                error: &fileManagerError];
        if (!fileManagerCompletedSuccessfully)
        {
            NSLog(@"%@", fileManagerError);
        }
    }
}

@end
