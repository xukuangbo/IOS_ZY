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


@end
