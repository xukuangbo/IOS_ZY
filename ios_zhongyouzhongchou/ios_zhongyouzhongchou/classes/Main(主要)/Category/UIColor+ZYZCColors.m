//
//  UIColor+ZYZCColors.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "UIColor+ZYZCColors.h"

@implementation UIColor (ZYZCColors)

+ (UIColor *)ZYZC_MainColor{
    return KCOLOR_RGB(35, 182, 183);
}

+ (UIColor *)ZYZC_TextMainColor{
    return KCOLOR_RGB(46, 243, 199);
}

+ (UIColor *)ZYZC_NavColor{
   return [[self ZYZC_MainColor] colorWithAlphaComponent:1.0];
}

+ (UIColor *)ZYZC_BgGrayColor{
    return KCOLOR_RGB(233, 233, 233);
}
+ (UIColor *)ZYZC_BgGrayColor01{
    return KCOLOR_RGB(246, 246, 246);
}
+ (UIColor *)ZYZC_BgGrayColor02{
    return KCOLOR_RGB(201, 201, 201);
}

+ (UIColor *)ZYZC_TabBarGrayColor{
    return KCOLOR_RGBA(231, 231, 231,0.95);
}
+ (UIColor *)ZYZC_TextGrayColor{
    return KCOLOR_RGB(152, 152, 152);
}
+ (UIColor *)ZYZC_TextGrayColor01{
    return KCOLOR_RGB(150, 150, 150);
}
+ (UIColor *)ZYZC_TextGrayColor02{
    return KCOLOR_RGB(213, 213, 213);
}
+ (UIColor *)ZYZC_TextGrayColor03{
    return KCOLOR_RGB(138, 138, 138);
}
+ (UIColor *)ZYZC_TextGrayColor04{
    return KCOLOR_RGB(173, 173, 173);
}
+ (UIColor *)ZYZC_LineGrayColor{
    return KCOLOR_RGB(223, 223, 223);
}
+ (UIColor *)ZYZC_TextBlackColor{
    return KCOLOR_RGB(102, 102, 102);
}

+ (UIColor *)ZYZC_titleBlackColor{
    return KCOLOR_RGB(84, 84, 84);
}

+ (UIColor *)ZYZC_CenterContentTextColor{
    return KCOLOR_RGB(0, 255, 246);
}

+ (UIColor *)ZYZC_RedTextColor{
    return KCOLOR_RGB(234, 87, 87);
}

+ (UIColor *)colorWithHexString:(NSString *)hex withAlpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex{
    return [UIColor colorWithHexString:hex withAlpha:1];
}

+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha{
    
    CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat g = ((hex & 0x00FF00) >> 8 ) / 255.0;
    CGFloat b = ((hex & 0x0000FF)      ) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hex{
    return [UIColor colorWithHex:hex withAlpha:1];
}


- (UIColor *)colorCoveredWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
    Byte colorComponents[10  * 10 * 4] = { 0 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(colorComponents, 10, 10, 8, 40, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGFloat selfColorComponents[4];
    [self getRed:selfColorComponents green:selfColorComponents + 1 blue:selfColorComponents + 2 alpha:selfColorComponents + 3];
    CGContextSetFillColor(context, selfColorComponents);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 10.0f, 10.0f));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    [path fill];
    
    [color setFill];
    [path fillWithBlendMode:blendMode alpha:1.0f];
    
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *retval = [UIColor colorWithRed:colorComponents[0]/255.0
                                      green:colorComponents[1]/255.0
                                       blue:colorComponents[2]/255.0
                                      alpha:colorComponents[3]/255.0];
    
    return retval;
}

- (UIColor *)colorCoveredWithColor:(UIColor *)color {
    return [self colorCoveredWithColor:color blendMode:kCGBlendModeNormal];
}

@end
