//
//  UIImage+plus.h
//  iShowVideoTalk
//
//  Created by DING FENG on 5/20/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (plus)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)  size;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageWithColor:(UIColor *)color1;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize ;
+ (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image;

@end
