//
//  ZCListModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


typedef NS_ENUM(NSInteger, ProductType)
{
    ZCListProduct,          //众筹列表
    ZCDetailProduct,        //众筹详情
    MyPublishProduct,       //我的众筹
    MyJionProduct,          //我参加的众筹
    MyReturnProduct,        //我的回报
    MyDraftProduct,         //我的草稿
};

#pragma mark --- 众筹
typedef NS_ENUM(NSInteger, DetailProductType)
{
    PersonDetailProduct,
    MineDetailProduct,
    SkimDetailProduct,
    DraftDetailProduct
};

@class ZCOneModel,ZCProductModel,ZCSpellbuyproductModel;

@interface ZCListModel : NSObject

@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, strong) NSArray  *data;

@end


@interface ZCOneModel : NSObject

@property (nonatomic, strong) NSDictionary    *country;
@property (nonatomic, strong) ZCProductModel  *product;
@property (nonatomic, strong) ZCSpellbuyproductModel *spellbuyproduct;
@property (nonatomic, strong) UserModel       *user;
@property (nonatomic, assign) ProductType     productType;

@property (nonatomic, assign) BOOL            mySelf;

@end

@interface ZCProductModel : NSObject

@property (nonatomic, strong) NSNumber *down;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy  ) NSString *headImage;
@property (nonatomic, copy  ) NSString *productDest;
@property (nonatomic, copy  ) NSString *productEndTime;
@property (nonatomic, copy  ) NSString *productName;
@property (nonatomic, strong) NSNumber *productPrice;
@property (nonatomic, copy  ) NSString *productStartTime;
@property (nonatomic, copy  ) NSString *travelstartTime;
@property (nonatomic, copy  ) NSString *travelendTime;
@property (nonatomic, strong) NSNumber *up;
@property (nonatomic, strong) NSNumber *friendsCount;

//我参与，我的回报中的状态参数
@property (nonatomic, strong) NSNumber *myStatus;

//评价我参与项目的发起者或回报我的人的状态（是否已评价）
@property (nonatomic, strong) NSNumber *myPjStatus;

//我发布的众筹是否有回报状态
@property (nonatomic, strong) NSNumber *hasHb;

//行程结束状态（我发起的）1,行程结束；0(空值)：未结束
@property (nonatomic, strong) NSNumber    *endstatus;

//行程结束状态（我参与的）1,行程结束；0(空值)：未结束
@property (nonatomic, strong) NSNumber    *myEndstatus;

//提现状态：0申请提现,，1：审核中；2已提现
@property (nonatomic, strong) NSNumber    *txstatus;

//延时出发的状态（我发起的） 0.未点击延时出发 1.已点击延时出发
@property (nonatomic, strong) NSNumber    *godelaystatus;

//延时出发的状态（我发起的） 0.未点击延时出发 1.已点击延时出发
@property (nonatomic, strong) NSNumber    *myGodelaystatus;

//退款状态（0等待退款，1.正在退款，2.已退款）
@property (nonatomic, strong) NSNumber    *myPaybackstatus;

//参与者是否投诉了发起者（我参与、我回报）
@property (nonatomic, strong) NSNumber    *myTsStatus;

@end


@interface ZCSpellbuyproductModel : NSObject

@property (nonatomic, strong) NSNumber *spellRealBuyCount;
@property (nonatomic, strong) NSNumber *buyable;
@property (nonatomic, strong) NSNumber *spellbuyProductId;
@property (nonatomic, strong) NSNumber *fkProductId;
@property (nonatomic, strong) NSNumber *lotteryable;
@property (nonatomic, strong) NSNumber *annable;
@property (nonatomic, strong) NSNumber *spellRealBuyPrice;
@property (nonatomic, strong) NSNumber *realzjeNew;
@end




