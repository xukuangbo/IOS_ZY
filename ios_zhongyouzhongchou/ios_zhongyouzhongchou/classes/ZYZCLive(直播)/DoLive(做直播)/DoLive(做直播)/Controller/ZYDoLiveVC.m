//
//  ZYDoLiveVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYDoLiveVC.h"
#import "RCDLiveKitUtility.h"
#import <RongIMLib/RongIMLib.h>
#import "MBProgressHUD.h"
#import <Masonry.h>
#import "QPSDKCore/QPSDKCore.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "LiveFunctionView.h"
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size

@interface ZYDoLiveVC ()<RCTKInputBarControlDelegate,UIGestureRecognizerDelegate,QPLiveSessionDelegate,UIAlertViewDelegate>

#pragma mark - 直播需要的属性
/** 直播任务流 */
@property (nonatomic, strong )  QPLiveSession  *liveSession;
/** 直播时长计时器 */
@property (nonatomic, strong )  NSTimer        *timer;
/** 电话中心 */
@property (nonatomic, strong )  CTCallCenter   *callCenter;
/** 美颜按钮 */
@property (nonatomic, strong )  UIButton       *skimBtn;
/** 电话连接状态 */
@property (nonatomic, assign )  BOOL           isCTCallStateDisconnected;
/** skim是否活跃 */
@property (nonatomic, assign )  BOOL           isSkimLive;

#pragma mark - 聊天需要的属性

#pragma mark ---返回按钮
@property (nonatomic, strong) UIButton *backBtn;

#pragma mark ---分享按钮
@property(nonatomic,strong)UIButton *shareBtn;

#pragma mark ---评论按钮
@property(nonatomic,strong)UIButton *feedBackBtn;

#pragma mark ---主播功能端按钮
@property(nonatomic,strong)UIButton *moreBtn;

@property (nonatomic, strong) LiveFunctionView *liveFunctionView;

#pragma mark ---私信按钮
@property (nonatomic, strong) UIButton *massageBtn;

#pragma mark ---点击空白区域事件
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;

@end

#pragma mark - 方法实现
@implementation ZYDoLiveVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.conversationType = ConversationType_CHATROOM;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self qpLiveInit];
    //初始化UI
    [self initializedSubViews];
    
    [self rcinit];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    //    [self configUserList];
//    //    [self initChatroomMemberInfo];
//
//    //    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
//}

- (void)rcinit {
    //    self.conversationDataRepository = [[NSMutableArray alloc] init];
    //    self.userList = [[NSMutableArray alloc] init];
    //    self.conversationMessageCollectionView = nil;
    //    self.targetId = nil;
    [self registerNotification];
    //    self.defaultHistoryMessageCountOfChatRoom = 10;
    //    [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
    
}

- (void)qpLiveInit{
    
    //进行直播
    [self getLive];
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

#pragma mark ---注册监听Notification
- (void)registerNotification {
    
    //监听app进入前后台通知
    [ZYNSNotificationCenter addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [ZYNSNotificationCenter addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //注册接收消息
    //    [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(didReceiveMessageNotification:)
    //     name:RCDLiveKitDispatchMessageNotification
    //     object:nil];
}



#pragma mark ---初始化页面控件

- (void)initializedSubViews {
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        //        self.contentView.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.contentView];
    }
    //聊天消息区
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 0;
        customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f,5.0f, 0.0f);
        customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//方向
        CGRect _conversationViewFrame = self.contentView.bounds;
        _conversationViewFrame.origin.y = 0;//y为0
        _conversationViewFrame.size.height = self.contentView.bounds.size.height - 50;//消息高度为内容view-50
        _conversationViewFrame.size.width = 240;//宽度240
        self.conversationMessageCollectionView =
        [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                           collectionViewLayout:customFlowLayout];
        [self.conversationMessageCollectionView
         setBackgroundColor:[UIColor yellowColor]];//背景色透明
        //        self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;//展示水平条
        //        self.conversationMessageCollectionView.alwaysBounceVertical = YES;//垂直可弹
        //        self.conversationMessageCollectionView.dataSource = self;
        //        self.conversationMessageCollectionView.delegate = self;
        [self.contentView addSubview:self.conversationMessageCollectionView];
    }
    //输入区
    if(self.inputBar == nil){
        float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height +30;
        float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
        float inputBarSizeWidth = self.contentView.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;//高度50
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)
                                              inViewConroller:self];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor redColor];
        self.inputBar.hidden = YES;
        [self.contentView addSubview:self.inputBar];
    }
    //    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
    //                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    //    _collectionViewHeader.tag = 1999;
    //    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];//刷新view添加到聊天信息
    //    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];//注册文字id
    //    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];//注册提示id
    //    [self registerClass:[RCDLiveGiftMessageCell class]forCellWithReuseIdentifier:RCDLiveGiftMessageCellIndentifier];//注册礼物id
    //    [self changeModel:YES];//暂时不知道功能
    //    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
    //                             initWithTarget:self
    //                             action:@selector(tap4ResetDefaultBottomBarStatus:)];//点击空白
    //    [_resetBottomTapGesture setDelegate:self];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];//点击空白
    [_resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    
    //评论
    CGFloat buttonWH = 35;
    _feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_feedBackBtn];
    [_feedBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [_feedBackBtn setImage:[UIImage imageNamed:@"live-talk"] forState:UIControlStateNormal];
    [_feedBackBtn addTarget:self action:@selector(showInputBar:) forControlEvents:UIControlEventTouchUpInside];
    
    //返回
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];//返回按钮
    _backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [_backBtn setImage:[UIImage imageNamed:@"live-quit"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //主播功能端
    _moreBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backBtn.mas_left).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [_moreBtn setImage:[UIImage imageNamed:@"live-more"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //主播功能段的view
    _liveFunctionView  = [[LiveFunctionView alloc] initWithSession:_liveSession];
    [self.view addSubview:_liveFunctionView];
    [_liveFunctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_moreBtn.mas_top);
        make.centerX.mas_equalTo(_moreBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 150));
    }];
    _liveFunctionView.hidden = YES;
    
    //分享按钮端
    _shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_moreBtn.mas_left).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [_shareBtn setImage:[UIImage imageNamed:@"live-share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //私信按钮端
    _massageBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_massageBtn];
    [_massageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_shareBtn.mas_left).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [_massageBtn setImage:[UIImage imageNamed:@"live-massage"] forState:UIControlStateNormal];
    [_massageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark ---主播功能段点击事件
- (void)moreBtnAction:(UIButton *)sender
{
    _liveFunctionView.hidden = !_liveFunctionView.hidden;
    
}

- (void)messageBtnAction:(UIButton *)sender
{
    
}

- (void)shareBtnAction:(UIButton *)sender
{
    
}


-(void)showInputBar:(id)sender{
    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:KBottomBarKeyboardStatus];
}
#pragma mark - 退出功能
#pragma mark ---点击返回的时候消耗播放器和退出聊天室
- (void)leftBarButtonItemPressed:(id)sender {
    
    [self destroySession];
    
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self quitConversationViewAndClear];
}

#pragma mark --- 关闭直播
- (void)destroySession{
    
    [_liveSession disconnectServer];
    [_liveSession stopPreview];
    [_liveSession.previewView removeFromSuperview];
    _liveSession = nil;
}

#pragma mark ---销毁
-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
    [ZYNSNotificationCenter removeObserver:self];
}
#pragma mark ---清理环境（退出讨论组、移除监听等）
- (void)quitConversationViewAndClear {
    if (self.conversationType == ConversationType_CHATROOM) {
        //        if (self.livePlayingManager) {
        //            [self.livePlayingManager destroyPlaying];
        //        }
        //        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
        //                                            success:^{
        //                                                self.conversationMessageCollectionView.dataSource = nil;
        //                                                self.conversationMessageCollectionView.delegate = nil;
        //                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
        //                                                [[RCIMClient sharedRCIMClient]disconnect];
        //                                                dispatch_async(dispatch_get_main_queue(), ^{
        //                                                    [self.navigationController popViewControllerAnimated:YES];
        //                                                });
        //
        //                                            } error:^(RCErrorCode status) {
        //
        //                                            }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark ---定义展示的UICollectionViewCell的个数
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        //        collectionViewRect.size.height = self.contentView.bounds.size.height - 0;
        //        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        _liveFunctionView.hidden = YES;
        [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
        self.inputBar.hidden = YES;
    }
}
#pragma mark - 直播代理方法
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

#pragma mark RCInputBarControlDelegate

#pragma mark ---根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
// frame    输入框即将占用的大小
- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
    CGRect collectionViewRect = self.contentView.frame;//拿到内容frame
    self.contentView.backgroundColor = [UIColor clearColor];//设置背景色透明
    collectionViewRect.origin.y = self.view.bounds.size.height - frame.size.height - 237 +50;
    //内容frame的y值为屏幕高度 - frame高度 - 237 + 50
    collectionViewRect.size.height = 237;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.contentView setFrame:collectionViewRect];
        [UIView commitAnimations];
    }];
    CGRect inputbarRect = self.inputBar.frame;
    
    inputbarRect.origin.y = self.contentView.frame.size.height -50;
    [self.inputBar setFrame:inputbarRect];
    [self.view bringSubviewToFront:self.inputBar];
    //    [self scrollToBottomAnimated:NO];
}
@end
