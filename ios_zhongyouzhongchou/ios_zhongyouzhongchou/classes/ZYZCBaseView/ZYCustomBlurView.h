//
//  ZYCustomFlurView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCustomBlurView : UIImageView
//毛玻璃风格
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;
//颜色
@property (nonatomic, strong) UIColor     *blurColor;
//毛玻璃透明度
@property (nonatomic, assign) CGFloat     blurAlpha;
//颜色涂层的透明度
@property (nonatomic, assign) CGFloat     colorAlpha;

/**
 *  初始化方法
 *
 *  @param blurEffectStyle 毛玻璃风格
 *  @param blurColor       毛玻璃颜色
 *  @param blurAlpha       毛玻璃透明度
 *  @param colorAlpha      颜色透明度
 *
 *  @return 日期
 */
- (instancetype)initWithFrame:(CGRect)frame andBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle andBlurColor:(UIColor *)blurColor andBlurAlpha:(CGFloat)blurAlpha andColorAlpha:(CGFloat)colorAlpha;

@end
