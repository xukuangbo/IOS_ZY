//
//  WalletOutRecordModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletOutRecordModel : NSObject
//toWhere   转出去哪  wechat：微信；alipay 支付宝
@property (nonatomic, copy) NSString *toWhere;
//amount    转出金额（单位 分）
@property (nonatomic, assign) NSInteger amount;
//createDate  申请时间
@property (nonatomic, copy) NSString *createDate;
//paymentTime 到账时间
@property (nonatomic, copy) NSString *paymentTime;
//status  0 待打款；1已打款
@property (nonatomic, assign) NSInteger status;

@end
