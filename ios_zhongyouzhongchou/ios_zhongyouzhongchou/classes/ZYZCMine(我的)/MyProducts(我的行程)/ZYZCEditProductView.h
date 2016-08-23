//
//  ZYZCEditProductView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCListModel.h"
@interface ZYZCEditProductView : UIView
@property (nonatomic, strong) UserModel    *userModel;
//项目编号
@property (nonatomic, strong) NSNumber    *productId;
//项目类型
@property (nonatomic, assign) ProductType productType;
//我发布的行程的状态
@property (nonatomic, strong) NSNumber    *productState;
//我发布的行程是否有回报状态
@property (nonatomic, strong) NSNumber    *hasReturn;
//评价我参与项目的发起者或回报我的人的状态
@property (nonatomic, strong) NSNumber    *commentStatus;
//我参与的行程的状态
@property (nonatomic, strong) NSNumber    *joinProductState;
//我的回报的状态
@property (nonatomic, strong) NSNumber    *returnProductState;
//我参加的行程是否已结束
@property (nonatomic,assign ) BOOL         myJionProductEnd;

//提现状态：0申请提现,，1：审核中；2已提现
@property (nonatomic, strong) NSNumber    *txstatus;

//众筹项目成功，项目截止时间为0
@property (nonatomic, assign) BOOL       successBeforeTravel;

//行程结束状态（我发起的）1,行程结束；0(空值)：未结束
@property (nonatomic, strong) NSNumber    *endstatus;

//行程结束状态（我参与的）1,行程结束；0(空值)：未结束
@property (nonatomic, strong) NSNumber    *myEndstatus;

//延时出发的状态（我发起的）
@property (nonatomic, strong) NSNumber   *godelaystatus;

//延时出发的状态（我参与的）
@property (nonatomic, strong) NSNumber   *myGodelaystatus;

//退款状态（0等待退款，1.正在退款，2.已退款）
@property (nonatomic, strong) NSNumber   *myPaybackstatus;

//参与者是否投诉了发起者（我参与、我回报）
@property (nonatomic, strong) NSNumber   *myTsStatus;


@end
