//
//  QuestionViewController.h
//  Oracle
//
//  Created by Ann Kotova on 1/26/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController

- (instancetype)initWithGameName:(NSString *)gameName questionsAmount:(int)questionsAmount numberOfResponsOptions:(int)numberOfButtons;

@end
