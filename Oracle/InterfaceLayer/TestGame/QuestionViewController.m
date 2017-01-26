//
//  QuestionViewController.m
//  Oracle
//
//  Created by Ann Kotova on 1/26/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "QuestionViewController.h"

static const CGFloat kIndent = 20.0f;
static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:17]; }

@interface QuestionViewController ()
{
    UITextView * _questionTextView;
}
@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initInterface];
}

#pragma mark - private methods

- (void)_initInterface
{
    CGFloat widthOfTextViews = self.view.bounds.size.width - 2 * kIndent;
    
    _questionTextView = [UITextView new];
    _questionTextView.text = [NSString stringWithFormat:NSLocalizedString(@"", nil)];
    CGFloat heightOfDescription;// = [self _calculateInitialHeightForString:_descriptionTextView.text withWidth:widthOfTextViews];
    _questionTextView.frame = CGRectMake(0, 0, widthOfTextViews, heightOfDescription);
    _questionTextView.textColor = [UIColor blackColor];
    _questionTextView.font = _InfoFont();
    //        _descriptionTextView.layer.borderColor = [UIColor redColor].CGColor;
    //        _descriptionTextView.layer.borderWidth = 1;
    [self.view addSubview:_questionTextView];


}

@end
