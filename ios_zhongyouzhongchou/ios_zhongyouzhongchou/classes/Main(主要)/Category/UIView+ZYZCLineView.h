//
//  UIView+ZYZCLineView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYZCLineView)
/**
 *  创建线条（color为nil为默认ZYZC_LineGrayColor）
 *
 */
+(UIView *)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color;
@end
