//
//  DetailsViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/14/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "DetailsViewController.h"
#import "History.h"
#import "NSFileManagerExtension.h"
#import "IconImageView.h"
#import "NumericPlayFieldViewController.h"

static const CGFloat kIndent = 20.0f;
static const CGFloat kContainerInset = 15.0f;

static UIFont * _TitlesFont() { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]; }
static UIFont * _SubTitleFont() { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]; }
static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:16]; }

@interface DetailsViewController ()<NumericPlayFieldViewControllerDelegate>
{
    History * _info;
    
    IconImageView * _iconImageView;
    UILabel * _nameLabel;
    UILabel * _birthdayDateLabel;
    UILabel * _resultDateLabel;
    UITextView * _descriptionTextView;
    UITextView * _resultTextView;
    UIButton * _tryAgainButton;
}
@end

@implementation DetailsViewController

- (instancetype)initWithInfo:(History *)info
{
    if((self = [super init]))
    {
        _info = info;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = NO;
//    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
//                                                                     style:UIBarButtonItemStylePlain
//                                                                    target:self
//                                                                    action:@selector(_backAction:)];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
    [self _initInterface];
    
}

- (void)viewDidLayoutSubviews
{
    CGFloat offsetX = self.view.safeAreaInsets.left;
    //CGFloat offsetY = self.view.safeAreaInsets.right;
    
    CGFloat navBarMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _iconImageView.center = CGPointMake(offsetX + kIndent/2.0f + CGRectGetWidth(_iconImageView.bounds) / 2, navBarMaxY + CGRectGetHeight(_iconImageView.bounds) / 2);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + kIndent / 4.0f, navBarMaxY, CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(_iconImageView.frame) - kIndent, CGRectGetHeight(_nameLabel.bounds));
    //_nameLabel.center = CGPointMake((CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(_iconImageView.frame) - kIndent) / 2.0f, navBarMaxY + CGRectGetHeight(_nameLabel.bounds) / 2);
    _birthdayDateLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth(_nameLabel.frame), CGRectGetHeight(_birthdayDateLabel.bounds));
    //_birthdayDateLabel.center = CGPointMake(CGRectGetMidX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + CGRectGetHeight(_birthdayDateLabel.bounds)/2);
    _resultDateLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_birthdayDateLabel.frame), CGRectGetWidth(_nameLabel.frame), CGRectGetHeight(_resultDateLabel.bounds));
    //_resultDateLabel.center = CGPointMake(CGRectGetMidX(_birthdayDateLabel.frame), CGRectGetMaxY(_birthdayDateLabel.frame) + CGRectGetHeight(_resultDateLabel.bounds)/2);
    
    if (_info.note.length > 0)
    {
        _descriptionTextView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 2 * kIndent - offsetX, CGRectGetHeight(_descriptionTextView.bounds));
        _descriptionTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_iconImageView.frame) + CGRectGetHeight(_descriptionTextView.bounds)/2);
        _resultTextView.frame = CGRectMake(0, 0, CGRectGetWidth(_descriptionTextView.frame), CGRectGetHeight(_resultTextView.bounds));
        _resultTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_descriptionTextView.frame) + CGRectGetHeight(_resultTextView.bounds)/2);
    }
    else
    {
        _resultTextView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 2 * kIndent, CGRectGetHeight(_resultTextView.bounds));
         _resultTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_iconImageView.frame) + CGRectGetHeight(_resultTextView.bounds)/2);
    }
    _tryAgainButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_resultTextView.frame) + CGRectGetHeight(_tryAgainButton.bounds));
    [super viewDidLayoutSubviews];
}

#pragma mark - NumericPlayFieldViewControllerDelegate
- (void)numericPlayFieldViewControllerSaveResultWithKey:(NSInteger)key
{
    _info.resultKey = @(key);
    _resultTextView.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Result_Description", nil), NSLocalizedString(_info.resultKey.stringValue, nil)];
}

#pragma mark - private methods

- (void)_initInterface
{
    CGFloat minSide = self.view.bounds.size.width > self.view.bounds.size.height ? self.view.bounds.size.height : self.view.bounds.size.width;
    CGFloat widthOfTextViews = minSide - 2 * kIndent;
    CGFloat imageViewSize = widthOfTextViews / 3; //(self.view.bounds.size.width / 3 < kImageViewSize) ? self.view.bounds.size.width / 3 : kImageViewSize;
    _iconImageView = [[IconImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewSize, imageViewSize)];
    [self.view addSubview:_iconImageView];

    _nameLabel = [UILabel new];
    _nameLabel.text = _info.name;
    _nameLabel.frame = CGRectMake(0, 0, widthOfTextViews * 2 / 3, kNavigationBarHeight);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = _TitlesFont();
    //_nameLabel.textAlignment = NSTextAlignmentCenter;
    //_nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_nameLabel];

    _birthdayDateLabel = [UILabel new];
    _birthdayDateLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_nameLabel.bounds), kNavigationBarHeight * 0.6);
    _birthdayDateLabel.textColor = [UIColor blackColor];
    _birthdayDateLabel.font = _SubTitleFont();
    [self.view addSubview:_birthdayDateLabel];

    _resultDateLabel = [UILabel new];
    _resultDateLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_nameLabel.bounds), kNavigationBarHeight * 0.6);
    _resultDateLabel.textColor = [UIColor blackColor];
    _resultDateLabel.font = _SubTitleFont();
    [self.view addSubview:_resultDateLabel];

    CGFloat heightOfDescription;
    if (_info.note.length > 0)
    {
        _descriptionTextView = [UITextView new];
        _descriptionTextView.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Note", nil), _info.note];
        heightOfDescription = [self _calculateInitialHeightForString:_descriptionTextView.text withWidth:widthOfTextViews];
        _descriptionTextView.frame = CGRectMake(0, 0, widthOfTextViews, heightOfDescription);
        _descriptionTextView.textColor = [UIColor blackColor];
        _descriptionTextView.font = _InfoFont();
        _descriptionTextView.editable = NO;
        _descriptionTextView.backgroundColor = UIColor.clearColor;
//        _descriptionTextView.layer.borderColor = [UIColor redColor].CGColor;
//        _descriptionTextView.layer.borderWidth = 1;
        [self.view addSubview:_descriptionTextView];
    }
    
    _resultTextView = [UITextView new];
    _resultTextView.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Result_Description", nil), NSLocalizedString(_info.resultKey.stringValue, nil)];
    heightOfDescription = [self _calculateInitialHeightForString:_resultTextView.text withWidth:widthOfTextViews];
    _resultTextView.frame = CGRectMake(0, 0, widthOfTextViews, heightOfDescription / 2);
    _resultTextView.textColor = [UIColor blackColor];
    _resultTextView.font = _InfoFont();
    _resultTextView.editable = NO;
//    _resultTextView.layer.borderColor = [UIColor redColor].CGColor;
//    _resultTextView.layer.borderWidth = 1;
    _resultTextView.backgroundColor = [UIColor colorWithRed:91.0f/255.0f green:108.0f/255.0f blue:185.0f/255.0f alpha:0.4];
    [self.view addSubview:_resultTextView];
    
    CGFloat buttonsWidth = 100.0f;
    CGFloat buttonsHeigth = 50.0f;
    _tryAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _tryAgainButton.backgroundColor = [UIColor colorWithRed:91.0f/255.0f green:108.0f/255.0f blue:185.0f/255.0f alpha:1];
    _tryAgainButton.frame = CGRectMake(0, 0, buttonsWidth * 1.5, buttonsHeigth);
    [_tryAgainButton setTitle:NSLocalizedString(@"DetailsViewController_Try_Again_Button_Title", nil) forState:UIControlStateNormal];
    [_tryAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tryAgainButton.layer.cornerRadius = 5;
//    _tryAgainButton.layer.borderWidth = 2.0;
//    _tryAgainButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_tryAgainButton addTarget:self action:@selector(_onTryAgainButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tryAgainButton];
    
    if (_info.imagePath.length > 0)
    {
        NSString * filePath = [[[NSFileManager defaultManager] imagesDirectory] stringByAppendingString:_info.imagePath];
        UIImage * icon = [UIImage imageWithContentsOfFile:filePath];
        _iconImageView.image = icon;
    }
    else
    {
        ///set default Image
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd.MM.yyyy";
    NSString * dateString = [dateFormatter stringFromDate:_info.birthdayDate];
    _birthdayDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Birthday_Date", nil), dateString];
    
    dateString = [dateFormatter stringFromDate:_info.date];
    _resultDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Result_Date", nil), dateString];
}

- (void)_backAction:(UIBarButtonItem *)barButtonItem
{
    [self _saveImageIfNeeded];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_onTryAgainButtonTap:(UIButton *)button
{
    [self _saveImageIfNeeded];
    NumericPlayFieldViewController * numericPlayFieldViewController = [[NumericPlayFieldViewController alloc] initWithNameString:_info.name dateOfBirthday:_info.birthdayDate];
    numericPlayFieldViewController.delegate = self;
    [self.navigationController pushViewController:numericPlayFieldViewController animated:YES];
}

- (CGFloat)_calculateInitialHeightForString:(NSString *)string withWidth:(CGFloat)width
{
    CGSize contentSize = [string sizeWithAttributes:@{NSFontAttributeName : _InfoFont()}];
    float newHeight = ceil(ceil(contentSize.width) / width) * ceil(contentSize.height) + 2 * kContainerInset;
    return (newHeight < kNavigationBarHeight ? kNavigationBarHeight : newHeight);
}

- (void)_saveImageIfNeeded
{
    if (_iconImageView.imageWasUpdate)
    {
        NSString * imagePath = [_iconImageView imageFileNameInLocalFolder];
        if(imagePath.length > 0)
        {
            _info.imagePath = imagePath;
        }
    }
}
@end
