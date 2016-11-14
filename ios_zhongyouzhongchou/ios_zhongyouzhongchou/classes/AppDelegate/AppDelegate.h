//
//  AppDelegate.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXOrderModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  订单号model(支付时，杀死支付平台后进入app时使用)
 */
@property (nonatomic, strong) WXOrderModel *orderModel;

/**
 *  是否已处于聊天列表
 */
@property (nonatomic, assign) BOOL     enterChatList;


@end

