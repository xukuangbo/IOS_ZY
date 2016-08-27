//
//  AppDelegate.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  获取订单号
 */
@property (nonatomic, strong) NSString *out_trade_no;

/**
 *  是否已处于聊天列表
 */
@property (nonatomic, assign) BOOL     enterChatList;

@end

