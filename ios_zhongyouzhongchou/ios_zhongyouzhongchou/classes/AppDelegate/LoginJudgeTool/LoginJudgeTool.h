//
//  LoginJudgeTool.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/30.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginJudgeController.h"

@interface LoginJudgeTool : NSObject


/**
 *  登录
 */
+ (BOOL)judgeLogin;


/**
 *  appdelegate的登录判断
 */
+ (BOOL)rootJudgeLogin;

/**
 *  提示登录框
 */
+ (void)showLoginTips;
@end
