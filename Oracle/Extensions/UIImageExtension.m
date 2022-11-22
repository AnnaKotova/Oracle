//
//  UIImageExtension.m
//  Oracle
//
//  Created by Ann Kotova on 12/7/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "UIImageExtension.h"

@implementation UIImage (UIImageExtension)

+ (UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height
{
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                width,
                                                height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4 * width,
                                                colorspace,/* CGImageGetColorSpace(imageRef) image may have unsupported ColorSpace */
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast /* some image may return CGImageGetAlphaInfo(image) == kCGImageAlphaNone, but it's not */) ;
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGColorSpaceRelease(colorspace);
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;	
}

- (UIImage *)imageThatFitsSize:(CGSize)size
{
    CGFloat maxSide = MAX(self.size.width, self.size.height);
    
    if (maxSide > 0)
    {
        CGFloat ratio = MIN(size.width/maxSide, size.height/maxSide);
        CGFloat width = self.size.width * ratio;
        CGFloat height = self.size.height * ratio;
        return [UIImage resizeImage:self width:width height:height];
    }
    else
    {
        return self;
    }
}

@end
