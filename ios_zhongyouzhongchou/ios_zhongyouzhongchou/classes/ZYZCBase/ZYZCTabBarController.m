//
//  ZYZCTabBarController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCTabBarController.h"
#import "FXBlurView.h"
#import "ZYZCMineVIewController.h"
#import "ZYZCNavigationController.h"
#import "LoginJudgeTool.h"
#import "MoreFZCViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MinePersonSetUpController.h"
#import "MineTravelTagVC.h"
#import "NetWorkManager.h"
#import "ZYZCRCManager.h"
#import "UITabBarItem+WZLBadge.h"
#import <AudioToolbox/AudioToolbox.h>

#import "ZYZCEditYoujiController.h"
//#import "ZYZCLiveStartController.h"
#import "ZYFaqiLiveViewController.h"
#import "ZYShortVideoController.h"

#import "ZFWeiboButton.h"
#import "ZFIssueWeiboView.h"

#import "QupaiSDK.h"
#import "QPEffectMusic.h"
#import <RongIMKit/RongIMKit.h>

#define kSaveVideoAlertTag    100

@interface ZYZCTabBarController ()<UIAlertViewDelegate,RCIMReceiveMessageDelegate,ZFIssueWeiboViewDelegate,QupaiSDKDelegate,UITabBarDelegate>
@property (nonatomic, strong) UIView          *bottomView;
@property (nonatomic, strong) RCIM            *rcIM;
@property (nonatomic, strong) UITabBarItem    *preItem;

@end

@implementation ZYZCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.translucent = NO;
    self.tabBar.alpha=0.95;
    self.selectedIndex=1;
    [self getCustomItems];
    [self insertSpaceItem];
    
    //去掉TabBar上部的横线
    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    UIView *coverView= [[UIView alloc]initWithFrame:CGRectMake(KSCREEN_W/2-40, 0, 80, self.tabBar.height)];
    [self.tabBar addSubview:coverView];
    

//    CGFloat lineImgWidth=(KSCREEN_W-width)/2;
    
    UIImageView *img01=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 0.5)];
    img01.image=KPULLIMG(@"tab-line", 0, 3, 0, 3);
    [self.tabBar addSubview:img01];
    
    CGFloat centerBtnWidth=60;
    UIButton *moreBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(KSCREEN_W/2-centerBtnWidth/2,self.tabBar.height-centerBtnWidth, centerBtnWidth, centerBtnWidth);
    [moreBtn addTarget:self action:@selector(clickCenterItem:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"tab_camera"] forState:UIControlStateNormal];
    [self.tabBar addSubview:moreBtn];
    
    
    _rcIM = [RCIM sharedRCIM];
    _rcIM.receiveMessageDelegate=self;
}

#pragma mark --- 收到消息的回调
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UITabBarItem *item=[self.tabBar.items lastObject];
                       item.badgeCenterOffset=CGPointMake(0, 5);
                       [item showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
                   });
}

#pragma mark --- 收到消息后的声音提醒
-(BOOL) onRCIMCustomAlertSound:(RCMessage *)message
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    BOOL openSound=YES;
    BOOL openShake=YES;
    if([user objectForKey:KOPEN_SOUND_ALERT])
    {
        openSound=[[user objectForKey:KOPEN_SOUND_ALERT] boolValue];
    }
    if ([user objectForKey:KOPEN_SHAKE_ALERT]) {
         openShake=[[user objectForKey:KOPEN_SHAKE_ALERT] boolValue];
    }
    if (openSound) {
        //系统声音
        AudioServicesPlaySystemSound(1007);
    }
    if (openShake) {
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    return YES;
}


#pragma mark --- 创建items
-(void)getCustomItems
{
    
    NSArray *titleArray = @[@"目的地",@"众筹",@"直播",@"我的"];
    NSArray *imageArray = @[@"tab_one_gl",@"tab_two_zc",@"tab_zhibo",@"tab_fou_min"];
    for (int i=0; i<4; i++){
        UINavigationController *navi = self.viewControllers[i];
        navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:[[UIImage imageNamed:imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_pre",imageArray[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
    self.tabBar.tintColor = [UIColor ZYZC_MainColor];
}

#pragma mark --- 创建空item
-(void)insertSpaceItem
{
    UIViewController *spaceVC=[[UIViewController alloc]init];
    spaceVC.view.backgroundColor=[UIColor whiteColor];
    NSMutableArray *viewControllers=[NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers insertObject:spaceVC atIndex:2];
    self.viewControllers=viewControllers;
    
    //添加消息提醒红点
    RCIMClient *rcIMClient=[RCIMClient sharedRCIMClient];
    int count = [rcIMClient getTotalUnreadCount];
    if(count>0)
    {
        UITabBarItem *item=[self.tabBar.items lastObject];
        item.badgeCenterOffset=CGPointMake(0, 5);
        [item showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
    }
}

#pragma mark --- tabbar代理方法
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([_preItem isEqual:item]) {
        DDLog(@"selectedIndex%ld可刷新啦",self.selectedIndex);
        //需要刷新界面可监听该通知
        [[NSNotificationCenter  defaultCenter] postNotificationName:@"controllerRefresh" object:nil];
    }
    _preItem=item;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark --- 点击中间item
-(void)clickCenterItem:(UIButton *)button
{
//    NSArray *titles=@[@"众筹",@"短视频",@"直播"];
//    NSArray *images=@[@"btn_fzc_pre",@"btn_xyj_pre",@"btn_view_pre"];
//    ZFIssueWeiboView *view = [[ZFIssueWeiboView alloc]initWithTitles:titles andImages:images];
//    view.frame = CGRectMake(0, 0, KSCREEN_W, KSCREEN_H);
//    view.delegate = self;
//    [self.view addSubview:view];
//    
//    return;
    
    [self enterShortVideo];
}

#pragma mark --- 动画效果结束的回调
- (void)animationHasFinishedWithButton:(ZFWeiboButton *)button
{
    NSLog(@"%zd", button.tag);
    switch (button.tag) {
        case 1000:
            //发众筹
            [self enterFZC];
            break;
            //短视频
        case 1001:
            [self enterShortVideo];
            break;
            //直播
        case 1002:
            [self enterLive];
            break;
            
        default:
            break;
    }
}

#pragma mark --- 短视频
-(void)enterShortVideo
{
    [QupaiSDK shared].minDurtaion = 2.0;
    [QupaiSDK shared].maxDuration = 15.0;
    UIViewController *controller = [[QupaiSDK shared] createRecordViewController];
    [QupaiSDK shared].delegte = self;
    UINavigationController *navCrl = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCrl animated:YES completion:nil];
}

#pragma mark --- 实现短视频代理方法
- (void)qupaiSDK:(id<QupaiSDKDelegate>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
    NSLog(@"Qupai SDK compelete %@----thumbnailPath:%@",videoPath,thumbnailPath);
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否保存到手机相册?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    alert.tag=kSaveVideoAlertTag;
//    [alert show];

    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL  exit= [manager fileExistsAtPath:videoPath];
    if (!exit) {
        [MBProgressHUD showError:@"本地视频不存在"];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
    }
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
}

- (NSArray *)qupaiSDKMusics:(id<QupaiSDKDelegate>)sdk
{
    NSMutableArray *array = [NSMutableArray array];
    QPEffectMusic *effect = [[QPEffectMusic alloc] init];
    effect.name = @"audio";
    effect.eid = 1;
    effect.musicName = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"mp3"];
    effect.icon = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    [array addObject:effect];
    
    return array;
}

#pragma mark --- 进入游记
-(void)enterYouji
{
    ZYZCEditYoujiController *editYoujiController=[[ZYZCEditYoujiController alloc]init];
    editYoujiController.hidesBottomBarWhenPushed=YES;
   [self.selectedViewController pushViewController:editYoujiController animated:YES];
}

#pragma mark --- 直播
-(void)enterLive
{
//    ZYZCLiveStartController *liveController=[[ZYZCLiveStartController alloc]init];
    ZYFaqiLiveViewController *liveController=[[ZYFaqiLiveViewController alloc]init];
    liveController.hidesBottomBarWhenPushed=YES;
    [self.selectedViewController pushViewController:liveController animated:YES];
}

#pragma mark --- 发众筹
-(void)enterFZC
{
    //判断是否登录
    BOOL hasLogin=[LoginJudgeTool judgeLogin];
    if (!hasLogin) {
        return;
    }
    //判断是否完善个人信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:CHECK_USERINFO  andParameters:@{@"userId":[ZYZCAccountTool getUserId]} andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [MBProgressHUD hideHUDForView:self.view];
         if (isSuccess) {
             if (![result[@"data"][@"info"] boolValue]) {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"个人信息未完善,无法发送众筹,是否完善" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                 alert.tag=1;
                 [alert show];
                 //                self.selectedIndex=4;
             }
             else if([result[@"data"][@"info"] boolValue]&&![result[@"data"][@"tag"] boolValue])
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"旅行标签未完善,无法发送众筹,是否完善" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                 alert.tag=2;
                 [alert show];
                 //  [MBProgressHUD showError:@"旅行标签未完善,请完善!"];
                 //  self.selectedIndex=4;
             }
             else if ([result[@"data"][@"info"] boolValue]&&[result[@"data"][@"tag"] boolValue])
             {
                 //发起众筹
                 MoreFZCViewController *fzcVC=[[MoreFZCViewController alloc]init];
                 fzcVC.hidesBottomBarWhenPushed=YES;
                 [self.selectedViewController pushViewController:fzcVC animated:YES];
             }
         }
         else
         {
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
         }
         
     } andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUDForView:self.view];
         [NetWorkManager showMBWithFailResult:failResult];
     }];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1&&buttonIndex==1) {
        [self enterMyInfoSet];
    }
    else if (alertView.tag==2&&buttonIndex==1)
    {
        [self enterTravelTag];
    }

}


#pragma mark --- 进入个人信息设置
-(void)enterMyInfoSet
{
    BOOL hasLogin=[LoginJudgeTool judgeLogin];
    if (!hasLogin) {
        return;
    }
    MinePersonSetUpController *mineInfoSetVietrroller=[[MinePersonSetUpController alloc] init];
    mineInfoSetVietrroller.wantFZC = YES;
    mineInfoSetVietrroller.hidesBottomBarWhenPushed=YES;
    [self.selectedViewController pushViewController:mineInfoSetVietrroller animated:YES];
}

#pragma mark --- 进入个人旅行标签
-(void)enterTravelTag
{
    [self.selectedViewController pushViewController:[[MineTravelTagVC alloc] init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - tabbar点击事件
//
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    for (int i = 0; i < tabBarController.viewControllers.count; i++) {
//        if ([tabBarController.viewControllers[i] isEqual:viewController] && i == 4) {
//            //说明是个人中心
//            [LoginJudgeTool judgeLogin];
////            return NO;
//        }
//    }
//    
//    return YES;
//}
@end
