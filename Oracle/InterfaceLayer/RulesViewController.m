//
//  RulesViewController.m
//  Oracle
//
//  Created by Ann Kotova on 4/27/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "RulesViewController.h"
#import "DecorationManager.h"

@interface RulesViewController ()
{
    UITextView * _textView;
}
@end

@implementation RulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"images/gameBackground"] drawInRect:self.view.bounds];
    UIImage * backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _textView = [UITextView new];
        _textView.textColor = [UIColor blackColor];
        _textView.font = [DecorationManager mainFontWithSize:17];
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

- (void)setText:(NSString *)text
{
    if (![text isEqualToString:_text])
    {
        _textView.text = text;
    }
}
@end
