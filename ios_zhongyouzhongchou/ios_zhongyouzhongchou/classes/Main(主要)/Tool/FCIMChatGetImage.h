//
//  FCIMChatGetImage.h
//  Pods
//
//  Created by FZDubbing on 10/12/15.
//
//

#import <Foundation/Foundation.h>

@interface FCIMChatGetImage : NSObject

+ (UIImage*)rotateImage:(UIImage *)image;

+ (UIImage *)rotateScreenImage:(UIImage *)image;

+ (UIImage *)rotateImage:(UIImage *)image maxWidth:(NSInteger)maxWidth maxHeight:(NSInteger)maxHeight;

@end
