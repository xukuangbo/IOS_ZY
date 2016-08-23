//
//  GoalFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "GoalPeoplePickerView.h"
#import "FZCSingleTitleView.h"
#define FIRSTCELLHEIGHT (250 + singleTitleViewHeight + KEDGE_DISTANCE)
@interface GoalFirstCell : MoreFZCBaseTableViewCell
/**
 *  刷新数据,人数改变
 */
-(void)reloadViews;
@end
