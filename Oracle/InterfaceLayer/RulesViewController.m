//
//  RulesViewController.m
//  Oracle
//
//  Created by Ann Kotova on 4/27/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "RulesViewController.h"

static UIFont * _InfoFont() { return [UIFont fontWithName:@"HelveticaNeue" size:17]; }

@interface RulesViewController ()
{
    UITextView * _textView;
}
@end

@implementation RulesViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _textView = [UITextView new];
        _textView.textColor = [UIColor blackColor];
        _textView.font = _InfoFont();
        _textView.layer.borderColor = [UIColor redColor].CGColor;
        _textView.layer.borderWidth = 2.0f;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.editable = NO;
        _textView.contentMode = UIViewContentModeTopLeft;
        //_textView.text =@"vfdvgfdv";
        _textView.frame = CGRectMake(0, 100, 300, 300);
        [self.view addSubview:_textView];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setText:(NSString *)text
{
    if (![text isEqualToString:_text])
    {
        _textView.text = text;
    }
}
@end
