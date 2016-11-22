//
//  AppDelegate.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define IOS8 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0

#import "AppDelegate.h"
#import "ZYZCTabBarController.h"
#import "ZYZCOSSManager.h"
//#import <RongIMKit/RongIMKit.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "ZYZCDataBase.h"
#import "ZYZCRCManager.h"
#import "JPUSHService.h"
#import "VersionTool.h"
#import "LoginJudgeTool.h"
#import "OpenSetTool.h"
#import "RCDLive.h"
#import "Reachability.h"
#import "RCDLiveGiftMessage.h"

#import "ZYZCMessageListViewController.h"
#import "ChatUserInfoModel.h"
#import "MBProgressHUD+MJ.h"
#import  <QPSDKCore/QPSDKCore.h>
#import <Bugtags/Bugtags.h>
#import "ZYZCTestModeManager.h"
#define JPushAppKey    @"0d84e54275eeab85eac5baf6"
#define JPushChabbel   @"Publish channel"

@interface AppDelegate ()<WXApiManagerDelegate>

@property (nonatomic, strong)ZYZCRCManager *RCManager;
@property (nonatomic, strong) WXApiManager *wxManager;
@property (nonatomic, strong) Reachability *reachability;

@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    self.window.layer.cornerRadius=5;
    self.window.layer.masksToBounds=YES;
    self.orderModel=[WXOrderModel new];
    [self.window makeKeyAndVisible];
    
    //将是否第一次进app置为0
    [VersionTool version];
    // 设置APP连接的服务器
    if (![[ZYZCAPIGenerate sharedInstance] isTestMode]) {
        kLinkServerType linkServerType = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APIModeSwitch"] integerValue];
        [ZYZCAPIGenerate sharedInstance].serverType = linkServerType;
    } else {
        [ZYZCAPIGenerate sharedInstance].serverType = [ZYZCTestModeManager getServerStatus];
    }
    
    //获取app版本号，判断app是否是下载或更新后第一次进入
    [self getAppVersion];
    
    //设置状态栏
    [self setStatusBarStyle];
    
    //在documents中创建文件存储发众筹的数据
    [self createResoureFilefolderInDocuments];
    
    //创建上传凭证所需的凭证文件夹
    [self createVoucherResoureFile];
    
    //清除发众筹时没有保存下来的文件
    [self cleanMyDraftFile];
    
    //初始化微信
    [self initWithWechat];
    
    //初始化融云
    [self initRCloudWithLaunchOptions:(NSDictionary *)launchOptions];
    
    //删除上传到oss上失败的文件
    [self deleteFailDataInOss];
    
    //存储地名库
    [self saveViewSpot];
    
    //登录微信
    [LoginJudgeTool rootJudgeLogin];
    
    //注册JPush
    [self initPushWithLaunchOptions:launchOptions];
    
    //判断当前网络状态
    [self getCurrentNetworkStatus];
    
    //初始化趣拍视屏直播
    [self initQPLive];
    
    // 集成bugtags sdk
    [self addBugTags];
    
    return YES;
}


#pragma mark --- 获取网络状态
-(void)getCurrentNetworkStatus
{
    // 监听网络状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange:) name:kReachabilityChangedNotification object:nil];
    
    // 获得Reachability对象
    _reachability = [Reachability reachabilityForInternetConnection];
    // 开始监控网络
    [_reachability startNotifier];
}

#pragma mark --- 初始化趣拍
-(void)initQPLive
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:@"no" forKey:Auth_QuPai_Result];
    [user synchronize];
    [ZYZCAccountTool getQuPaiAuthWithResultBlock:nil];
}

// 初始化bugTags
- (void)addBugTags
{
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;
    
    BTGInvocationEvent btgEvent = BTGInvocationEventNone;
    if ([[[ZYZCAPIGenerate sharedInstance] APIBaseUrl] isEqualToString:@"http://121.40.225.119:8080/"]) {
        btgEvent = BTGInvocationEventShake;
    }
    [Bugtags startWithAppKey:kBugTagsAppKey invocationEvent:btgEvent];
}

// 网络状态改变的通知方法
- (void)networkStateChange:(NSNotification *)notification {
    Reachability *curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkChange" object:[NSNumber numberWithInteger:[curReach currentReachabilityStatus]]];
    
    switch ([curReach currentReachabilityStatus]) {
        case NotReachable:
//            NSLog(@"无网络");
            break;
        case ReachableViaWiFi:
//            NSLog(@"WiFi");
            break;
        case ReachableViaWWAN:
//            NSLog(@"手机网络");
            break;
    }
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
//        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
//        NSLog(@"视频保存成功.");
    }
}

#pragma mark --- 初始化融云
-(void)initRCloudWithLaunchOptions:(NSDictionary *)launchOptions
{
//    [[RCIM sharedRCIM] initWithAppKey:RC_APPKEY([ZYZCAPIGenerate sharedInstance].serverType)];
    [[RCDLive sharedRCDLive] initRongCloud:RC_APPKEY([ZYZCAPIGenerate sharedInstance].serverType)];
    //注册自定义消息
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
    
    ZYZCRCManager *rcManager=[ZYZCRCManager defaultManager];
    
    //获取消息推送
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    ChatUserInfoModel *infoModel=[[ChatUserInfoModel alloc]mj_setKeyValues:remoteNotificationUserInfo[@"rc"]];
    //判断是否是聊天消息推送
    if ([infoModel.cType isEqualToString:@"PR"]&&infoModel.fId) {
//        [[RCIM sharedRCIM] initWithAppKey:RC_APPKEY];
        [rcManager loginRongCloudSuccess:^{
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               ZYZCTabBarController *mainTab=(ZYZCTabBarController *)self.window.rootViewController;
                               ZYZCRCManager *rcManager=[ZYZCRCManager defaultManager];
                               [rcManager getMyConversationListWithSupperController:mainTab.selectedViewController];
                           });
        } orFail:nil];

    } else {
        [rcManager loginRongCloudSuccess:nil orFail:nil];
    }
}

#pragma mark --- 设置根控制器
-(void)getRootViewController
{
    NSString *userid = [ZYZCAccountTool getUserId];
    if (userid) {
        //如果有账号,就设置跟控制器为tabbar
        UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZYZCTabBarController *mainTab=[storyboard instantiateViewControllerWithIdentifier:@"ZYZCTabBarController"];
        self.window.rootViewController=mainTab;
    }else{
        //如果没有账号,就设置跟控制器为登录控制器
        [LoginJudgeTool judgeLogin];
        
    }
}

#pragma mark --- 设置状态栏
-(void)setStatusBarStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];
}

#pragma mark --- 存储app版本号，判断app是否是下载或更新后第一次进入
-(void)getAppVersion
{
    NSString *version=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSLog(@"%@",version);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *myVersion=[user objectForKey:KAPP_VERSION];
    //下载或更新后第一次进入
    if (!myVersion||![myVersion isEqualToString:version]) {
        //首次进入app
        
        //删除融云token
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:nil forKey:KCHAT_TOKEN];

        [user setObject:version forKey:KAPP_VERSION];
        [user synchronize];
    }
}

#pragma mark --- 存储地名库
-(void)saveViewSpot
{
    ZYZCDataBase *dbManager=[ZYZCDataBase sharedDBManager];
    [dbManager createTables];
}

/**
 初始化微信
 */
#pragma mark --- 初始化微信
- (void)initWithWechat
{
    [WXApi registerApp:kAppOpenid withDescription:@"ZYZC"];
}

/**
 *  初始化推送注册
 */
#pragma mark --- 初始化极光推送
- (void)initPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    
    if (IOS8) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushAppKey
                          channel:JPushChabbel
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    //注册自定义消息，这个东西可以选择或者不选择
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //获取消息推送
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotificationUserInfo[@"_j_msgid"]) {
            if ([remoteNotificationUserInfo[@"pushType"] integerValue] != 10) {
                ZYZCTabBarController *mainTab=(ZYZCTabBarController *)self.window.rootViewController;
                ZYZCMessageListViewController *msgController=[[ZYZCMessageListViewController alloc]init];
                msgController.hidesBottomBarWhenPushed=YES;
                [mainTab.selectedViewController pushViewController:msgController animated:YES];
            }
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"收到极光消息1" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
}

#pragma mark - 打开微信，回调微信
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma mark --- 在Documents中创建资源文件存放视屏、语音、图片
-(void)createResoureFilefolderInDocuments
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *zcDraftPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,KMY_ZHONGCHOU_FILE];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:zcDraftPath]) {
        BOOL fileCreate=[fileManager createDirectoryAtPath:zcDraftPath withIntermediateDirectories:YES attributes:nil error:nil];
        //如果创建失败，重新创建
        if (!fileCreate) {
            [self createResoureFilefolderInDocuments];
        }
    }
}

#pragma mark ---创建上传凭证所需的凭证文件夹
- (void)createVoucherResoureFile
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *voucherPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,KVoucher_File_Path];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:voucherPath]) {
        BOOL fileCreate=[fileManager createDirectoryAtPath:voucherPath withIntermediateDirectories:YES attributes:nil error:nil];
        //如果创建失败，重新创建
        if (!fileCreate) {
            [self createVoucherResoureFile];
        }
    }
}

#pragma mark --- 删除发众筹时没保存下来的文件
-(void)cleanMyDraftFile
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if (![user objectForKey:KMY_ZC_DRAFT_SAVE]) {
        [ZYZCTool cleanZCDraftFile];
    }
}

#pragma mark --- 删除oss上传失败的文件
-(void)deleteFailDataInOss
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *failDataFile=[user objectForKey:KFAIL_UPLOAD_OSS];
    if (failDataFile) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
            [ossManager deleteObjectsByPrefix:failDataFile andSuccessUpload:^
             {
                 [user setObject:nil forKey:KFAIL_UPLOAD_OSS];
                 [user synchronize];
             }
              andFailUpload:^
             {
             }];
        });
    }
}

#pragma mark - APP到前端
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //设置角标为0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    //进app的时候就去请求一次最新的接口
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [VersionTool version];
    });
    [application cancelAllLocalNotifications];
    if(self.orderModel.out_trade_no)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetPayResultNotification object:nil];
    }
    NSLog(@"applicationWillEnterForeground222");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
//    [VersionTool removeHaveVersion];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //接收到内存警告的时候清楚一下缓存
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark - 推送的注册和接收
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    //注册极光远程推送
    [JPUSHService registerDeviceToken:deviceToken];
    
    //注册融云远程推送
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
      withString:@""]
     stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
      withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}
#endif
//这是7.0以下远程通知接收
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    //接收到通知就设置为1
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

//这是7.0以上远程通知接收，前后台都接收
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"%@",userInfo);
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    if ([userInfo[@"pushType"] integerValue] == 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEPTION_LIVE_NOTIFICATION object:userInfo];
    }
    else
    {
        ZYZCTabBarController *mainTab=(ZYZCTabBarController *)self.window.rootViewController;
        ZYZCMessageListViewController *msgController=[[ZYZCMessageListViewController alloc]init];
        msgController.hidesBottomBarWhenPushed=YES;
        [mainTab.selectedViewController pushViewController:msgController animated:YES];
    }
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    //接收到通知就设置为1
//    [JPUSHService setBadge:+1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

#pragma mark ---这个是本地通知的接收
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
//    DDLog(@"%@",notification.userInfo);
    
    //如果是私信通知，进入私信列表页
    ChatUserInfoModel *infoModel=[[ChatUserInfoModel alloc]mj_setKeyValues:notification.userInfo[@"rc"]];
    if ([infoModel.cType isEqualToString:@"PR"]&&infoModel.fId&&!self.enterChatList) {
        ZYZCTabBarController *mainTab=(ZYZCTabBarController *)self.window.rootViewController;
        ZYZCRCManager *RCManager=[ZYZCRCManager defaultManager];
        [RCManager getMyConversationListWithSupperController:mainTab.selectedViewController];
    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    //这里是接收到自定义的消息，具体用途暂不知
    
}

@end
