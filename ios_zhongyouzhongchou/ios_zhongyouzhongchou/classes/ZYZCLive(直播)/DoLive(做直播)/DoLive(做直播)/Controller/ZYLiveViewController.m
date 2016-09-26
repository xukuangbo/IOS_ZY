//
//  ZYLiveViewController.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveViewController.h"
#import <objc/runtime.h>
#import "RCDLiveTipMessageCell.h"
#import "MBProgressHUD.h"
#import "RCDLivePortraitViewCell.h"
#import <Masonry.h>
#import <QPSDKCore/QPLive.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "DoLiveHeadView.h"
#import "ZYLiveListModel.h"
#import "ChatBlackListModel.h"
#import "ZYZCTabBarController.h"
#import "ZYLiveEndLiveVC.h"
#import "ZYLiveEndModel.h"
#import "MZTimerLabel.h"
#import "UIView+ZYLayer.h"
#import "LiveMoneyView.h"
#import "MinePersonSetUpModel.h"
#import "ZYLiveViewController+EVENT.h"
#define kBounds [UIScreen mainScreen].bounds.size
@interface ZYLiveViewController () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, RCDLiveMessageCellDelegate, UIGestureRecognizerDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate,RCConnectionStatusChangeDelegate,QPLiveSessionDelegate>

#pragma mark - 直播需要的属性
/** 电话中心 */
@property (nonatomic, strong )  CTCallCenter   *callCenter;
/** 美颜按钮 */
@property (nonatomic, strong )  UIButton       *skimBtn;
/** 电话连接状态 */
@property (nonatomic, assign )  BOOL           isCTCallStateDisconnected;
/** skim是否活跃 */
@property (nonatomic, assign )  BOOL           isSkimLive;

#pragma mark - 直播结束时需要的属性
/** 最大的人数 */
@property (nonatomic, assign) NSInteger totalPeopleCount;
/** 在线最大人数 */
@property (nonatomic, assign) NSInteger totalOnlinePeopleNumber;

#pragma mark - 聊天需要的属性

@property (nonatomic, strong) DoLiveHeadView *headView;
/** 总金额数据 */
@property (nonatomic, strong) LiveMoneyView *liveMoneyView;

//存储长按返回的消息的model
@property(nonatomic, strong) RCDLiveMessageModel *longPressSelectedModel;

//是否需要滚动到底部
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

//是否正在加载消息
@property(nonatomic) BOOL isLoading;

//会话名称
@property(nonatomic,copy) NSString *navigationTitle;

//底部显示未读消息view
@property (nonatomic, strong) UIView *unreadButtonView;
//未读消息
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;
//滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
@property (nonatomic, assign) NSInteger unreadNewMsgCount;
//当前融云连接状态
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;
//鲜花按钮
@property(nonatomic,strong)UIButton *flowerBtn;


//掌声按钮
@property(nonatomic,strong)UIButton *clapBtn;

@property(nonatomic,strong)UICollectionView *portraitsCollectionView;

@property(nonatomic,strong)NSMutableArray *userList;
// 创建直播model
@property (nonatomic, strong) ZYLiveListModel *createLiveModel;

@end

#pragma mark - 方法实现
@implementation ZYLiveViewController

/**
 进直播之前,需要:
    1.设置currenUserInfo
    2.初始化界面
    3.加入聊天室
    4.加入直播
    5.注册通知
 */

#pragma mark - 系统视图的方法
- (instancetype)initLiveModel:(ZYLiveListModel *)createLiveModel{
    self = [super init];
    if (self) {
        [self setUpRC];
        self.createLiveModel = createLiveModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.conversationMessageCollectionView reloadData];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationTitle = self.navigationItem.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听通知
    [self registerNotification];
    
    //设置主播userInfo
    [self setUpCurrentUserInfo];
    //设置头像信息
    [self setUpChatroomMemberInfo];
    //设置顶部views
    [self setUpTopViews];
    //设置底部views
    [self setUpBottomViews];
    // 初始化直播个人中心
    [self initLivePersonDataView];
    //配置直播
    [self setUpLive];
    //进入聊天室
    [self enterChatRoom];
}

#pragma mark - network 网络请求
- (void)createLiveSession
{
    WEAKSELF
    NSString *url = Post_Create_Live;
    NSDictionary *parameters;
    if (self.productID) {
        parameters = @{
                                     @"img" : self.createLiveModel.img,
                                     @"title" : self.createLiveModel.title,
                                     @"pullUrl" : self.createLiveModel.pullUrl,
                                     @"chatRoomId" : self.createLiveModel.chatRoomId,
                                     @"productId" : self.productID
                                     };
        
    }else{
        parameters = @{
                                     @"img" : self.createLiveModel.img,
                                     @"title" : self.createLiveModel.title,
                                     @"pullUrl" : self.createLiveModel.pullUrl,
                                     @"chatRoomId" : self.createLiveModel.chatRoomId
                                     };
    }
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            
        }else{
            [weakSelf dismissViewController];
        }
    } andFailBlock:^(id failResult) {
        [weakSelf dismissViewController];
    }];
}
/** 请求总金额数据 */
- (void)requestTotalMoneyDataParameters:(NSDictionary *)parameters {
//    zhibo/zhiboOrderTotle.action   streamName,spaceName  ，权限认证参数
    WEAKSELF
    NSString *url = Post_TotalMoney_Live;
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            if (parameters.count == 0) {
                weakSelf.liveMoneyView.moneyLabel.text = [NSString stringWithFormat:@"打赏:%.1f元", [result[@"data"] floatValue] / 100];
            } else {
                [weakSelf enterLiveEndVC:[NSString stringWithFormat:@"%.1f元", [result[@"data"] floatValue] / 100]];
            }
            DDLog(@"%@",result);
        }else{
            [weakSelf enterLiveEndVC:[NSString stringWithFormat:@"0.0元"]];
        }
    } andFailBlock:^(id failResult) {
        [weakSelf enterLiveEndVC:[NSString stringWithFormat:@"0.0元"]];
        DDLog(@"%@",failResult);
    }];
}

// 获取个人信息.获取个人中心数据
- (void)requestData:(NSString *)otherUserId
{
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *getUserInfoURL = Get_SelfInfo(userId, otherUserId);
    WEAKSELF
    [ZYZCHTTPTool getHttpDataByURL:getUserInfoURL withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            NSDictionary *dic = (NSDictionary *)result;
            NSDictionary *data = dic[@"data"];
            if ([[NSString stringWithFormat:@"%@", data[@"friend"]] isEqualToString:@"1"]){
                [weakSelf.personDataView.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            MinePersonSetUpModel  *minePersonModel=[[MinePersonSetUpModel alloc] mj_setKeyValues:data[@"user"]];
            minePersonModel.gzMeAll = data[@"gzMeAll"];
            minePersonModel.meGzAll = data[@"meGzAll"];
            weakSelf.personDataView.minePersonModel = minePersonModel;
        } else {
            NSLog(@"bbbbbbb");
        }
    } andFailBlock:^(id failResult) {
        NSLog(@"aaaaaaa");
    }];
}

- (void)enterLiveEndVC:(NSString *)totalMoneyCount
{
    ZYLiveEndLiveVC *endVC = [[ZYLiveEndLiveVC alloc] init];
    ZYLiveEndModel *endModel = [[ZYLiveEndModel alloc] init];
    endModel.endTime = _headView.timeLabel.timeLabel.text;
    endModel.totalPeopleCount = self.userList.count;
    endModel.totalOnlinePeopleNumber = self.userList.count;
    endModel.totalMoneyCount = totalMoneyCount;
    endVC.liveEndLiveModel = endModel;
    [self.navigationController pushViewController:endVC animated:YES];
}
#pragma mark - setup方法
// 设置主播UserInfo
- (void)setUpCurrentUserInfo{
    
    ZYZCAccountModel *accountModel = [ZYZCAccountTool account];
    
    NSString *faceImgStrng = accountModel.faceImg64.length > 0?accountModel.faceImg64 : accountModel.faceImg132;
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:[accountModel.userId stringValue]  name:accountModel.realName portrait:faceImgStrng];
    //设置userinfo
    [[RCDLive sharedRCDLive] setCurrentUserInfo:userInfo];
}

//初始化融云的一些数组信息等
- (void)setUpRC{
    
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    
    self.conversationMessageCollectionView = nil;
    
    self.defaultHistoryMessageCountOfChatRoom = -1;
    self.conversationType = ConversationType_CHATROOM;
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    
}

//直播
-(void)setUpLive{
    [self requestData:@"2454"];
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
    
    
    _liveFunctionView.liveSession = _liveSession;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view insertSubview:[_liveSession previewView] atIndex:0];
    });
}

//初始化页面控件
- (void)setUpTopViews
{
    //左上角头像
    _headView = [DoLiveHeadView new];
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KEDGE_DISTANCE);
        make.top.mas_equalTo(KStatus_Height);
        make.size.mas_equalTo(CGSizeMake(110, DoLiveHeadViewHeight));
    }];
    
    //添加头像点击事件
    [_headView addTarget:self action:@selector(showPersonData)];
    //左上角头像赋值
    NSString *faceImg = [ZYZCAccountTool account].faceImg64.length > 0? [ZYZCAccountTool account].faceImg64 : [ZYZCAccountTool account].faceImg132;
    [_headView.iconView sd_setImageWithURL:[NSURL URLWithString:faceImg] placeholderImage:[UIImage imageNamed:@"icon_live_placeholder"] options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
    //左上角人数
    _headView.numberPeopleLabel.text = @"0人";
    
    //左上角总金额
    _liveMoneyView = [[LiveMoneyView alloc] init];
    [self.view addSubview:_liveMoneyView];
    _liveMoneyView.moneyLabel.text = @"打赏:0";
    
    [_liveMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KEDGE_DISTANCE);
        make.top.equalTo(_headView.mas_bottom).offset(KEDGE_DISTANCE);
        make.height.mas_equalTo(LiveMoneyViewH);
        make.width.mas_equalTo(110);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    CGFloat memberHeadListViewY = view.frame.origin.x + view.frame.size.width;
    self.portraitsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    //注册头像的cell
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
    
    [self.view addSubview:self.portraitsCollectionView];
    
    //添加约束
    [_portraitsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_right).offset(KEDGE_DISTANCE);
        make.top.equalTo(_headView).offset(3);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    self.portraitsCollectionView.delegate = self;
    self.portraitsCollectionView.dataSource = self;
    self.portraitsCollectionView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - event 点击事件
//点击返回的时候消耗播放器和退出聊天室
- (void)leftBarButtonItemPressed:(UIButton *)sender {
    [_headView stopTimer];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    [self destroySession];
    [self quitConversationViewAndClear];
//    [self dismissViewControllerAnimated:NO completion:^{
//        if ([weakSelf.delegate respondsToSelector:@selector(backHomePage)]) {
//            [weakSelf.delegate backHomePage];
//        }
//    }];
//    发送一个退出直播的通知
    RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
    joinChatroomMessage.message = [NSString stringWithFormat: @"直播结束"];
    joinChatroomMessage.extra = [NSString stringWithFormat:@"直播结束"];
    [self sendMessage:joinChatroomMessage pushContent:nil];
    
    //请求总金额
    NSDictionary *parameters = @{
                                 @"streamName" : self.createLiveModel.streamName,
                                 @"spaceName" : self.createLiveModel.spaceName
                                 };
    [self requestTotalMoneyDataParameters:parameters];
}

//成员信息
- (void)setUpChatroomMemberInfo{
    self.userList = [NSMutableArray array];
}

//进入聊天室
- (void)enterChatRoom{
    __weak ZYLiveViewController *weakSelf = self;
    
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:self.targetId
         messageCount:-1
         success:^{
             
         }error:^(RCErrorCode status) {
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

#pragma mark ---全屏和半屏模式切换
- (void)changeModel:(BOOL)isFullScreen {
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];//聊天信息背景色透明
    CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
    self.contentView.frame = contentViewFrame;
    self.feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    self.feedBackBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    self.clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height + 30;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    [self.conversationMessageCollectionView reloadData];
    [self.unreadButtonView setFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
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

#pragma mark - APP进入前后台的动作
- (void)appResignActive{
    
    //销毁直播任务
    [self destroySession];
    
    //停止计时
    [_headView stopTimer];
    
    // 监听电话
    _callCenter = [[CTCallCenter alloc] init];
    _isCTCallStateDisconnected = NO;
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            _isCTCallStateDisconnected = YES;
        } else if ([call.callState isEqualToString:CTCallStateConnected]) {
            _callCenter = nil;
        }
    };
    
}

- (void)appBecomeActive{
    if (_isCTCallStateDisconnected) {
        sleep(2);
    }
    [self setUpLive];
}

#pragma mark - 直播代理方法
// 直播出错的代理方法
- (void)liveSession:(QPLiveSession *)session error:(NSError *)error{
    DDLog(@"直播出错");
    NSString *msg = [NSString stringWithFormat:@"%zd %@",error.code, error.localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Live Error" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新连接", nil];
    [alertView show];
}

// 网速较慢时的代理方法
- (void)liveSessionNetworkSlow:(QPLiveSession *)session{
    DDLog(@"网络太差");
    //这时候就提醒退出直播
    
}

// 推流连接成功
- (void)liveSessionConnectSuccess:(QPLiveSession *)session {
    [self createLiveSession];
    NSLog(@"connect success!");
}

// 麦克风打开成功
- (void)openAudioSuccess:(QPLiveSession *)session {
    DDLog(@"麦克风打开成功");
}

// 摄像头打开成功
- (void)openVideoSuccess:(QPLiveSession *)session {
    DDLog(@"摄像头打开成功");
}
// 收集日志
- (void)liveSession:(QPLiveSession *)session logInfo:(NSDictionary *)info{
    
}

// 音频初始化失败
- (void)liveSession:(QPLiveSession *)session openAudioError:(NSError *)error {
    
    DDLog(@"音频初始化失败");
    [self dismissViewController];
}

// 视频初始化失败
- (void)liveSession:(QPLiveSession *)session openVideoError:(NSError *)error {
    DDLog(@"视频初始化失败");
    [self dismissViewController];
}

// 音频编码器初始化失败
- (void)liveSession:(QPLiveSession *)session encodeAudioError:(NSError *)error {
    DDLog(@"音频编码器初始化失败");
    [self dismissViewController];
}

// 视频编码器初始化失败
- (void)liveSession:(QPLiveSession *)session encodeVideoError:(NSError *)error {
    DDLog(@"视频编码器初始化失败");
    [self dismissViewController];
}

//码率变化
- (void)liveSession:(QPLiveSession *)session bitrateStatusChange:(QP_LIVE_BITRATE_STATUS)bitrateStatus {
    DDLog(@"码率发生变化");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //重新连接
        [_liveSession connectServer];
    }
}


//加入聊天室失败的提示
- (void)loadErrorAlert:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dismissViewController
{
    [self showHintWithText:@"创建直播室失败"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.conversationType == ConversationType_CHATROOM) {
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                            success:^{

                                                
                                            } error:^(RCErrorCode status) {
                                               
                                            }];
    }
}

#pragma mark ---发送鲜花

-(void)flowerButtonPressed:(id)sender{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"0";
    [self sendMessage:giftMessage pushContent:@""];
}

#pragma mark ---发送掌声
-(void)clapButtonPressed{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"1";
    [self sendMessage:giftMessage pushContent:@""];
    [self praiseHeart];
    [self.portraitsCollectionView reloadData];
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
        ChatBlackListModel *user = self.userList[indexPath.row];
        NSString *str = user.faceImg;
        [cell.portaitView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
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
    
//    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 256.0 green:arc4random_uniform(256) / 256.0 blue:arc4random_uniform(256) / 256.0 alpha:1];
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
        
        localizedMessage = [NSString stringWithFormat:@"%@ %@",[ZYZCAccountTool account].realName,localizedMessage];
    }else if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)messageContent;
        localizedMessage = @"送了一个钻戒";
        if(notification && [notification.type isEqualToString:@"1"]){
            localizedMessage = @"为主播点了赞";
        }
        
        localizedMessage = [NSString stringWithFormat:@"%@ %@",[ZYZCAccountTool account].realName,localizedMessage];
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
    if ([self appendMessageModel:model]) {//判断消息数组中有无这个消息,没有就添加
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];//拿到最后一个index
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;//如果总个数 != 模型数组的个数-1
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];//插入这个消息
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {//判断去底部
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

#pragma mark - 发送消息
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
    messageContent.senderUserInfo.name = [ZYZCAccountTool account].realName;
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

#pragma mark - 接收到消息的回调
 // notification
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __block RCMessage *rcMessage = notification.object;
    
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    NSString *content;
    if ([model.content isMemberOfClass:[RCTextMessage class]]) {
        //消息类型
        RCTextMessage *textMessage = (RCTextMessage *)model.content;
        content = textMessage.content;
        if ([textMessage.extra isEqualToString:kPaySucceed]) {
            [self requestTotalMoneyDataParameters:nil];
        }
    } else if ([model.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        //调整步骤:1.此处处理通知的形式 2.在tipcell调整通知的cell样式
        RCInformationNotificationMessage *textMessage = (RCInformationNotificationMessage *)model.content;
        content = textMessage.message;
        
        //判断是否是打赏通知
        if([content isEqualToString:@"直播结束"]){
            
            return ;
        }else{
            //1.进入直播间 2.打赏
            [self refreshUserList:textMessage.extra];
        }
        
    } else if ([model.content isMemberOfClass:[RCDLiveGiftMessage class]]) {
        //礼物类型
        RCDLiveGiftMessage *textMessage = (RCDLiveGiftMessage *)model.content;
        content = textMessage.type;
        if ([content isEqualToString:@"1"]) {//1.点赞
            dispatch_async(dispatch_get_main_queue(), ^{
                [self praiseHeart];
            });
        }
        
        return ;
        
    }
    
    //这里是显示在cell中
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

#pragma mark ---刷新新成员信息
- (void)refreshUserList:(NSString *)userID
{
    WEAKSELF
    NSString *url = Get_UserInfo_List(userID);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSArray *dataArray = [ChatBlackListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if ([dataArray count] > 0) {
            NSMutableArray *shouldDeleteArray = [NSMutableArray array];
            // 数据排重
            for (ChatBlackListModel* dataModel in dataArray) {
                for (ChatBlackListModel*userListModel in weakSelf.userList) {
                    NSString *listModelString = [userListModel.userId stringValue];
                    NSString *dataModelString = [dataModel.userId stringValue];
                    if ([dataModelString isEqual:listModelString]) {
                        [shouldDeleteArray addObject:userListModel];
                        
                    }
                }
            }
            if (shouldDeleteArray.count > 0) {
                [weakSelf.userList removeObjectsInArray:shouldDeleteArray];
            }
            [weakSelf.userList insertObject:dataArray[0] atIndex:0];
            [weakSelf.portraitsCollectionView reloadData];
            weakSelf.headView.numberPeopleLabel.text = [NSString stringWithFormat:@"%zd人", weakSelf.userList.count];
        }
    } andFailBlock:^(id failResult) {
        
    }];
}

#pragma mark ---删除新用户信息
//- (void)deletePortraitsCollectionViewUser:(NSString *)extra{
//    
//    for (int i = 0; i < self.userList.count; i++) {
//        
//        ChatBlackListModel *model = self.userList[i];
//        NSString *userIdString = [NSString stringWithFormat:@"%@",model.userId];
//        if ([userIdString isEqualToString:extra]) {
//            [self.userList removeObject:model];
//            
//            [self.portraitsCollectionView reloadData];
//        }
//    }
//    
//}

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
//    CGRect collectionViewRect = self.contentView.frame;
//    self.contentView.backgroundColor = [UIColor clearColor];
//    collectionViewRect.origin.y = self.view.bounds.size.height - frame.size.height - 237 +50;
//    
//    collectionViewRect.size.height = 237;
//    [UIView animateWithDuration:duration animations:^{
//        [UIView setAnimationCurve:curve];
//        [self.contentView setFrame:collectionViewRect];
//        [UIView commitAnimations];
//    }];
    CGRect inputbarRect = self.inputBar.frame;
    inputbarRect.origin.y = self.view.bounds.size.height - frame.size.height;
//    inputbarRect.origin.y = collectionViewRect.size.height -50;
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
    imageView.frame = CGRectMake(self.backBtn.origin.x , self.backBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"heart"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % (int)(kBounds.width * 0.5)) + 20;
    CGFloat scale = round(random() % 2) + 0.5;
//    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 7);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png",imageName]];
    [UIView animateKeyframesWithDuration:1.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionCurveLinear animations:^{
        
        imageView.frame = CGRectMake((kBounds.width - startX), kBounds.height * 0.5 , 35 * scale, 35 * scale);
        
    } completion:^(BOOL finished) {
        
        [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionCurveLinear animations:^{
            imageView.top = kBounds.height * 0.25;
            imageView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
    }];
    
    
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
