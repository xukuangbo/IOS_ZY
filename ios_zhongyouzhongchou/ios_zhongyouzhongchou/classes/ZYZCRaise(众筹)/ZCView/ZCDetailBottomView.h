//
//  ZCDetailBottomView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZCListModel.h"

typedef NS_ENUM(NSInteger, ZCBottomButtonType)
{
    CommentType=KZC_DETAIL_BOTTOM_TYPE,
    SupportType,
    RecommendType
};

typedef void (^ButtonClickBlock)(ZCBottomButtonType buttonType);
typedef void (^PayMoneyBlock)(NSNumber *productId);

@interface ZCDetailBottomView : UIView

@property (nonatomic, assign) DetailProductType detailProductType;

@property (nonatomic, assign) BOOL   surePay;       //标记：是否支付

@property (nonatomic, copy  ) ButtonClickBlock buttonClick;

@property (nonatomic, copy  ) PayMoneyBlock   payMoneyBlock;

//是否众筹结束
@property (nonatomic, assign) BOOL            productEndTime;


@end
