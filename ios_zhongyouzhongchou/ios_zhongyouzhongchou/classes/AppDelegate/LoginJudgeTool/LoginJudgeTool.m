//
//  LoginJudgeTool.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/30.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "LoginJudgeTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCTabBarController.h"
#import "ZYZCNavigationController.h"
@implementation LoginJudgeTool
+ (BOOL)judgeLogin
{
    
    
    NSString *userid = [ZYZCAccountTool getUserId];
    if (userid) {
        //如果有账号,直接返回
        return YES;
    }else{
        //表示没有账号,这里要弹出一个控制器
        
        LoginJudgeController *loginVC = [[LoginJudgeController alloc] init];
        
        ZYZCNavigationController *naviVC = [[ZYZCNavigationController alloc] initWithRootViewController:loginVC];
        
        naviVC.navigationBar.hidden = YES;
        
        [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
        
        return NO;
    }

}

+ (BOOL)rootJudgeLogin
{
    
    NSString *userid = [ZYZCAccountTool getUserId];
    if (userid) {
        //如果有账号,就设置跟控制器为tabbar
        UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZYZCTabBarController *mainTab=[storyboard instantiateViewControllerWithIdentifier:@"ZYZCTabBarController"];
        [UIApplication sharedApplication].keyWindow.rootViewController= mainTab;
        
        return YES;
    }else{
        //表示没有账号,这里要弹出一个控制器
        
        LoginJudgeController *loginVC = [[LoginJudgeController alloc] init];
        
        ZYZCNavigationController *naviVC = [[ZYZCNavigationController alloc] initWithRootViewController:loginVC];
        
        naviVC.navigationBar.hidden = YES;
        
        [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
        
        return NO;
    }
}


+ (void)showLoginTips
{
    [MBProgressHUD showError:@"请登录后操作"];
}
@end
