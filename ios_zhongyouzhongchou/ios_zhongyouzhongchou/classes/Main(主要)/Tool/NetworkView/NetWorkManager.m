//
//  NetWorkManager.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "NetWorkManager.h"
#import "MBProgressHUD+MJ.h"
@implementation NetWorkManager

+ (void)getFailViewForView:(UIView *)view  andReFrashBlock:(ReFrashBlock)reFrashBlock
{
    NetFailView *netFailView=[[NetFailView alloc]init];
    if (!view) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:netFailView];
    }
    else
    {
        [view addSubview:netFailView];
    }
    
    netFailView.reFrashBlock=reFrashBlock;
}

#pragma mark --- 展示断网界面

+ (void)getFailViewForView:(UIView *)view andFailResult:(id)failResult andReFrashBlock:(ReFrashBlock)reFrashBlock
{
    
    NetFailView *netFailView=[[NetFailView alloc]initWithFailResult:failResult];
    if (!view) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:netFailView];
    }
    else
    {
        [view addSubview:netFailView];
    }
    
    netFailView.reFrashBlock=reFrashBlock;
}

#pragma mark --- 隐藏断网界面
+ (void)hideFailViewForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[NetFailView class]]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark --- 网络错误，只展示mb提示
+ (void) showMBWithFailResult:(id)failResult
{
    NSString *error=ZYLocalizedString(@"unkonwn_error");
    
    if ([failResult isKindOfClass:[NSString class]])
    {
        if ([failResult isEqualToString:@"似乎已断开与互联网的连接。"]) {
            error =ZYLocalizedString(@"no_netwrk");
        }
        else if ([failResult isEqualToString:@"未能连接到服务器。"])
        {
            error =ZYLocalizedString(@"no_service");
        }
        else if ([failResult isEqualToString:@"未能读取数据，因为它的格式不正确。"])
        {
            error =ZYLocalizedString(@"unusual_service");
        }
        else
        {
           error =ZYLocalizedString(@"unkonwn_error");
        }
    }
    
    [MBProgressHUD showShortMessage:error];

}

+ (void)netFailWithMB
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"您的网络好像不太给力哦~";
    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}


@end
