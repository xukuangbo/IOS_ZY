//
//  ZYZCLiveController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCLiveController.h"
#import <QPLive/QPLive.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface ZYZCLiveController () <QPLiveSessionDelegate,UIAlertViewDelegate>

@property (nonatomic, strong )  QPLiveSession  *liveSession;
@property (nonatomic, strong )  NSTimer        *timer;
@property (nonatomic, strong )  CTCallCenter   *callCenter;
@property (nonatomic, strong )  UIButton       *skimBtn;

@property (nonatomic, assign )  BOOL           isCTCallStateDisconnected;
@property (nonatomic, assign )  BOOL           isSkimLive;


@end

@implementation ZYZCLiveController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
    
    //关闭按钮
    UIButton *backBtn=[self createBtnWithFrame:CGRectMake(20, 20, 60, 30) andTitle:@"关闭" andTitleColor:[UIColor whiteColor] andAction:@selector(closeLive)];
    [self.view addSubview:backBtn];
    
    //美颜按钮
    _skimBtn=[self createBtnWithFrame:CGRectMake(20, 70, 60, 30) andTitle:@"美颜" andTitleColor:[UIColor whiteColor] andAction:@selector(skimLive:)];
    [self.view addSubview:_skimBtn];
    
    //监听通知
    [ZYNSNotificationCenter addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [ZYNSNotificationCenter addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //进行直播
    [self getLive];
}

#pragma mark --- 美颜
-(void)skimLive:(UIButton *)button
{
    _isSkimLive=!_isSkimLive;
    [_liveSession setEnableSkin:_isSkimLive];
}

#pragma mark --- app被冻结
-(void)appResignActive
{
    [self destroySession];
    
    // 监听电话
    _callCenter = [[CTCallCenter alloc] init];
    _isCTCallStateDisconnected = NO;
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            _isCTCallStateDisconnected = YES;
        }
        else if([call.callState isEqualToString:CTCallStateConnected])
            
        {
            _callCenter = nil;
        }
    };
}

#pragma mark --- app进入活动状态
-(void)appBecomeActive
{
    if (_isCTCallStateDisconnected) {
        sleep(2);
    }
    [self getLive];
}

#pragma mark --- 关闭直播
-(void)closeLive
{
    [self destroySession];
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 直播
-(void)getLive
{
    DDLog(@"kPushUrl:%@",_pushUrl);
    QPLConfiguration *configuration = [[QPLConfiguration alloc] init];
    //推流地址
    configuration.url = _pushUrl;
    //设置最大码率,设置最大码率和 最小码率后 SDK 会根据网络状况自动调整码率
    configuration.videoMaxBitRate = 1500 * 1000;
    //设置最小码率
    configuration.videoMinBitRate = 400  * 1000;
    //设置当前视频码率
    configuration.videoBitRate    = 600  * 1000;
    //设置音频码率
    configuration.audioBitRate    = 64   * 1000;
    //设置直播分辨率(横屏状态宽高不需要互换)
    configuration.videoSize = CGSizeMake(360, 640);
    //设置帧数
    configuration.fps = 20;
    //设置采集质量
    configuration.preset = AVCaptureSessionPresetiFrame1280x720;
    // 设置横屏 or 竖屏
    configuration.screenOrientation = QPLiveScreenVertical;
    //设置前置摄像头或后置 摄像头
    configuration.position = AVCaptureDevicePositionFront;
    
//    // 添加水印
//    configuration.waterMaskImage = [UIImage imageNamed:@"btn_fzc_pre"];
//    configuration.waterMaskLocation = 0;
//    configuration.waterMaskMarginX = 20;
//    configuration.waterMaskMarginY = 20;
    
    _liveSession = [[QPLiveSession alloc] initWithConfiguration:configuration];
    _liveSession.delegate = self;
    
    [_liveSession startPreview];
    
    [_liveSession updateConfiguration:^(QPLConfiguration *configuration) {
        configuration.videoMaxBitRate = 1500 * 1000;
        configuration.videoMinBitRate = 400  * 1000;
        configuration.videoBitRate    = 600  * 1000;
        configuration.audioBitRate    = 64   * 1000;
        configuration.fps = 20;
    }];
    [_liveSession connectServer];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view insertSubview:[_liveSession previewView] atIndex:0];
    });
}

#pragma mark --- 定时刷新
- (void)timeUpdate{
    
}

#pragma mark --- 关闭直播
- (void)destroySession{
    
    [_liveSession disconnectServer];
    [_liveSession stopPreview];
    [_liveSession.previewView removeFromSuperview];
    _liveSession = nil;
}

#pragma mark --- 直播出错的代理方法
- (void)liveSession:(QPLiveSession *)session error:(NSError *)error{
    DDLog(@"直播出错");
    NSString *msg = [NSString stringWithFormat:@"%zd %@",error.code, error.localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Live Error" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新连接", nil];
    [alertView show];
}

#pragma mark --- 网速较慢时的代理方法
- (void)liveSessionNetworkSlow:(QPLiveSession *)session{
    DDLog(@"网络太差");
}

#pragma mark --- 推流连接成功
- (void)liveSessionConnectSuccess:(QPLiveSession *)session {
    
    NSLog(@"connect success!");
}

#pragma mark --- 麦克风打开成功
- (void)openAudioSuccess:(QPLiveSession *)session {
    DDLog(@"麦克风打开成功");
}

#pragma mark --- 摄像头打开成功
- (void)openVideoSuccess:(QPLiveSession *)session {
    DDLog(@"摄像头打开成功");
}

#pragma mark --- 音频初始化失败
- (void)liveSession:(QPLiveSession *)session openAudioError:(NSError *)error {
    DDLog(@"音频初始化失败");
}

#pragma mark --- 视频初始化失败
- (void)liveSession:(QPLiveSession *)session openVideoError:(NSError *)error {
    DDLog(@"视频初始化失败");
}

#pragma mark --- 音频编码器初始化失败
- (void)liveSession:(QPLiveSession *)session encodeAudioError:(NSError *)error {
    DDLog(@"音频编码器初始化失败");
}

#pragma mark --- 视频编码器初始化失败
- (void)liveSession:(QPLiveSession *)session encodeVideoError:(NSError *)error {
    DDLog(@"视频编码器初始化失败");
}

#pragma mark --- 码率变化
- (void)liveSession:(QPLiveSession *)session bitrateStatusChange:(QP_LIVE_BITRATE_STATUS)bitrateStatus {
    DDLog(@"码率发生变化");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //重新连接
        [_liveSession connectServer];
    }
}


-(UIButton *)createBtnWithFrame: (CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andAction:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
    [ZYNSNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
