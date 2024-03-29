//
//  VersionTool.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "VersionTool.h"
@implementation VersionTool
+ (void)version{
    [ZYZCHTTPTool getHttpDataByURL:GetNewVersion withSuccessGetBlock:^(id result, BOOL isSuccess) {
        //        NSLog(@"%@",result);
        //拿到版本号进行一系列判断
        [VersionTool versionWithDic:result[@"data"]];
        
    } andFailBlock:^(id failResult) {
//        NSLog(@"版本请求失败%@",failResult);
    }];
}

+ (void)versionWithDic:(NSDictionary *)dic
{
    //我需要拿到一个属性字典，拿到是否升级的版本
    VersionModel *versionModel = [VersionModel mj_objectWithKeyValues:dic];
    //拿到当前版本号
    NSString *appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:KAPP_VERSION];
    if ([appVersion isEqualToString:versionModel.version]) {
        //版本相同，不需要跳转store
        return ;
    }else{
        if (versionModel.appupdate == 1) {//强制升级
            //版本不相同，需要跳转store
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有大版本更新啦~" message:versionModel.versionDesc preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *goStoreAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString * url = [NSString stringWithFormat:APP_STORE_URL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
            [alertController addAction:goStoreAction];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }else if(versionModel.appupdate == 2){//提示可升级
            
            //判断是否有值，有值就拿过来用，没有就设置为@0
            NSNumber *number = [VersionTool judgeIfHaveVersion];
            
//            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"firstVersion"]);

            if ([number isEqual:@1]) {
                //如果不是第一次进app，就直接返
                
                return ;
            }
            //版本不相同，需要跳转store
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本更新啦~" message:versionModel.versionDesc preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //设置为不是第一次进app
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"firstVersion"];
                
            }];
            UIAlertAction *goStoreAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //设置为不是第一次进app
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"firstVersion"];
                
                NSString * url = [NSString stringWithFormat:APP_STORE_URL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:goStoreAction];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }else if(versionModel.appupdate == 3){//不提示的更新
            //不需要动作
        }
    }
}

#pragma mark ---刚进app的时候将版本号置为0
+ (NSNumber *)judgeIfHaveVersion
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] valueForKey:@"firstVersion"];
    if (number) {
        return number;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"firstVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        number = @0;
        return number;
    }
}
#pragma mark ---退出app的时候移除刚进app
+ (void)removeHaveVersion{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    [user setObject:@0 forKey:@"firstVersion"];
    
    [user synchronize];
}
@end
