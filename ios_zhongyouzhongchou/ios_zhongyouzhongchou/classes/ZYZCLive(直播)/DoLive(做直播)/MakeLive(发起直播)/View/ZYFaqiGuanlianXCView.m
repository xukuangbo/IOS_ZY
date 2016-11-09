//
//  ZYFaqiGuanlianXCView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/18.
//  Copyright © GuanlianViewH16年 liuliang. All rights reserved.
//

#import "ZYFaqiGuanlianXCView.h"
#import <Masonry.h>
#import "UIView+ZYLayer.h"
@implementation ZYFaqiGuanlianXCView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}


- (void)setUpSubviews
{
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"关联众筹行程:";
    
    _travelLabel = [UILabel new];
    [self addSubview:_travelLabel];
    _travelLabel.textColor = [UIColor ZYZC_TextMainColor];
    _travelLabel.font = [UIFont systemFontOfSize:17];
    _travelLabel.text = @"         ";
    
    _judgeTravelButton = [UIButton new];
    [self addSubview:_judgeTravelButton];
    _judgeTravelButton.selected = YES;
    [_judgeTravelButton setImage:[UIImage imageNamed:@"live-selected"] forState:UIControlStateSelected];
    [_judgeTravelButton setImage:[UIImage imageNamed:@"live-selected-2"] forState:UIControlStateNormal];
    [_judgeTravelButton addTarget:self action:@selector(judgeTravelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    titleLabel.backgroundColor = [UIColor redColor];
//    _travelLabel.backgroundColor = [UIColor yellowColor];
//    _judgeTravelButton.backgroundColor = [UIColor greenColor];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@GuanlianViewH);
        make.width.equalTo(@80);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
    }];
    
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(_judgeTravelButton.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [_judgeTravelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GuanlianViewH, GuanlianViewH));
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (void)judgeTravelButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
@end
