//
//  OpenSetTool.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "OpenSetTool.h"

//系统版本
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0

#define IOS_8_Later    floorf([[UIDevice currentDevice].systemVersion floatValue]) >=8.0 ? 1 : 0
#define IOS_9_Later  floorf([[UIDevice currentDevice].systemVersion floatValue]) >=9.0 ? 1 : 0

@implementation OpenSetTool

+ (void)judgeOpenSet
{
    //是否有点击过设置
    NSNumber *hasPrintSet = [[NSUserDefaults standardUserDefaults] valueForKey:@"hasPrintSet"];
    if (hasPrintSet) {
        //如果有值，直接往下判断
        
    }else{
        //如果没有值，就设为@0
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"hasPrintSet"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        hasPrintSet = @0;
        
    }
    
    if ([hasPrintSet isEqual:@1]) {//如果为1，即为设置过
        return ;
    }else{//没有设置过，则弹出alert警告框
        
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:<#(UIAlertControllerStyle)#>
        
    }
}

#pragma mark ---打开系统定位设置服务
+ (void)openSet_LOCATION_SERVICES
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (IOS_8_Later) {//ios8之后可以直接跳到系统设置中的app设置
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }else{
//            NSLog(@"打不开系统设置啊~");
        }
        
    }else{//ios 8之前的系统只能跳到系统层
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
    
}
@end
