//
//  DoLiveHeadView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define DoLiveHeadViewHeight 40
#import <UIKit/UIKit.h>
@class MZTimerLabel;


@interface DoLiveHeadView : UIView
/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 计时label */
@property (nonatomic, strong) MZTimerLabel *timeLabel;
/** 人数显示 */
@property (nonatomic, strong) UILabel *numberPeopleLabel;
/**
 *  计时开始
 */
- (void)starTimer;
/**
 *  计时结束
 */
- (void)stopTimer;
@end
