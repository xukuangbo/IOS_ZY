//
//  DoLiveHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "DoLiveHeadView.h"
#import <Masonry.h>
#import "UIView+ZYLayer.h"
#import "MZTimerLabel.h"
@interface DoLiveHeadView ()<MZTimerLabelDelegate>

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 计时label */
@property (nonatomic, strong) MZTimerLabel *timeLabel;
/** 人数显示 */
@property (nonatomic, strong) UILabel *numberPeopleLabel;
@end
@implementation DoLiveHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubviews];
        
        
        [self starTimer];
    }
    return self;
}

- (void)setUpSubviews
{
    self.backgroundColor = [UIColor yellowColor];
    //圆角半径
    CGFloat layRadius = DoLiveHeadViewHeight * 0.5;
    //间隙
    CGFloat DoLiveHeadMargin = 3;
    //头像高度
    CGFloat iconViewHeight = DoLiveHeadViewHeight - DoLiveHeadMargin * 2;
    //时间高度
    CGFloat timelabelHeight = (iconViewHeight - DoLiveHeadMargin) * 0.5;
    
    
    self.layerCornerRadius = layRadius;
    //添加控件
    _iconView = [UIImageView new];
    [self addSubview:_iconView];
    _iconView.layerCornerRadius = iconViewHeight * 0.5;
    _iconView.backgroundColor = [UIColor redColor];
    
    _timeLabel = [MZTimerLabel new];
    _timeLabel.delegate = self;
    [self addSubview:_timeLabel];
    _timeLabel.backgroundColor = [UIColor redColor];
    _timeLabel.timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    _numberPeopleLabel = [UILabel new];
    [self addSubview:_numberPeopleLabel];
    _numberPeopleLabel.backgroundColor = [UIColor redColor];
    
    
    //添加约束
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).offset(3);
        make.size.mas_equalTo(CGSizeMake(iconViewHeight, iconViewHeight));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView);
        make.left.mas_equalTo(_iconView.mas_right).offset(DoLiveHeadMargin);
        make.right.mas_equalTo(-(layRadius * 0.5));
        make.height.mas_equalTo(timelabelHeight);
    }];
    
    [_numberPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(DoLiveHeadMargin);
        make.left.mas_equalTo(_iconView.mas_right).offset(DoLiveHeadMargin);
        make.right.mas_equalTo(_timeLabel.mas_right);
        make.height.mas_equalTo(timelabelHeight);
    }];
    
}


- (void)starTimer
{
    if (!_timeLabel) {
        return ;
    }
    
    [_timeLabel start];
}

- (void)stopTimer
{
    if (!_timeLabel) {
        return ;
    }
    [_timeLabel pause];
}

#pragma mark - timeLabelDelegate
//完成计时
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    
}
//-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType
//{
//    
//}
//-(NSString*)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
//{
//    
//}
@end
