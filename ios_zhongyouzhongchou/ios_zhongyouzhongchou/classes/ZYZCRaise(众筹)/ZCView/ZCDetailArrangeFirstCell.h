//
//  ZCDetailArrangeFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailIntroFirstCell.h"
#import "ZCWSMView.h"
#import "MoreFZCTravelOneDayDetailMdel.h"
@interface ZCDetailArrangeFirstCell : MoreFZCBaseTableViewCell

@property (nonatomic, strong) MoreFZCTravelOneDayDetailMdel *oneDaydetailModel;
@property (nonatomic, strong) ZCWSMView *wsmView;

@property (nonatomic, assign) BOOL hasSight;//景点

@property (nonatomic, assign) BOOL hasTrans; //交通

@property (nonatomic, assign) BOOL hasLive; //住宿

@property (nonatomic, assign) BOOL hasFood; //饮食

@property (nonatomic, copy  ) NSString *faceImg;

@property (nonatomic, strong) NSString *startDay;

@end
