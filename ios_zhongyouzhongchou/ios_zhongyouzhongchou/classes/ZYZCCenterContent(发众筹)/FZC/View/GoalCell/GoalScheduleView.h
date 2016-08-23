//
//  GoalScheduleView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalScheduleView : UIView
//@property (nonatomic, strong) UILabel *startLab;
//@property (nonatomic, strong) UILabel *backLab;
@property (nonatomic, strong) NSString *startDay;
@property (nonatomic, strong) NSString *endDay;
//-(void)initViews;
-(void)getNormalState;
@end
