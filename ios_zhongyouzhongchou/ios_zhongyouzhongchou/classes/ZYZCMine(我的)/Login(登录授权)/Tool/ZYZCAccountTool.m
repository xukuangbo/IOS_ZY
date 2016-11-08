//
//  ZYZCAccountTool.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 liuliang. All rights reserved.
//
// 账号的存储路径
#define HWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MediaUtils.h"
#import "ZYZCRCManager.h"

#import "ZYZCRCManager.h"
#import "JPUSHService.h"
#import  <QPSDKCore/QPSDKCore.h>

@implementation ZYZCAccountTool
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(ZYZCAccountModel *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:HWAccountPath];
    
    if (account.userId) {
        //趣拍鉴权
        [ZYZCAccountTool getQuPaiAuthWithResultBlock:nil];
        
        //注册成功,获取融云token
        ZYZCRCManager *RCManager=[ZYZCRCManager defaultManager];
        RCManager.hasLogin=NO;
        [RCManager getRCloudToken];
        
        //注册JPush别名,两个都为nil表示不调用回调，即不去验证是否注册成功
        [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@",account.userId] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            //NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
        }];
    }
}

#pragma mark --- 取我的userId
+ (NSString *)getUserId
{
    ZYZCAccountModel  *accountModel=[[self class] account];
    return [accountModel.userId stringValue] ;
}

#pragma mark --- 取我的openid
+ (NSString *)getOpenid
{
    ZYZCAccountModel  *accountModel=[[self class] account];
    return accountModel.openid;
}

#pragma mark --- 取我的scret
+ (NSString *)getUserScret
{
    ZYZCAccountModel  *accountModel=[[self class] account];
    return accountModel.scr;
}

#pragma mark --- 存储融云的token
+ (void)saveRCloudToken:(NSString *)token
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:token forKey:KCHAT_TOKEN];
    [user synchronize];
}

#pragma mark --- 获取融云的token
+ (NSString *) getRCloudToken
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:KCHAT_TOKEN];
    return token;
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (ZYZCAccountModel *)account
{
    // 加载模型
    ZYZCAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HWAccountPath];
    
    /* 验证账号是否过期 */
    
    // 过期的秒数
//    long long expires_in = [account.expires_in longLongValue];
//    // 获得过期时间
//    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
//    // 获得当前时间
//    NSDate *now = [NSDate date];
//    
//    // 如果expiresTime <= now，过期
//    /**
//     NSOrderedAscending = -1L, 升序，右边 > 左边
//     NSOrderedSame, 一样
//     NSOrderedDescending 降序，右边 < 左边
//     */
//    NSComparisonResult result = [expiresTime compare:now];
//    if (result != NSOrderedDescending) { // 过期
//        
//        //先判断refresh过期没（30天有效期）
//        long long refresh_expires_in = 30 * 24 * 60 * 60;
//        //如果过期了，得先去判断refresh过期了没
//        NSDate *refreshTime = [account.created_time dateByAddingTimeInterval:refresh_expires_in];
//        NSComparisonResult refresh_result = [refreshTime compare:now];
//        if (refresh_result != NSOrderedDescending) {
//            return nil;
//        }else{
//            //这里应该去用refresh_token去重新获取access_token，以后再写
//#warning refresh_token 换取access_token
//        }
//        
//
//        return nil;
//    }
    
    return account;
}

#pragma mark --- 删除用户，及融云token
+(void)deleteAccount
{
    //删除个人信息
    [MediaUtils deleteFileByPath:HWAccountPath];
    
    [ZYZCAccountTool getUserId];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    //删除融云token
    [user setObject:nil forKey:KCHAT_TOKEN];
     //删除趣拍鉴权结果
    [user setObject:nil forKey:Auth_QuPai_Result];
    [user synchronize];
    
    //将融云的登录标记设置为no
    ZYZCRCManager *rcManager=[ZYZCRCManager defaultManager];
    rcManager.hasLogin=NO;
    
    
}

#pragma mark ---  获取用户未读系统消息数
+ (void)getUserUnReadMsgCount:(UnReadMsgBlock)unReadMsgBlock
{
    if (![ZYZCAccountTool getUserId]) {
        return;
    }
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"systemMsg_unReadTotles"] andParameters:@{@"userId":[ZYZCAccountTool getUserId]} andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         DDLog(@"%@",result);
         if (isSuccess )
         {
             unReadMsgBlock([result[@"data"] integerValue]);
         }
    }
     andFailBlock:^(id failResult) {
         DDLog(@"%@",failResult);
                                 
     }];
}

#pragma mark --- 趣拍鉴权
+ ( void)getQuPaiAuthWithResultBlock:(void(^)(BOOL result))resultBlock
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *auth_result=[user objectForKey:Auth_QuPai_Result];
    //已鉴权成功
    if ([auth_result isEqualToString:@"yes"])
    {
        if (resultBlock) {
            resultBlock(YES);
        }
    }
    else
    {
        NSString *userId=[ZYZCAccountTool getUserId];
        if (!userId) {
            if (resultBlock) {
                resultBlock(NO);
            }
        }
        else{
            //鉴权
            NSString *QPAppSecret = kQPAppSecret([ZYZCAPIGenerate sharedInstance].serverType);
            NSString *QPAppKey = kQPAppKey([ZYZCAPIGenerate sharedInstance].serverType);
           
            [[QPAuth shared] registerAppWithKey:QPAppKey secret:QPAppSecret space:userId success:^(NSString *accessToken) {
                DDLog(@"qupai_accessToken:%@",accessToken);
                //鉴权成功
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setObject:@"yes" forKey:Auth_QuPai_Result];
                [user synchronize];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   if (resultBlock) {
                                        resultBlock(YES);
                                   }
                               });
            } failure:^(NSError *error) {
                //鉴权失败
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setObject:@"no" forKey:Auth_QuPai_Result];
                [user synchronize];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   if (resultBlock) {
                                        resultBlock(NO);
                                   }
                               });
            }];
        }
    }
}


@end
