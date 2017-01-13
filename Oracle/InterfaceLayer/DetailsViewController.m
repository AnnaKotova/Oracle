//
//  DetailsViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/14/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import "DetailsViewController.h"
#import "History.h"
#import "NSFileManagerExtension.h"
#import "IconImageView.h"

static const CGFloat kImageViewSize = 220.0f;
static const CGFloat kNavigatinBarHeight = 44.0f;
static const CGFloat kIndent = 40.0f;
static const CGFloat kContainerInset = 15.0f;

static UIFont * _TitlesFont() { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]; }
static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:17]; }

@interface DetailsViewController ()
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_backAction:)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [self _initInterface];
}

- (void)viewDidLayoutSubviews
{
    _iconImageView.center = CGPointMake(kIndent + kImageViewSize / 2, kNavigatinBarHeight + kIndent + kImageViewSize / 2);
    _nameLabel.center = CGPointMake(CGRectGetMaxX(_iconImageView.frame) + kIndent + CGRectGetWidth(_nameLabel.bounds) / 2, kNavigatinBarHeight + kIndent + CGRectGetHeight(_nameLabel.bounds) / 2);
    _birthdayDateLabel.center = CGPointMake(CGRectGetMidX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + CGRectGetHeight(_birthdayDateLabel.bounds)/2);
    _resultDateLabel.center = CGPointMake(CGRectGetMidX(_birthdayDateLabel.frame), CGRectGetMaxY(_birthdayDateLabel.frame) + CGRectGetHeight(_resultDateLabel.bounds)/2);
    
    if (_info.note.length > 0)
    {
        _descriptionTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_iconImageView.frame) + CGRectGetHeight(_descriptionTextView.bounds)/2);
        _resultTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_descriptionTextView.frame) + CGRectGetHeight(_resultTextView.bounds));
    }
    else
    {
         _resultTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_iconImageView.frame) + CGRectGetHeight(_resultTextView.bounds));
    }
    _tryAgainButton.center = CGPointMake(kIndent + CGRectGetWidth(_tryAgainButton.bounds), CGRectGetMaxY(_resultTextView.frame) + CGRectGetHeight(_tryAgainButton.bounds));
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_initInterface
{
    _iconImageView = [[IconImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewSize, kImageViewSize)];
    [self.view addSubview:_iconImageView];

    _nameLabel = [UILabel new];
    _nameLabel.text = _info.name;
    _nameLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, kNavigatinBarHeight);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = _TitlesFont();
    //_nameLabel.textAlignment = NSTextAlignmentCenter;
    //_nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_nameLabel];

    _birthdayDateLabel = [UILabel new];
    _birthdayDateLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, kNavigatinBarHeight);
    _birthdayDateLabel.textColor = [UIColor blackColor];
    _birthdayDateLabel.font = _InfoFont();
    [self.view addSubview:_birthdayDateLabel];

    _resultDateLabel = [UILabel new];
    _resultDateLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, kNavigatinBarHeight);
    _resultDateLabel.textColor = [UIColor blackColor];
    _resultDateLabel.font = _InfoFont();
    [self.view addSubview:_resultDateLabel];

    CGFloat widthOfTextViews = self.view.bounds.size.width - 2 * kIndent;
    CGFloat heightOfDescription;
    if (_info.note.length > 0)
    {
        
        _descriptionTextView = [UITextView new];
        _descriptionTextView.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Note", nil), _info.note];
        heightOfDescription = [self _calculateInitialHeightForString:_descriptionTextView.text withWidth:widthOfTextViews];
        _descriptionTextView.frame = CGRectMake(0, 0, widthOfTextViews, heightOfDescription);
        _descriptionTextView.textColor = [UIColor blackColor];
        _descriptionTextView.font = _InfoFont();
//        _descriptionTextView.layer.borderColor = [UIColor redColor].CGColor;
//        _descriptionTextView.layer.borderWidth = 1;
        [self.view addSubview:_descriptionTextView];
    }
    
    _resultTextView = [UITextView new];
    _resultTextView.text = [NSString stringWithFormat:NSLocalizedString(@"DetailsViewController_Result_Description", nil), NSLocalizedString(_info.resultKey.stringValue, nil)];
    heightOfDescription = [self _calculateInitialHeightForString:_resultTextView.text withWidth:widthOfTextViews];
    _resultTextView.frame = CGRectMake(0, 0, widthOfTextViews, heightOfDescription);
    _resultTextView.textColor = [UIColor blackColor];
    _resultTextView.font = _InfoFont();
//    _resultTextView.layer.borderColor = [UIColor redColor].CGColor;
//    _resultTextView.layer.borderWidth = 1;
    [self.view addSubview:_resultTextView];
    
    CGFloat buttonsWidth = 100.0f;
    _tryAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _tryAgainButton.frame = CGRectMake(0, 0, buttonsWidth, kNavigatinBarHeight);
    [_tryAgainButton setTitle:NSLocalizedString(@"DetailsViewController_Try_Again_Button_Title", nil) forState:UIControlStateNormal];
    [_tryAgainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _tryAgainButton.layer.cornerRadius = 5;
    _tryAgainButton.layer.borderWidth = 2.0;
    _tryAgainButton.layer.borderColor = [UIColor blackColor].CGColor;
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
    if (_iconImageView.imageWasUpdate)
    {
        NSString * imagePath = [_iconImageView imageFileNameInLocalFolder];
        if(imagePath.length > 0)
        {
            _info.imagePath = imagePath;
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_onTryAgainButtonTap:(UIButton *)button
{
    
}

- (CGFloat)_calculateInitialHeightForString:(NSString *)string withWidth:(CGFloat)width
{
    CGSize contentSize = [string sizeWithAttributes:@{NSFontAttributeName : _InfoFont()}];
    float newHeight = ceil(ceil(contentSize.width) / width) * ceil(contentSize.height) + 2 * kContainerInset;
    return (newHeight < kNavigatinBarHeight ? kNavigatinBarHeight : newHeight);
}
@end
