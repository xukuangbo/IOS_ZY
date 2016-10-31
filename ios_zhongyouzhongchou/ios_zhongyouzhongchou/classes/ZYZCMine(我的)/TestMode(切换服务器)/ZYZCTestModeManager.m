//
//  ZYZCTestModeManager.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCTestModeManager.h"
static NSString *const kUserInfoServerStatus = @"kUserInfoServerStatus";

@implementation ZYZCTestModeManager
/**
 *  设置服务器地址状态
 */
+ (void)setServerStatus:(NSInteger)serverStatus
{
    [self saveToUserDefaultsInteger:serverStatus forKey:kUserInfoServerStatus];
}

+ (NSInteger)getServerStatus
{
    return [self integerFromUserDefaultsKey:kUserInfoServerStatus];
}


+ (NSInteger)integerFromUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)saveToUserDefaultsInteger:(NSInteger)intValue forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:intValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
