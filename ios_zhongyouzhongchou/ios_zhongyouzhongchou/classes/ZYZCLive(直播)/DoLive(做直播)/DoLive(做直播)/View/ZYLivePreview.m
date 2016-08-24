//
//  ZYLivePreview.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLivePreview.h"
#import "UIView+ZYLayer.h"
#import <QPSDKCore/QPSDKCore.h>
#import <RACEXTScope.h>
#import "ZYLiveHeadView.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDLiveKitUtility.h"
#import "RCDLive.h"
@interface ZYLivePreview ()<QPLiveSessionDelegate>
//电话
@property (nonatomic, strong )  CTCallCenter   *callCenter;
@property (nonatomic, assign )  BOOL           isCTCallStateDisconnected;
/** 直播Session */
@property (nonatomic, strong) QPLiveSession *liveSession;

/** 覆盖层View */
@property (weak, nonatomic)  UIView *overlayView;

/** 头像imageView */
@property (weak, nonatomic)  UIImageView *iconImageView;

/** 标题标签 */
@property (weak, nonatomic)  UILabel *titleLabel;

/** 相机按钮 */
@property (weak, nonatomic)  UIButton *cameraBtn;

/** 美颜按钮 */
@property (weak, nonatomic)  UIButton *beautyBtn;

/** 闪光灯 []~(￣▽￣)~* */
@property (weak, nonatomic)  UIButton *lightBtn;


//@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, assign) AVCaptureDevicePosition currentPosition;

@property (nonatomic, weak) UIView *headMapView;

@end

@implementation ZYLivePreview

- (instancetype)initWithLiveURL:(NSString *)LiveUrl
{
    self = [super init];
    
    if (self) {
        self.LiveUrl = LiveUrl;
        
        [self configUI];
        
        [self testPushCapture];
        
    }
    return self;
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
    [self testPushCapture];
}

/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    
    //监听通知
    [ZYNSNotificationCenter addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [ZYNSNotificationCenter addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //接收到消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}

- (void)configUI
{
    //监听通知
    [self registerNotification];
    
    
    
    //覆盖view
    UIView *overlayView = [UIView new];
    [self addSubview:overlayView];
    self.overlayView = overlayView;
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //头像
    ZYLiveHeadView *headMapView = [[[NSBundle mainBundle] loadNibNamed:@"ZYLiveHeadView" owner:nil options:nil] lastObject];
    [overlayView addSubview:headMapView];
    self.headMapView = headMapView;
    [headMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(overlayView.mas_left).offset(10);
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(120, 41));
    }];
    headMapView.iconView.image = [UIImage imageNamed:@"icon_placeholder"];
    headMapView.timeLabel.text = @"0:31:30";
    headMapView.peopleNumLabel.text = @"123123";
    
    
    //聊天界面
    UIView *chatRoom = [UIView new];
    [overlayView addSubview:chatRoom];
//    self.chatRoom = chatRoom;
    [chatRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(overlayView.mas_bottom).multipliedBy(0.5);
        make.bottom.mas_equalTo(overlayView.mas_bottom).offset(-50);
        make.left.mas_equalTo(overlayView.mas_left);
        make.right.mas_equalTo(overlayView.mas_right).multipliedBy(0.5);
        
    }];
    chatRoom.backgroundColor = [UIColor redColor];
    
    
}


- (void)testPushCapture{
    
    
    DDLog(@"kPushUrl:%@",_LiveUrl);
    QPLConfiguration *configuration = [[QPLConfiguration alloc] init];
    //推流地址
    configuration.url = _LiveUrl;
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
        [self.viewController.view insertSubview:[_liveSession previewView] atIndex:0];
    });

    
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


//-(UIButton *)createBtnWithFrame: (CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andAction:(SEL)action
//{
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=frame;
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:color forState:UIControlStateNormal];
//    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
    [ZYNSNotificationCenter removeObserver:self];
}
@end
