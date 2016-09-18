//
//  LiveMoneyView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "LiveMoneyView.h"
#import <Masonry.h>
#import "UIView+ZYLayer.h"
@interface LiveMoneyView ()
@end
@implementation LiveMoneyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
    self.layerCornerRadius = LiveMoneyViewH * 0.5;
    
    CGFloat margin = 3;
    _moneyLabel = [UILabel new];
    [self addSubview:_moneyLabel];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont systemFontOfSize:15];
    
    _rightView = [UIImageView new];
    [self addSubview:_rightView];
    _rightView.image = [UIImage imageNamed:@"btn_rightin"];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-margin);
        make.top.equalTo(self.mas_top).offset(margin);
        make.bottom.equalTo(self.mas_bottom).offset(-margin);
        make.width.mas_equalTo(10);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightView.mas_right);
        make.left.equalTo(self.mas_left).offset(KEDGE_DISTANCE);
        make.top.equalTo(self.mas_top).offset(margin);
        make.bottom.equalTo(self.mas_bottom).offset(-margin);
    }];
}
@end
