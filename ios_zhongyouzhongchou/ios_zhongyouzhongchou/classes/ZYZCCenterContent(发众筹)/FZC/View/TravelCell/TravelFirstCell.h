//
//  TravelFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "GoalScheduleView.h"
#define TRAVELFIRSTCELLHEIGHT 140
@interface TravelFirstCell : MoreFZCBaseTableViewCell
@property(nonatomic, strong) GoalScheduleView *scheduleView;
@property(nonatomic, strong) UIScrollView *scroll;
-(void)reloadTravelData;
@end
