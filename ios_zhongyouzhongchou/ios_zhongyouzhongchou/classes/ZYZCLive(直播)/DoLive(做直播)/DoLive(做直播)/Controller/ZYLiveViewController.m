//
//  ZYLiveViewController.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveViewController.h"
#import "RCDLiveMessageCell.h"
#import "RCDLiveTextMessageCell.h"
#import "RCDLiveGiftMessageCell.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveTipMessageCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLive.h"
#import "RCDLiveCollectionViewHeader.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import <objc/runtime.h>
#import "RCDLiveTipMessageCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RCDLivePortraitViewCell.h"
#import <Masonry.h>
#import <QPSDKCore/QPLive.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "LiveFunctionView.h"

//#import "KSYLivePlaying.h"
//#import "UCLOUDLivePlaying.h"
//#import "LELivePlaying.h"
//#import "QINIULivePlaying.h"
//#import "QCLOUDLivePlaying.h"

//输入框的高度
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size
@interface ZYLiveViewController () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, RCDLiveMessageCellDelegate, UIGestureRecognizerDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate,RCTKInputBarControlDelegate,RCConnectionStatusChangeDelegate,QPLiveSessionDelegate>

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


@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;

#pragma mark ---存储长按返回的消息的model
@property(nonatomic, strong) RCDLiveMessageModel *longPressSelectedModel;

#pragma mark ---是否需要滚动到底部
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

#pragma mark ---是否正在加载消息
@property(nonatomic) BOOL isLoading;

#pragma mark ---会话名称
@property(nonatomic,copy) NSString *navigationTitle;

#pragma mark ---金山视频播放器manager
//@property(nonatomic, strong) KSYLivePlaying *livePlayingManager;

#pragma mark ---直播互动文字显示
@property(nonatomic,strong) UIView *titleView ;

#pragma mark ---播放器view
@property(nonatomic,strong) UIView *liveView;

#pragma mark ---底部显示未读消息view
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

#pragma mark ---滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
@property (nonatomic, assign) NSInteger unreadNewMsgCount;

#pragma mark ---当前融云连接状态
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;

#pragma mark ---鲜花按钮
@property(nonatomic,strong)UIButton *flowerBtn;


#pragma mark ---掌声按钮
@property(nonatomic,strong)UIButton *clapBtn;

@property(nonatomic,strong)UICollectionView *portraitsCollectionView;

@property(nonatomic,strong)NSMutableArray *userList;


@end

#pragma mark ---文本cell标示
static NSString *const rctextCellIndentifier = @"rctextCellIndentifier";

#pragma mark ---小灰条提示cell标示
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";

#pragma mark ---礼物cell标示
static NSString *const RCDLiveGiftMessageCellIndentifier = @"RCDLiveGiftMessageCellIndentifier";

#pragma mark - 方法实现
@implementation ZYLiveViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self rcinit];
        self.conversationType = ConversationType_CHATROOM;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self rcinit];
        self.conversationType = ConversationType_CHATROOM;
    }
    return self;
}

- (void)rcinit {
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    self.userList = [[NSMutableArray alloc] init];
    self.conversationMessageCollectionView = nil;
//    self.targetId = @"001";
    [self registerNotification];
    self.defaultHistoryMessageCountOfChatRoom = 10;
    [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
    
}

#pragma mark ---注册监听Notification

- (void)registerNotification {
    //注册接收消息
    
    [ZYNSNotificationCenter addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [ZYNSNotificationCenter addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}

#pragma mark ---注册cell
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

#pragma mark ---创建假房间成员
- (void)configUserList
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RoleList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _userList = [[NSMutableArray alloc]init];
    RCUserInfo *user = [self parseUserInfoFormDic:[data objectForKey:@"User1"]];
    [_userList  addObject:user];
    RCUserInfo *user2 = [self parseUserInfoFormDic:[data objectForKey:@"User2"]];
    [_userList  addObject:user2];
    RCUserInfo *user3 = [self parseUserInfoFormDic:[data objectForKey:@"User3"]];
    [_userList  addObject:user3];
    RCUserInfo *user4 = [self parseUserInfoFormDic:[data objectForKey:@"User4"]];
    [_userList  addObject:user4];
    RCUserInfo *user5 = [self parseUserInfoFormDic:[data objectForKey:@"User5"]];
    [_userList  addObject:user5];
    RCUserInfo *user6 = [self parseUserInfoFormDic:[data objectForKey:@"User6"]];
    [_userList  addObject:user6];
    RCUserInfo *user7 = [self parseUserInfoFormDic:[data objectForKey:@"User7"]];
    [_userList  addObject:user7];
}

-(RCUserInfo *)parseUserInfoFormDic:(NSDictionary *)dic{
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = [dic objectForKey: @"id" ];
    user.name = [dic objectForKey: @"name" ];
    user.portraitUri = [dic objectForKey: @"icon" ];
    return user;
}

#pragma mark ---页面加载

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.userList = delegate.userList;
    
    //进行直播
    [self getLive];
    
    [self configUserList];
    //初始化UI
    [self initializedSubViews];
    
    [self initChatroomMemberInfo];
    
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
    __weak ZYLiveViewController *weakSelf = self;
    
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:self.targetId
         messageCount:10
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
//                 self.livePlayingManager = [[KSYLivePlaying alloc] initPlaying:self.contentURL];
                 //                 self.livePlayingManager = [[LELivePlaying alloc] initPlaying:@"201604183000000z4"];
                 //                 self.livePlayingManager = [[QINIULivePlaying alloc] initPlaying:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
                 //                 self.livePlayingManager = [[QCLOUDLivePlaying alloc] initPlaying:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f20.mp4"];
//                 [self initializedLiveSubViews];
//                 [self.livePlayingManager startPlaying];
                 RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
                 joinChatroomMessage.message = [NSString stringWithFormat: @"%@加入了聊天室",[RCDLive sharedRCDLive].currentUserInfo.name];
                 [self sendMessage:joinChatroomMessage pushContent:nil];
             });
         }
         error:^(RCErrorCode status) {
             DDLog(@"%zd",status);
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (status == KICKED_FROM_CHATROOM) {
                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomRejected", @"RongCloudKit", nil)];
                 } else {
                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomFailed", @"RongCloudKit", nil)];
                 }
             });
         }];
    }
    
}
#pragma mark - 直播
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
#pragma mark ---主播功能段点击事件
- (void)moreBtnAction:(UIButton *)sender
{
    _liveFunctionView.hidden = !_liveFunctionView.hidden;
    
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
#pragma mark --- 收集日志
- (void)liveSession:(QPLiveSession *)session logInfo:(NSDictionary *)info
{
    
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


#pragma mark ---加入聊天室失败的提示
- (void)loadErrorAlert:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView reloadData];
    
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationTitle = self.navigationItem.title;
}

#pragma mark ---移除监听

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCPlayVoiceFinishNotification"
     object:nil];
    
    [self.conversationMessageCollectionView removeGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView
     addGestureRecognizer:_resetBottomTapGesture];
    
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.tabBarController.tabBar setHidden:NO];
    
}

#pragma mark ---回收的时候需要消耗播放器和退出聊天室

- (void)dealloc {
    [self quitConversationViewAndClear];
}
#pragma mark - 退出
#pragma mark ---点击返回的时候消耗播放器和退出聊天室

- (void)leftBarButtonItemPressed:(id)sender {
    
    [self destroySession];
    
    [_timer invalidate];
    _timer = nil;
    [self quitConversationViewAndClear];
}

#pragma mark --- 关闭直播
- (void)destroySession{
    
    [_liveSession disconnectServer];
    [_liveSession stopPreview];
    [_liveSession.previewView removeFromSuperview];
    _liveSession = nil;
}

// 清理环境（退出讨论组、移除监听等）
- (void)quitConversationViewAndClear {
    if (self.conversationType == ConversationType_CHATROOM) {
//        if (self.livePlayingManager) {
//            [self.livePlayingManager destroyPlaying];
//        }
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                            success:^{
                                                self.conversationMessageCollectionView.dataSource = nil;
                                                self.conversationMessageCollectionView.delegate = nil;
                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
//                                                [[RCIMClient sharedRCIMClient]disconnect];
                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                    [self.navigationController popViewControllerAnimated:YES];
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                });
                                                
                                            } error:^(RCErrorCode status) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    //                                                    [self.navigationController popViewControllerAnimated:YES];
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                });
                                            }];
    }
}

- (void)initChatroomMemberInfo{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(45, 30, 85, 35)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 35/2;
    [self.view addSubview:view];
    view.alpha = 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 34, 34)];
    imageView.image = [UIImage imageNamed:@"head"];
    imageView.layer.cornerRadius = 34/2;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    UILabel *chatroomlabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 0, 45, 35)];
    chatroomlabel.numberOfLines = 2;
    chatroomlabel.font = [UIFont systemFontOfSize:12.f];
    chatroomlabel.text = [NSString stringWithFormat:@"小海豚\n2890人"];
    [view addSubview:chatroomlabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat memberHeadListViewY = view.frame.origin.x + view.frame.size.width;
    self.portraitsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(memberHeadListViewY,30,self.view.frame.size.width - memberHeadListViewY,35) collectionViewLayout:layout];
    [self.view addSubview:self.portraitsCollectionView];
    self.portraitsCollectionView.delegate = self;
    self.portraitsCollectionView.dataSource = self;
    self.portraitsCollectionView.backgroundColor = [UIColor clearColor];
    
    
    [self.portraitsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
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
         setBackgroundColor:[UIColor clearColor]];//背景色透明
        self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;//展示水平条
        self.conversationMessageCollectionView.alwaysBounceVertical = YES;//垂直可弹
        self.conversationMessageCollectionView.dataSource = self;
        self.conversationMessageCollectionView.delegate = self;
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
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    _collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];//刷新view添加到聊天信息
    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];//注册文字id
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];//注册提示id
    [self registerClass:[RCDLiveGiftMessageCell class]forCellWithReuseIdentifier:RCDLiveGiftMessageCellIndentifier];//注册礼物id
    [self changeModel:YES];//暂时不知道功能
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];//点击空白
    [_resetBottomTapGesture setDelegate:self];
    
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
//    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];//返回按钮
//    _backBtn.frame = CGRectMake(10, 35, 72, 25);
//    UIImageView *backImg = [[UIImageView alloc]
//                            initWithImage:[UIImage imageNamed:@"back.png"]];
//    backImg.frame = CGRectMake(0, 0, 25, 25);
//    [_backBtn addSubview:backImg];//返回按钮
//    [_backBtn addTarget:self
//                 action:@selector(leftBarButtonItemPressed:)
//       forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backBtn];
//    
//    _feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    _feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);//评论按钮
//    UIImageView *clapImg = [[UIImageView alloc]
//                            initWithImage:[UIImage imageNamed:@"feedback"]];
//    clapImg.frame = CGRectMake(0,0, 35, 35);
//    [_feedBackBtn addSubview:clapImg];
//    [_feedBackBtn addTarget:self
//                     action:@selector(showInputBar:)
//           forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_feedBackBtn];
//    
//    _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
//    UIImageView *clapImg2 = [[UIImageView alloc]
//                             initWithImage:[UIImage imageNamed:@"giftIcon"]];
//    clapImg2.frame = CGRectMake(0,0, 35, 35);
//    [_flowerBtn addSubview:clapImg2];
//    [_flowerBtn addTarget:self
//                   action:@selector(flowerButtonPressed:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_flowerBtn];
//    
//    _clapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
//    UIImageView *clapImg3 = [[UIImageView alloc]
//                             initWithImage:[UIImage imageNamed:@"heartIcon"]];
//    clapImg3.frame = CGRectMake(0,0, 35, 35);
//    [_clapBtn addSubview:clapImg3];
//    [_clapBtn addTarget:self
//                 action:@selector(clapButtonPressed:)
//       forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_clapBtn];
}

-(void)showInputBar:(id)sender{
    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:KBottomBarKeyboardStatus];
}

#pragma mark ---发送鲜花

-(void)flowerButtonPressed:(id)sender{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"0";
    [self sendMessage:giftMessage pushContent:@""];
    
}

#pragma mark ---发送掌声

-(void)clapButtonPressed:(id)sender{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"1";
    [self sendMessage:giftMessage pushContent:@""];
    [self praiseHeart];
}
#pragma mark ---未读消息View

- (UIView *)unreadButtonView {
    if (!_unreadButtonView) {
        _unreadButtonView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
        _unreadButtonView.userInteractionEnabled = YES;
        _unreadButtonView.backgroundColor = RCDLive_HEXCOLOR(0xffffff);
        _unreadButtonView.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabUnreadMsgCountIcon:)];
        [_unreadButtonView addGestureRecognizer:tap];
        _unreadButtonView.hidden = YES;
        [self.view addSubview:_unreadButtonView];
        _unreadButtonView.layer.cornerRadius = 4;
    }
    return _unreadButtonView;
}

#pragma mark ---底部新消息文字

- (UILabel *)unReadNewMessageLabel {
    if (!_unReadNewMessageLabel) {
        _unReadNewMessageLabel = [[UILabel alloc]initWithFrame:_unreadButtonView.bounds];
        _unReadNewMessageLabel.backgroundColor = [UIColor clearColor];
        _unReadNewMessageLabel.font = [UIFont systemFontOfSize:12.0f];
        _unReadNewMessageLabel.textAlignment = NSTextAlignmentCenter;
        _unReadNewMessageLabel.textColor = RCDLive_HEXCOLOR(0xff4e00);
        [self.unreadButtonView addSubview:_unReadNewMessageLabel];
    }
    return _unReadNewMessageLabel;
    
}

#pragma mark ---更新底部新消息提示显示状态
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    }
    else{
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

#pragma mark ---检查是否更新新消息提醒

- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.conversationDataRepository.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

#pragma mark ---获取显示的最后一条消息的indexPath

- (NSIndexPath *)getLastIndexPathForVisibleItems
{
    NSArray *visiblePaths = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    if (visiblePaths.count == 0) {
        return nil;
    }else if(visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}

#pragma mark ---点击未读提醒滚动到底部

- (void)tabUnreadMsgCountIcon:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self scrollToBottomAnimated:YES];
    }
}

#pragma mark ---初始化视频直播
- (void)initializedLiveSubViews {
//    _liveView = self.livePlayingManager.currentLiveView;
    _liveView.frame = self.view.frame;
    [self.view addSubview:_liveView];
    [self.view sendSubviewToBack:_liveView];
    
}

#pragma mark ---全屏和半屏模式切换
- (void)changeModel:(BOOL)isFullScreen {
//    self.livePlayingManager.currentLiveView.frame = self.view.frame;//播放器view为全屏view
    _titleView.hidden = YES;//标题隐藏
    
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];//聊天信息背景色透明
    CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
    self.contentView.frame = contentViewFrame;
    _feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    _flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    [self.view sendSubviewToBack:_liveView];
    
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height + 30;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    [self.conversationMessageCollectionView reloadData];
    [self.unreadButtonView setFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
}

#pragma mark ---顶部插入历史消息
- (void)pushOldMessageModel:(RCDLiveMessageModel *)model {
    if (!(!model.content && model.messageId > 0)
        && !([[model.content class] persistentFlag] & MessagePersistent_ISPERSISTED)) {
        return;
    }
    long ne_wId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        if (ne_wId == __item.messageId) {
            return;
        }
    }
    [self.conversationDataRepository insertObject:model atIndex:0];
}

#pragma mark ---加载历史消息(暂时没有保存聊天室消息)
- (void)loadMoreHistoryMessage {
    long lastMessageId = -1;
    if (self.conversationDataRepository.count > 0) {
        RCDLiveMessageModel *model = [self.conversationDataRepository objectAtIndex:0];
        lastMessageId = model.messageId;
    }
    
    NSArray *__messageArray =
    [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType
                                             targetId:_targetId
                                      oldestMessageId:lastMessageId
                                                count:10];
    for (int i = 0; i < __messageArray.count; i++) {
        RCMessage *rcMsg = [__messageArray objectAtIndex:i];
        RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMsg];
        [self pushOldMessageModel:model];
    }
    [self.conversationMessageCollectionView reloadData];
    if (_conversationDataRepository != nil &&
        _conversationDataRepository.count > 0 &&
        [self.conversationMessageCollectionView numberOfItemsInSection:0] >=
        __messageArray.count - 1) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:__messageArray.count - 1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                       atScrollPosition:UICollectionViewScrollPositionTop
                                                               animated:NO];
    }
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

#pragma mark ---滚动条滚动时显示正在加载loading
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 是否显示右下未读icon
    if (self.unreadNewMsgCount != 0) {
        [self checkVisiableCell];
    }
    
    if (scrollView.contentOffset.y < -5.0f) {
        [self.collectionViewHeader startAnimating];
    } else {
        [self.collectionViewHeader stopAnimating];
        _isLoading = NO;
    }
}

#pragma mark ---滚动结束加载消息 （聊天室消息还没存储，所以暂时还没有此功能）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
        _isLoading = YES;
    }
}

#pragma mark ---消息滚动到底部
 // animated 是否开启动画效果
- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.conversationMessageCollectionView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =
    [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath
                                                   atScrollPosition:UICollectionViewScrollPositionTop
                                                           animated:animated];
}

#pragma mark <UICollectionViewDataSource>
#pragma mark ---定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return self.userList.count;
    }
    return self.conversationDataRepository.count;
//    return 10;
}

#pragma mark ---每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        RCDLivePortraitViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"portraitcell" forIndexPath:indexPath];
        RCUserInfo *user = self.userList[indexPath.row];
        NSString *str = user.portraitUri;
        cell.portaitView.image = [UIImage imageNamed:str];
        cell.contentView.backgroundColor = [UIColor redColor];
        return cell;
    }
    //NSLog(@"path row is %d", indexPath.row);
    RCDLiveMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    RCDLiveMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier forIndexPath:indexPath];
        __cell.isFullScreenMode = YES;
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        cell = __cell;
        
    }
    
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

#pragma mark ---cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return CGSizeMake(35,35);
    }
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    if (model.cellSize.height > 0) {
        return model.cellSize;
    }
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCDLiveGiftMessage class]]) {
        model.cellSize = [self sizeForItem:collectionView atIndexPath:indexPath];
    } else {
        return CGSizeZero;
    }
    return model.cellSize;
}

#pragma mark ---计算不同消息的具体尺寸
- (CGSize)sizeForItem:(UICollectionView *)collectionView
          atIndexPath:(NSIndexPath *)indexPath {
    CGFloat __width = CGRectGetWidth(collectionView.frame);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    CGFloat __height = 0.0f;
    NSString *localizedMessage;
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
    }else if ([messageContent isMemberOfClass:[RCTextMessage class]]){
        RCTextMessage *notification = (RCTextMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        NSString *name;
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }
        localizedMessage = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
    }else if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)messageContent;
        localizedMessage = @"送了一个钻戒";
        if(notification && [notification.type isEqualToString:@"1"]){
            localizedMessage = @"为主播点了赞";
        }
        
        NSString *name;
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }
        localizedMessage = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
    }
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:localizedMessage];
    __height = __height + __labelSize.height;
    
    return CGSizeMake(__width, __height);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark --- UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark ---将消息加入本地数组
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    if([rcMessage.content isMemberOfClass:[RCDLiveGiftMessage class]]){
        model.messageId = -1;
    }
    if ([self appendMessageModel:model]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
}

#pragma mark ---如果当前会话没有这个消息id，把消息加入本地数组
- (BOOL)appendMessageModel:(RCDLiveMessageModel *)model {
    long newId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (newId == -1) {
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        RCDLiveMessageModel *message = self.conversationDataRepository[0];
        [[RCIMClient sharedRCIMClient]deleteMessages:@[@(message.messageId)]];
        [self.conversationDataRepository removeObjectAtIndex:0];
        [self.conversationMessageCollectionView reloadData];
    }
    
    [self.conversationDataRepository addObject:model];
    return YES;
}

#pragma mark ---UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

#pragma mark ---找出消息的位置
- (NSInteger)findDataIndexFromMessageList:(RCDLiveMessageModel *)model {
    NSInteger index = 0;
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCDLiveMessageModel *msg = (self.conversationDataRepository)[i];
        if (msg.messageId == model.messageId) {
            index = i;
            break;
        }
    }
    return index;
}


#pragma mark ---打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 // imageMessageContent 图片消息内容
- (void)presentImagePreviewController:(RCDLiveMessageModel *)model;
{
}

#pragma mark ---打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 // locationMessageCotent 位置消息
- (void)presentLocationViewController:
(RCLocationMessage *)locationMessageContent {
    
}

#pragma mark ---关闭提示框
 // theTimer theTimer description
- (void)timerForHideHUD:(NSTimer*)theTimer//弹出框
{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
    [theTimer invalidate];
    theTimer = nil;
}


/*!
 发送消息(除图片消息外的所有消息)
 
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */
- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent {
    if (_targetId == nil) {
        return;
    }
    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
                                targetId:self.targetId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId) {
                                     __weak typeof(&*self) __weakself = self;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                                     targetId:__weakself.targetId
                                                                                    direction:MessageDirection_SEND
                                                                                    messageId:messageId
                                                                                      content:messageContent];
                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
                                         }
                                         [__weakself appendAndDisplayMessage:message];
                                         [__weakself.inputBar clearInputView];
                                     });
                                 } error:^(RCErrorCode nErrorCode, long messageId) {
                                     [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
                                 }];
}

#pragma mark ---接收到消息的回调
 // notification
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __block RCMessage *rcMessage = notification.object;
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    NSDictionary *leftDic = notification.userInfo;
    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
        self.isNeedScrollToButtom = YES;
    }
    if (model.conversationType == self.conversationType &&
        [model.targetId isEqual:self.targetId]) {
        __weak typeof(&*self) __blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rcMessage) {
                [__blockSelf appendAndDisplayMessage:rcMessage];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuVisible=NO;
                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
                if (![self isAtTheBottomOfTableView]) {
                    self.unreadNewMsgCount ++ ;
                    [self updateUnreadMsgCountLabel];
                }
            }
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---定义展示的UICollectionViewCell的个数
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        //        collectionViewRect.size.height = self.contentView.bounds.size.height - 0;
        //        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
        self.inputBar.hidden = YES;
    }
}

#pragma mark ---判断消息是否在collectionView的底部
- (BOOL)isAtTheBottomOfTableView {
    if (self.conversationMessageCollectionView.contentSize.height <= self.conversationMessageCollectionView.frame.size.height) {
        return YES;
    }
    if(self.conversationMessageCollectionView.contentOffset.y +200 >= (self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 输入框事件
#pragma mark ---点击键盘回车或者emoji表情面板的发送按钮执行的方法
 // text  输入框的内容
- (void)onTouchSendButton:(NSString *)text{
    RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:text];
    [self sendMessage:rcTextMessage pushContent:nil];
    //    [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
    //    [self.inputBar setHidden:YES];
}

//修复ios7下不断下拉加载历史消息偶尔崩溃的bug
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark RCInputBarControlDelegate

#pragma mark ---根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
 // frame    输入框即将占用的大小
- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
    CGRect collectionViewRect = self.contentView.frame;
    self.contentView.backgroundColor = [UIColor clearColor];
    collectionViewRect.origin.y = self.view.bounds.size.height - frame.size.height - 237 +50;
    
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
    [self scrollToBottomAnimated:NO];
}

#pragma mark ---屏幕翻转
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection
                 withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
         if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
             //To Do: modify something for compact vertical size
             [self changeCrossOrVerticalscreen:NO];
         } else {
             [self changeCrossOrVerticalscreen:YES];
             //To Do: modify something for other vertical size
         }
         [self.view setNeedsLayout];
     } completion:nil];
}

#pragma mark ---横竖屏切换
-(void)changeCrossOrVerticalscreen:(BOOL)isVertical{
    _isScreenVertical = isVertical;
//    if (!isVertical) {
//        self.livePlayingManager.currentLiveView.frame = self.view.frame;
//    } else {
//        self.livePlayingManager.currentLiveView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.contentView.frame.size.height);
//    }
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height + 30;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        __item.cellSize = CGSizeZero;
    }
    [self changeModel:YES];
    [self.view bringSubviewToFront:self.backBtn];
    [self.inputBar setHidden:YES];
}

#pragma mark ---连接状态改变的回调
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}


- (void)praiseHeart{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(_clapBtn.frame.origin.x , _clapBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"heart"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 7);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)praiseGift{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(_flowerBtn.frame.origin.x , _flowerBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"gift"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 2);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gift%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
}




@end
