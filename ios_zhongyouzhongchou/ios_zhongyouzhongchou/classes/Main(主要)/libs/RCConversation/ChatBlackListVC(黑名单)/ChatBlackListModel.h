//
//  ChatBlackListModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatBlackListModel : NSObject
//faceImg = "http://wx.qlogo.cn/mmopen/1giaZZicLzGZS24WLORvJyicksTt3cPMUDribbDuQhaayD64WmVOxiclKMNG07IefibUFicJLiamM5YrkHeicriae4ERpF9g/132";
@property (nonatomic, copy) NSString *faceImg;
//realName = "\U770b\U5565\U770b";
@property (nonatomic, copy) NSString *realName;
//userId = 33;
@property (nonatomic, strong) NSNumber *userId;
//userName = CHENG;
@property (nonatomic, copy) NSString *userName;
@end
