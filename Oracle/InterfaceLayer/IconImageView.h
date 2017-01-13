//
//  IconImageView.h
//  Oracle
//
//  Created by Ann Kotova on 1/12/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconImageView : UIImageView

- (NSString *)imageFileNameInLocalFolder;

@property BOOL imageWasUpdate;

@end
