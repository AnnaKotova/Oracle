//
//  QuestionViewController.h
//  Oracle
//
//  Created by Ann Kotova on 1/26/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GameType)
{
    GameTypeTest, // respons type : a,b,c; result at the end
    GameTypeYesNo, // yes, no; result at the end
    GameTypeImmediatelyResult // 1,2,3,4...; result at the moment
};

@interface QuestionViewController : UIViewController

- (instancetype)initWithGameType:(GameType)gameType
                            name:(NSString *)gameName
                 questionsAmount:(int)questionsAmount
          numberOfResponsOptions:(int)numberOfButtons;

@end
