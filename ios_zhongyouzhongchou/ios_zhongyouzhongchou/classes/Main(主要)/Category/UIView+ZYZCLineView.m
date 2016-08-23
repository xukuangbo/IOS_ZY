//
//  UIView+ZYZCLineView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "UIView+ZYZCLineView.h"

@implementation UIView (ZYZCLineView)
+(UIView *)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    UIView *lineView=[[UIView alloc]initWithFrame:frame];
    if (color==nil) {
        lineView.backgroundColor=[UIColor ZYZC_LineGrayColor];
    }
    else
    {
        lineView.backgroundColor=color;
    }
    return lineView;
}
@end
