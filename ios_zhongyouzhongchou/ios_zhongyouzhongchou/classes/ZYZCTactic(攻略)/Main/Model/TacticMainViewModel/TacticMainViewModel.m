//
//  TacticMainViewModel.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainViewModel.h"
#import "TacticModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZCWebViewController.h"
#import "ZYZCPlayViewController.h"
#import "TacticMainVC.h"
#import "TacticSingleViewController.h"
#import "TacticMoreVideoVC.h"
#import "TacticMoreCitiesVC.h"
@interface TacticMainViewModel ()
@property (nonatomic, copy) NSString *currenPlayURL;
@property (nonatomic, weak) TacticMainVC *mainVC;
@end
@implementation TacticMainViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[ZYNSNotificationCenter rac_addObserverForName:@"didSelectTableView" object:nil] subscribeNext:^(id x) {
            DDLog(@"点击了头饰图");
        }];
        
    }
    return self;
}

- (void)requestMainData
{
    NSString *url = GET_TACTIC;
    //访问网络
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            
            //请求成功，转化为数组
            [weakSelf fetchValueSuccessWithDic:result];
            
        }else{
            
            [weakSelf errorCodeWithDic:result];
        }
    } andFailBlock:^(id failResult) {
        
        [weakSelf netFailure];
    }];
}

#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSDictionary *) returnValue
{
    TacticModel *tacticModel = [TacticModel mj_objectWithKeyValues:returnValue[@"data"]];
    
    self.returnBlock(tacticModel);
}

#pragma 对ErrorCode进行处理
-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}

#pragma 对网路异常进行处理
-(void) netFailure
{
    self.failureBlock();
}

#pragma mark -
#pragma mark ---轮播图跳转到活动界面
-(void) pushWebVCWithURLString: (NSString *)urlString WithViewController: (UIViewController *)superController
{
    ZCWebViewController *webVC = [[ZCWebViewController alloc] init];
    webVC.myTitle = @"最新活动";
    webVC.requestUrl = urlString;
    [superController presentViewController:webVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark ---推送到国家详情控制器
-(void) pushCountryVCWithViewid: (NSNumber *)viewid WithViewController: (UIViewController *)superController
{
    TacticSingleViewController *singleVC = [[TacticSingleViewController alloc] initWithViewId:[viewid integerValue]];
    [superController.navigationController pushViewController:singleVC animated:YES];
}

#pragma mark -
#pragma mark ---推送到城市详情控制器
-(void) pushCityVCWithViewid: (NSNumber *)viewid WithViewController: (UIViewController *)superController
{
    TacticSingleViewController *singleVC = [[TacticSingleViewController alloc] initWithViewId:[viewid integerValue]];
    [superController.navigationController pushViewController:singleVC animated:YES];
}

#pragma mark -
#pragma mark ---推送到更多视频控制器
-(void) pushMoreVideosWithViewController: (UIViewController *)superController;
{
    TacticMoreVideoVC *moreVideoVC = [[TacticMoreVideoVC alloc] init];
    [superController.navigationController pushViewController:moreVideoVC animated:YES];
}

#pragma mark -
#pragma mark ---推送到更多国家或者城市控制器
-(void) pushMoreCountryCityVCWithViewtype:(NSInteger )viewtype WithViewController: (UIViewController *)superController;
{
    TacticMoreCitiesVC *moreVC = [[TacticMoreCitiesVC alloc] initWithViewType:viewtype];
    [superController.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark -
#pragma mark ---推送到视频播放控制器
-(void)pushVideoVCWithURLString: (NSString *)urlString WithViewController: (UIViewController *)superController
{
    self.currenPlayURL = urlString;
    self.mainVC = (TacticMainVC *)superController;
    [self judgeCurrentNetworkStatus];
}
#pragma mark ---判断当前网络
-(void)judgeCurrentNetworkStatus
{
    //获取当前网络状态
    int networkType=[ZYZCTool getCurrentNetworkStatus];
    //无网络
    if (networkType==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"当前无网络" message:@"无法播放视屏,请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=0;
        [alert show];
        return;
    }
    //无Wi-Fi
    else if(networkType!=5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"【流量使用提示】" message:@"当前网络无Wi-Fi,继续播放可能会被运营商收取流量费用" delegate:self cancelButtonTitle:@"停止播放" otherButtonTitles:@"继续播放", nil];
        alert.tag=1;
        [alert show];
        return;
    }
    //有wifi
    else
    {
        [self playVideo];
    }
}

#pragma mark --- 点击继续播放网络视屏
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1&&buttonIndex==1) {
        [self playVideo];
    }
}

#pragma mark --- 播放视频
-(void)playVideo
{
    NSRange range=[self.currenPlayURL rangeOfString:@".html"];
    if (range.length) {//网页
        ZCWebViewController *webController=[[ZCWebViewController alloc]init];
        webController.requestUrl=self.currenPlayURL;
        webController.myTitle=@"视频播放";
        [self.mainVC presentViewController:webController animated:YES completion:nil];
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {//视频
        ZYZCPlayViewController *playVC = [[ZYZCPlayViewController alloc] init];
        playVC.urlString = self.currenPlayURL;
        [self.mainVC presentViewController:playVC animated:YES completion:nil];
        return;
    }
}

- (void)dealloc
{
    
}
@end
