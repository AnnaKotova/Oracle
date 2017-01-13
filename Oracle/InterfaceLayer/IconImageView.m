//
//  IconImageView.m
//  Oracle
//
//  Created by Ann Kotova on 1/12/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "IconImageView.h"
#import "UIImageExtension.h"
#import "UIViewControllerExtension.h"
#import "NSStringExtension.h"
#import "NSFileManagerExtension.h"

static const CGFloat kImageViewSize = 220.0f;

@interface IconImageView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UILabel * _addIconLabel;
}

@end

@implementation IconImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 4.0f;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2.0f;
        
        _addIconLabel = [UILabel new];
        _addIconLabel.frame = self.bounds;
        _addIconLabel.text = NSLocalizedString(@"SaveResultViewController_Add_Icon_Label_Text", nil);
        _addIconLabel.textColor = [UIColor whiteColor];
        _addIconLabel.textAlignment = NSTextAlignmentCenter;
        _addIconLabel.userInteractionEnabled = YES;
        _addIconLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_addIconLabel];
        
        UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onIconTap:)];
        [_addIconLabel addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (NSString *)imageFileNameInLocalFolder
{
    [self _createImagesFolderIfRequired];
    
    NSString * fileName = [[NSString UUID] stringByAppendingPathExtension:@"png"];
    NSString * filePath = [[[NSFileManager defaultManager] imagesDirectory] stringByAppendingString:fileName];
    
    NSData * webData = UIImagePNGRepresentation(self.image);
    BOOL fileManagerCompletedSuccessfully = [webData writeToFile:filePath atomically:YES];
    return (fileManagerCompletedSuccessfully ? fileName : nil);
}

- (void)setImage:(UIImage *)image
{
    _addIconLabel.text = @"";
    self.backgroundColor = [UIColor whiteColor];
    [super setImage:image];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage * image = [[info objectForKey:UIImagePickerControllerOriginalImage] imageThatFitsSize:CGSizeMake(kImageViewSize, kImageViewSize)];
        _imageWasUpdate = YES;
        self.image = image;
    }
    [[UIViewController visibleViewController].navigationController dismissViewControllerAnimated:picker completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIViewController visibleViewController].navigationController dismissViewControllerAnimated:picker completion:nil];
}

#pragma mark - private methods

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
    popPresenter.sourceView = self;
    popPresenter.sourceRect = self.bounds;
    [[UIViewController visibleViewController] presentViewController:alertController animated:YES completion:nil];
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
    [[UIViewController visibleViewController].navigationController presentViewController:imagePickerPopoverCtrl animated:YES completion:nil];
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
