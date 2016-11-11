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

//hbstatus = 1;
//headImage = "http://www.sosona.cn:8080/viewSpot/images/233/1471405959044_640.jpg";
//productDest = "[\"\U676d\U5dde\",\"\U585e\U73ed\U5c9b\",\"\U5b89\U7279\U536b\U666e\",\"\U5e03\U9c81\U65e5\"]";
//productEndTime = "2016-11-09";
//productId = 145;
//productName = "\U72d7\U72d7";
//productPrice = 100;
//productStartTime = "2016-10-27";
//pzstatus = 0;
//status = 5;
//travelendTime = "2016-11-08";
//travelstartTime = "2016-11-07";
//txstatus = 1;
//txtotles = 400;
@end
