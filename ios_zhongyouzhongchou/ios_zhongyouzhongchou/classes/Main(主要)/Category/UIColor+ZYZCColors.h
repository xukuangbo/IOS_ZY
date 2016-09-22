//
//  UIColor+ZYZCColors.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZYZCColors)
//主色调
+ (UIColor *)ZYZC_MainColor;
//文字主色调
+ (UIColor *)ZYZC_TextMainColor;
//导航栏色调
+ (UIColor *)ZYZC_NavColor;
//背景灰色
+ (UIColor *)ZYZC_BgGrayColor;

+ (UIColor *)ZYZC_BgGrayColor01;

+ (UIColor *)ZYZC_BgGrayColor02;
//自定义TabBar背景色
+ (UIColor *)ZYZC_TabBarGrayColor;
//文字灰色
+ (UIColor *)ZYZC_TextGrayColor;

+ (UIColor *)ZYZC_TextGrayColor01;

+ (UIColor *)ZYZC_TextGrayColor02;

+ (UIColor *)ZYZC_TextGrayColor03;

+ (UIColor *)ZYZC_TextGrayColor04;

+ (UIColor *)ZYZC_RedTextColor;

+ (UIColor *)ZYZC_LineGrayColor;

+ (UIColor *)ZYZC_TextBlackColor;

+ (UIColor *)ZYZC_CenterContentTextColor;

+ (UIColor *)ZYZC_titleBlackColor;

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)hex withAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hex;

@end
