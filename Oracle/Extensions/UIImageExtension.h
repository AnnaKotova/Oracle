//
//  UIImageExtension.h
//  Oracle
//
//  Created by Ann Kotova on 12/7/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface UIImage (UIImageExtension)

+ (UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height;
- (UIImage *)imageThatFitsSize:(CGSize)size;

@end
