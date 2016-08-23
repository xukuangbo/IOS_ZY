//
//  ZYZCAccountTool.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYZCAccountModel.h"

typedef void (^UnReadMsgBlock)(NSInteger count);

@interface ZYZCAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(ZYZCAccountModel *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (ZYZCAccountModel *)account;

/**
 *  删除用户，及融云token
 */
+(void)deleteAccount;

/**
 *  取我的userId
 */
+ (NSString *)getUserId;

/**
 *  取我的openid
 */
+ (NSString *)getOpenid;

/**
 * 取我的scret
 */
+ (NSString *)getUserScret;

/**
 *  存储融云的token
 */
+ (void)saveRCloudToken:(NSString *)token;

/**
 *  获取融云的token
 */
+ (NSString *) getRCloudToken;

/**
 *  获取用户未读消息数
 */
+ (void)getUserUnReadMsgCount:(UnReadMsgBlock ) unReadMsgBlock;



@end
