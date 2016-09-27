//
//  ZYTravelTypeView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TravelType)
{
    Travel_PublishType=1,
    Travel_JoinType,
    Travel_RecommendType
};

typedef void (^ChangeTravelType)(TravelType travelType) ;

@interface ZYTravelTypeView : UIView

@property (nonatomic, strong) NSArray         *items;//按钮标题

@property (nonatomic, copy  ) ChangeTravelType changeTravelType;//行程切换（发起／参与／推荐）

@end
