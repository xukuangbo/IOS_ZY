//
//  ProductTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//我的众筹列表中区分我发布，我参与，我推荐
typedef NS_ENUM(NSInteger, K_MyProductType)
{
    K_MyPublishType=1,
    K_MyJoinType,
    K_MyRecommendType
};


#import "ZYZCBaseTableView.h"

@interface ProductTableView : ZYZCBaseTableView

@property (nonatomic, assign) K_MyProductType myProductType;

@property (nonatomic, assign) BOOL           getRefreash;

@property (nonatomic, assign) BOOL           hiddenScrollBtn;

@property (nonatomic, assign) BOOL           hiddenNoneDataView;


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andMyProductType:(K_MyProductType ) myProductType;


@end
