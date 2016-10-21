//
//  ZYCustomFlurView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCustomBlurView.h"

@interface ZYCustomBlurView ()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView             *colorView;
@end

@implementation ZYCustomBlurView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode=UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;
        _blurEffectStyle = UIBlurEffectStyleLight;
        _blurAlpha=1.0;
        _blurColor=[UIColor blackColor];
        _colorAlpha=0.3;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //毛玻璃
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:_blurEffectStyle];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.alpha=_blurAlpha;
    _effectView.frame = self.bounds;
    [self addSubview:_effectView];
    
    //调色图层
    _colorView=[[UIView alloc]initWithFrame:self.bounds];
    _colorView.backgroundColor=_blurColor;
    _colorView.alpha=_colorAlpha;
    [_effectView addSubview:_colorView];
}


- (instancetype)initWithFrame:(CGRect)frame andBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle andBlurColor:(UIColor *)blurColor andBlurAlpha:(CGFloat)blurAlpha andColorAlpha:(CGFloat)colorAlpha
{
    self = [super initWithFrame:frame];
    if (self) {
        _blurEffectStyle=blurEffectStyle;
        _blurColor=blurColor;
        _blurAlpha=blurAlpha;
        _colorAlpha=colorAlpha;
        [self configUI];
    }
    return self;
}

- (void)setBlurColor:(UIColor *)blurColor
{
    _blurColor=blurColor;
    _colorView.backgroundColor=blurColor;
}

-(void) setBlurAlpha:(CGFloat)blurAlpha
{
    _blurAlpha=blurAlpha;
    _effectView.alpha=blurAlpha;
}

-(void) setColorAlpha:(CGFloat)colorAlpha
{
    _colorAlpha=colorAlpha;
    _colorView.alpha=colorAlpha;
}

@end
