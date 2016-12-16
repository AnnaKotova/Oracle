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

static const CGFloat kImageViewSize = 220.0f;
static const CGFloat kNavigatinBarHeight = 44.0f;
static const CGFloat kIndent = 40.0f;

static UIFont * _TitlesFont() { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]; }
static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:17]; }

@interface DetailsViewController ()
{
    History * _info;
    
    UIImageView * _iconImageView;
    UILabel * _nameLabel;
    UILabel * _descriptionLabel;
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
    _iconImageView.center = CGPointMake(kIndent + kImageViewSize / 2, kIndent + kImageViewSize / 2);
    _nameLabel.center = CGPointMake(CGRectGetMaxX(_iconImageView.frame), kIndent + CGRectGetHeight(_nameLabel.bounds) / 2);
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_initInterface
{
    _iconImageView = [UIImageView new];
    _iconImageView.frame = CGRectMake(0, 0, kImageViewSize, kImageViewSize);
    _iconImageView.layer.cornerRadius = 4.0f;
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _iconImageView.layer.borderWidth = 2.0f;
    [self.view addSubview:_iconImageView];

    _nameLabel = [UILabel new];
    _nameLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, kNavigatinBarHeight);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = _TitlesFont();
    //_nameLabel.textAlignment = NSTextAlignmentCenter;
    //_nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_nameLabel];

    _descriptionLabel = [UILabel new];
    
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
    _nameLabel.text = _info.name;

}

- (void)_backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
