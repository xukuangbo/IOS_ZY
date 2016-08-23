//
//  ZYZCTool+getLocalTime.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCTool+getLocalTime.h"

@implementation ZYZCTool (getLocalTime)
#pragma mark --- 获取本地时间
+(NSString *)getLocalTime
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *localTime=[formater stringFromDate:[NSDate date]];
    return localTime;
}

@end
