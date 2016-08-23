//
//  WalletMingXiModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletMingXiModel : NSObject
//buyDate = "2016-07-06";//
@property (nonatomic, copy) NSString *buyDate;
//buyPrice = 100;
@property (nonatomic, assign) CGFloat buyPrice;
//department = "ART DESIGN";
//faceImg = "http://wx.qlogo.cn/mmopen/1giaZZicLzGZS24WLORvJyicksTt3cPMUDribbDuQhaayD64WmVOxiclKMNG07IefibUFicJLiamM5YrkHeicriae4ERpF9g/132";
@property (nonatomic, copy) NSString *faceImg;
//openid = "oQGFKxNYiUU1uyAjVTdU-Y9Hff6w";
//realName = "\U770b\U5565\U770b";
@property (nonatomic, copy) NSString *realName;
//sex = 1;
//style1:支持1元
//style2: 支持任意金额的钱数
//style3: 回报支持一钱数
//style4: 一起去支付的钱数
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, copy  ) NSString *userName;
//userId = 33;
//userName = CHENG;
@end
