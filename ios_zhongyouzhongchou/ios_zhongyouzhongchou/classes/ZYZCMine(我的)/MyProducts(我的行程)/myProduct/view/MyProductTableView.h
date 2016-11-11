//
//  MyProductTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//我的众筹列表中区分我发布，我参与，我推荐
typedef NS_ENUM(NSInteger, MyProductType)
{
    MyPublishType=1,
    MyJoinType,
    MyRecommendType
};

#import "ZYZCBaseTableView.h"

@interface MyProductTableView : ZYZCBaseTableView

@property (nonatomic, assign) MyProductType myProductType;


@end
