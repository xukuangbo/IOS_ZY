//
//  JudgeAuthorityTool.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "JudgeAuthorityTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
@implementation JudgeAuthorityTool

#pragma mark --- 判断相册是否被禁用
+ (BOOL)judgeAlbumAuthority
{
    //判断相册是否被禁用
    ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
    {
        //不允许
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"您屏蔽选择相册的权限，开启请去系统设置->隐私->我的App来打开权限" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark --- 判断相机是否被禁用
+ (BOOL)judgeMediaAuthority
{
    //判断应用是否有使用相机的权限
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //不允许
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"您屏蔽应用相机的权限，开启请去系统设置->隐私->我的App来打开权限" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark --- 判断麦克风是否被禁用
+ (BOOL)judgeRecordAuthority
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *avSession = [AVAudioSession sharedInstance];
        
        if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [avSession requestRecordPermission:^(BOOL available) {
                bCanRecord = available;
                if (available) {
                    //completionHandler
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"您屏蔽麦克风的使用权限，开启请去系统设置->隐私->我的App来打开权限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    return bCanRecord;
}

#pragma mark --- 定位权限
+ (BOOL)judgeLocationAuthority{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [[[UIAlertView alloc] initWithTitle:@"您屏蔽定位功能的权限，开启请去系统设置->隐私->我的App来打开权限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

@end






