//
//  WXOrderModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXOrderModel : NSObject
@property (nonatomic, copy  ) NSString  *out_trade_no;//订单号
@property (nonatomic, assign) BOOL      payResult;    //支付结果
@property (nonatomic, assign) NSInteger orderType;
//1.众筹项目支持 2.打赏支持

//状态重置
-(void)initOrderState;

@end
