//
//  ZYWatchLiveViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/8/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYWatchLiveViewController.h"
#import "ZYLiveListModel.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
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
#import "ZYZCRCManager.h"
#import "MBProgressHUD+MJ.h"
#import "ChatBlackListModel.h"
#import "ZYWatchLiveView.h"
#import "MinePersonSetUpModel.h"
#import "ZYBottomPayView.h"
#import "WXApiManager.h"
#import "ZYWatchEndLiveVC.h"
#import "WatchEndLiveModel.h"
//输入框的高度
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size

@interface ZYWatchLiveViewController () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate, RCTKInputBarControlDelegate,RCConnectionStatusChangeDelegate, RCDLiveMessageCellDelegate, ZYBottomPayViewDelegate>
@property (nonatomic, strong) ZYLiveListModel *liveModel;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id <IJKMediaPlayback> player;
@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;
@property (nonatomic, strong) ZYWatchLiveView *watchLiveView;
/**
 *  存储长按返回的消息的model
 */
@property(nonatomic, strong) RCDLiveMessageModel *longPressSelectedModel;
/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;
/**
 *  是否正在加载消息
 */
@property(nonatomic, assign) BOOL isLoading;
/**
 *  会话名称
 */
@property(nonatomic,copy) NSString *navigationTitle;
/**
 *  点击空白区域事件
 */
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;
/**
 *  直播互动文字显示
 */
@property(nonatomic,strong) UIView *titleView ;

/**
 *  播放器view
 */
@property (strong, nonatomic) UIView *PlayerView;

/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;
/**
 *  显示直播人数的view
 */
@property (nonatomic, strong) UIView *livePersonNumberView;
/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;
/**
 *  当前融云连接状态
 */
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;
/**
 *  显示人数按钮
 */
@property(nonatomic,strong)UILabel *chatroomlabel;

@property (nonatomic, strong) ZYZCRCManager *RCManager;
// 私信按钮
@property (nonatomic, strong) UIButton *massageBtn;
// 关注按钮
@property (nonatomic, strong) UIButton *attentionButton;
@property(nonatomic,strong)UICollectionView *portraitsCollectionView;
@property(nonatomic,strong)NSMutableArray *userList;
// 打赏view
@property (nonatomic, strong) ZYBottomPayView *payView;
// 判断是不是进入私聊界面
@property (nonatomic, assign) BOOL isMessage;
@property (nonatomic, strong) WXApiManager *wxApiManger;
@end
/**
 *  文本cell标示
 */
static NSString *const rctextCellIndentifier = @"rctextCellIndentifier";

/**
 *  小灰条提示cell标示
 */
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";

/**
 *  礼物cell标示
 */
static NSString *const RCDLiveGiftMessageCellIndentifier = @"RCDLiveGiftMessageCellIndentifier";
@implementation ZYWatchLiveViewController
- (instancetype)initWatchLiveModel:(ZYLiveListModel *)liveModel
{
    self = [super init];
    if (self) {
        self.liveModel = liveModel;
        _targetId = liveModel.chatRoomId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    //初始化UI
    [self setupView];
    [self getIntoLive:self.liveModel.pullUrl];
    [self setupConstraints];
    [self initChatroomMemberInfo];
    [self enterInfoLiveRoom];
    [self requestData];
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setClearNavigationBar:YES];
    if (![self.player isPlaying] && !self.isMessage) {
        [self.player prepareToPlay];
    }
    [self.conversationMessageCollectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setClearNavigationBar:NO];
}

- (void)enterInfoLiveRoom
{
    WEAKSELF
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinExistChatRoom:self.liveModel.chatRoomId
         messageCount:-1
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
                 joinChatroomMessage.message = [NSString stringWithFormat: @"%@进入直播间",[ZYZCAccountTool account].realName];
                   joinChatroomMessage.extra = [NSString stringWithFormat:@"%@", [ZYZCAccountTool account].userId];
                 [weakSelf sendMessage:joinChatroomMessage pushContent:nil];
             });
         }error:^(RCErrorCode status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (status == KICKED_FROM_CHATROOM) {
                     [weakSelf showHintWithText:@"进入直播间失败"];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [weakSelf closeLiveButtonAction:nil];
                     });
                     
                 }
             });
         }];
    }
    [[RCIMClient sharedRCIMClient] getChatRoomInfo:self.targetId count:20 order:RC_ChatRoom_Member_Desc success:^(RCChatRoomInfo *chatRoomInfo) {
        [weakSelf getUserIdString:chatRoomInfo.memberInfoArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.chatroomlabel.text = [NSString stringWithFormat:@"直播\n%d人", chatRoomInfo.totalMemberCount];
        });
    } error:^(RCErrorCode status) {
        
    }];
}
#pragma mark - setup
- (void)setupView
{
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        [self.view addSubview:self.contentView];
    }
    
    //聊天消息区
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 10;
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
        CGFloat inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height +30;
        CGFloat inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
        CGFloat inputBarSizeWidth = self.contentView.frame.size.width;
        CGFloat inputBarSizeHeight = MinHeight_InputView;
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight) inViewConroller:nil];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
        self.inputBar.hidden = YES;
        [self.contentView addSubview:self.inputBar];
    }
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    _collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];
    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];
    [self registerClass:[RCDLiveGiftMessageCell class]forCellWithReuseIdentifier:RCDLiveGiftMessageCellIndentifier];
    [self changeModel:YES];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    self.watchLiveView = [[ZYWatchLiveView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.watchLiveView];
    [self.watchLiveView.closeLiveButton addTarget:self action:@selector(closeLiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.watchLiveView.feedBackBtn addTarget:self
                     action:@selector(showInputBar:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.watchLiveView.flowerBtn addTarget:self action:@selector(flowerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.watchLiveView.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initChatroomMemberInfo{
    UIView *livePersonNumberView = [[UIView alloc] initWithFrame:CGRectMake(15, 30, 135, 35)];
    livePersonNumberView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    livePersonNumberView.layer.cornerRadius = 35/2;
//    livePersonNumberView.alpha = 0.5;
    [self.view addSubview:livePersonNumberView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 34, 34)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.liveModel.faceImg] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    imageView.layer.cornerRadius = 34/2;
    imageView.layer.masksToBounds = YES;
    [livePersonNumberView addSubview:imageView];
    self.chatroomlabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 0, 45, 35)];
    self.chatroomlabel.numberOfLines = 2;
    self.chatroomlabel.font = [UIFont systemFontOfSize:12.f];
    [livePersonNumberView addSubview:self.chatroomlabel];
    
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButton.frame = CGRectMake(77, 2, 50, 31);
    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.attentionButton.backgroundColor = [UIColor ZYZC_MainColor];
    [self.attentionButton setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    self.attentionButton.layer.cornerRadius = 15;
    [livePersonNumberView addSubview:self.attentionButton];
    
    self.livePersonNumberView = livePersonNumberView;
    self.livePersonNumberView.hidden = YES;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat memberHeadListViewY = livePersonNumberView.frame.origin.x + livePersonNumberView.frame.size.width;
    self.portraitsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(memberHeadListViewY,30,self.view.frame.size.width - memberHeadListViewY,35) collectionViewLayout:layout];
    self.portraitsCollectionView.delegate = self;
    self.portraitsCollectionView.dataSource = self;
    self.portraitsCollectionView.backgroundColor = [UIColor clearColor];
    [self.portraitsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.portraitsCollectionView];
}
// 创建打赏界面
- (void)initPayView {
    if (!self.payView) {
        ZYBottomPayView * payView = [ZYBottomPayView loadCustumView];
        payView.delegate = self;
        CGRect rect = CGRectMake(0, KSCREEN_H - 120, KSCREEN_W, 120);
        payView.frame = rect;
        [payView.layer setCornerRadius:10];
        [self.view addSubview:payView];
        self.payView = payView;
    } else {
        self.payView.hidden = NO;
    }
}

- (void)setupConstraints
{
    [self.watchLiveView.feedBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.watchLiveView.closeLiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.watchLiveView.flowerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.watchLiveView.closeLiveButton).offset(-50);
        make.bottom.equalTo(self.view).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.watchLiveView.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.watchLiveView.flowerBtn).offset(-50);
        make.bottom.equalTo(self.view).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.watchLiveView.massageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.watchLiveView.shareBtn).offset(-50);
        make.bottom.equalTo(self.view).offset(-15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.portraitsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.livePersonNumberView).offset(10);
        make.top.equalTo(self.view).offset(30);
        make.width.equalTo(@(KSCREEN_W - 135));
        make.height.equalTo(@35);
    }];
}

- (void)updateLivePersonNumberViewFrame
{
    self.livePersonNumberView.frame = CGRectMake(15, 30, 85, 35);
    self.attentionButton.hidden = YES;
    [self.portraitsCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.livePersonNumberView).offset(80);
        make.top.equalTo(self.view).offset(30);
        make.width.equalTo(@(KSCREEN_W - 135));
        make.height.equalTo(@35);
    }];
}

- (void)setupData
{
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    self.userList = [[NSMutableArray alloc] init];
    [self registerNotification];
    [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
    self.wxApiManger = [[WXApiManager alloc] init];
}

#pragma mark - getData
- (void)clickClapButton
{
    NSDictionary *parameters= @{
                                @"spaceName":self.liveModel.spaceName,
                                @"streamName":self.liveModel.streamName,
                                };
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Post_Clap_Live andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSLog(@"resultresult");
    } andFailBlock:^(id failResult) {
        
    }];
}
- (void)getUserIdString:(NSArray *)userIdArray
{
    NSMutableString *userIdString = [NSMutableString string];
    for (int i = 0; i < userIdArray.count; i++) {
        RCChatRoomMemberInfo *chatroomInfo = userIdArray[i];
        if (i == 0) {
            [userIdString appendString:chatroomInfo.userId];
        } else {
            [userIdString appendString:[NSString stringWithFormat:@",%@", chatroomInfo.userId]];
        }
    }
    [self Get_UserInfo_List:userIdString];
}
//获取userList信息
- (void)Get_UserInfo_List:(NSString *)userIdString
{
    WEAKSELF
    NSString *url = Get_UserInfo_List(userIdString);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        weakSelf.userList = [ChatBlackListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [weakSelf.portraitsCollectionView reloadData];
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showError:@"请求数据失败"];
    }];
}

- (void)refreshUserList:(NSString *)userID
{
    WEAKSELF
    NSString *url = Get_UserInfo_List(userID);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSArray *dataArray = [ChatBlackListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if ([dataArray count] > 0 && weakSelf.userList.count > 0) {
            NSMutableArray *shouldDeleteArray = [NSMutableArray array];
            // 数据排重
            for (ChatBlackListModel* dataModel in dataArray) {
                for (ChatBlackListModel*userListModel in weakSelf.userList) {
                    if ([[NSString stringWithFormat:@"%@", dataModel.userId] isEqualToString:[NSString stringWithFormat:@"%@", userListModel.userId]]) {
                        [shouldDeleteArray addObject:userListModel];
                    }
                }
            }
            if (shouldDeleteArray.count > 0) {
                [weakSelf.userList removeObjectsInArray:shouldDeleteArray];
            }
            [weakSelf.userList insertObject:dataArray[0] atIndex:0];
            [weakSelf.portraitsCollectionView reloadData];
            weakSelf.chatroomlabel.text = [NSString stringWithFormat:@"直播\n%zd人", weakSelf.userList.count];
        }
    } andFailBlock:^(id failResult) {
        
    }];
}

- (void)getIntoLive:(NSString *)liveUrlString
{
    self.url = [NSURL URLWithString:liveUrlString];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    UIView *playerView = [self.player view];
    
    UIView *displayView = [[UIView alloc] init];
    displayView.frame = self.view.frame;
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.PlayerView];
    [self.view sendSubviewToBack:self.PlayerView];
    
    [self.PlayerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    
    [self installMovieNotificationObservers];
}

// 获取个人信息，是否关注
- (void)requestData
{
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *getUserInfoURL = Get_SelfInfo(userId, self.liveModel.userId);
    WEAKSELF
    [ZYZCHTTPTool getHttpDataByURL:getUserInfoURL withSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSDictionary *dic = (NSDictionary *)result;
        NSDictionary *data = dic[@"data"];
        if ([[NSString stringWithFormat:@"%@", data[@"friend"]] isEqualToString:@"1"]) {
            [weakSelf updateLivePersonNumberViewFrame];
            weakSelf.livePersonNumberView.hidden = NO;
        } else{
            weakSelf.livePersonNumberView.hidden = NO;
        }
    } andFailBlock:^(id failResult) {
        weakSelf.livePersonNumberView.hidden = NO;
    }];
}

#pragma mark - event
// 关闭直播按钮
- (void)closeLiveButtonAction:(UIButton *)sender
{
    [self removeMovieNotificationObservers];
    if ([self.player isPlaying]) {
        [self.player pause];
        [self.player stop];
    }
    [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                        success:^{
                                            NSLog(@"ddddd");
                                        } error:^(RCErrorCode status) {
                                            NSLog(@"eeeeee");
                                        }];
    [self.navigationController popViewControllerAnimated:YES];
}
// 点击关注按钮
- (void)attentionButtonAction:(UIButton *)sender
{
    WEAKSELF
    NSDictionary *params=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":self.liveModel.userId};
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:FOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
        //            NSLog(@"%@",result);
        if (isSuccess) {
            [MBProgressHUD showSuccess:@"关注成功"];
            [weakSelf updateLivePersonNumberViewFrame];
        }
        else
        {
            [MBProgressHUD showSuccess:@"关注失败"];
        }
        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showSuccess:@"关注失败"];
        
    }];
}

// 分享
- (void)shareBtnAction:(UIButton *)sender
{
    
}

- (void)messageBtnAction:(UIButton *)sender
{
//    self.isMessage = YES;
//    self.RCManager = [ZYZCxRCManager defaultManager];
//    [self.RCManager connectTarget:[NSString stringWithFormat:@"%@",self.liveModel.userId] andTitle:self.liveModel.realName andSuperViewController:self];
}

-(void)showInputBar:(id)sender{
    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:KBottomBarKeyboardStatus];
}

// 打赏功能
-(void)flowerButtonPressed:(UIButton *)sender
{
    [self initPayView];
}

// 点赞
-(void)clapButtonPressed{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"1";
    [self sendMessage:giftMessage pushContent:@""];
    [self praiseHeart];
    [self clickClapButton];
}
// 点击屏幕事件
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.payView.hidden = YES;
        [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
        self.inputBar.hidden = YES;
        [self clapButtonPressed];
    }
}

- (void)praiseHeart{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(self.watchLiveView.closeLiveButton.frame.origin.x , self.watchLiveView.closeLiveButton.frame.origin.y - 49, 35, 35);
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
    imageView.frame = CGRectMake(KSCREEN_W - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

/**
 *  未读消息View
 *
 *  @return
 */
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

/**
 *  底部新消息文字
 *
 *  @return return value description
 */
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

/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    } else {
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

/**
 *  检查是否更新新消息提醒
 */
- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.conversationDataRepository.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

/**
 *  获取显示的最后一条消息的indexPath
 *
 *  @return indexPath
 */
- (NSIndexPath *)getLastIndexPathForVisibleItems
{
    NSArray *visiblePaths = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    if (visiblePaths.count == 0) {
        return nil;
    } else if (visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}

/**
 *  点击未读提醒滚动到底部
 *
 *  @param gesture gesture description
 */
- (void)tabUnreadMsgCountIcon:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self scrollToBottomAnimated:YES];
    }
}

/**
 *  全屏和半屏模式切换
 *
 *  @param isFullScreen 全屏或者半屏
 */
- (void)changeModel:(BOOL)isFullScreen {
    // _titleView.hidden = YES;
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
    self.contentView.frame = contentViewFrame;
    self.watchLiveView.flowerBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    self.watchLiveView.flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    self.watchLiveView.clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    [self.view sendSubviewToBack:_PlayerView];
    
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height + 30;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    [self.conversationMessageCollectionView reloadData];
    [self.unreadButtonView setFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
}

/**
 *  顶部插入历史消息
 *
 *  @param model 消息Model
 */
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

/**
 *  加载历史消息(暂时没有保存聊天室消息)
 */
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

- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
}

#pragma mark - Selector func
// 支付回调
- (void)getPayResult
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userId=[ZYZCAccountTool getUserId];
    //判断支付是否成功
    NSString *httpUrl=GET_ORDERPAY_STATUS(userId, appDelegate.out_trade_no);
    
    [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         NSLog(@"%@",result);
         appDelegate.out_trade_no=nil;
         NSArray *arr=result[@"data"];
         NSDictionary *dic=nil;
         if (arr.count) {
             dic=[arr firstObject];
         }
         BOOL payResult=[[dic objectForKey:@"buyStatus"] boolValue];
         //支付成功
         if(payResult){
             [MBProgressHUD showSuccess:@"支付成功!"];
         }
         else{
             [MBProgressHUD showError:@"支付失败!"];
             appDelegate.out_trade_no=nil;
         }
     }
                      andFailBlock:^(id failResult)
     {
         [MBProgressHUD showError:@"网络出错,支付失败!"];
     }];
}
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        } default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

/**
 *  接收到消息的回调
 *
 *  @param notification
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __block RCMessage *rcMessage = notification.object;
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    NSString *content;
    if ([model.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage *)model.content;
        content = textMessage.content;
    } else if ([model.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *textMessage = (RCInformationNotificationMessage *)model.content;
        content = textMessage.message;
        
        //判断是否是直播结束通知
        WEAKSELF
        if ([content isEqualToString:@"直播结束"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeMovieNotificationObservers];
                if ([weakSelf.player isPlaying]) {
                    [weakSelf.player pause];
                    [weakSelf.player stop];
                }
                [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                                    success:^{
                                                        NSLog(@"ddddd");
                                                    } error:^(RCErrorCode status) {
                                                        NSLog(@"eeeeee");
                                                    }];

                
                ZYWatchEndLiveVC *endVC = [[ZYWatchEndLiveVC alloc] init];
                WatchEndLiveModel *endModel =[[WatchEndLiveModel alloc] init];
                endModel.headImgUrl = weakSelf.liveModel.faceImg;
                endModel.name = weakSelf.liveModel.realName;
                endModel.sex = weakSelf.liveModel.sex;
                endModel.isGuanzhu = weakSelf.attentionButton.hidden;
                endModel.userId = weakSelf.liveModel.userId;
                endVC.watchEndLiveModel = endModel;
                [weakSelf.navigationController pushViewController:endVC animated:YES];
            });
            
            return ;
        }
        
        [self refreshUserList:textMessage.extra];
    } else if ([model.content isMemberOfClass:[RCDLiveGiftMessage class]]) {
        RCDLiveGiftMessage *textMessage = (RCDLiveGiftMessage *)model.content;
        content = textMessage.type;
        if ([content isEqualToString:@"1"]) {//1.点赞
            dispatch_async(dispatch_get_main_queue(), ^{
                [self praiseHeart];
            });
        }
        return;
    }
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

/**
 *  消息滚动到底部
 *
 *  @param animated 是否开启动画效果
 */
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
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return self.userList.count;
    }
    return self.conversationDataRepository.count;
}

/**
 *  每个UICollectionView展示的内容
 *
 *  @return
 */
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
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    RCDLiveMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCTextMessage class]]){
        RCDLiveTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier forIndexPath:indexPath];
        __cell.isFullScreenMode = YES;
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        cell = __cell;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

/**
 *  cell的大小
 *
 *  @return
 */
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

/**
 *  计算不同消息的具体尺寸
 *
 *  @return
 */
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

/**
 *   UICollectionView被选中时调用的方法
 *
 *  @return
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  将消息加入本地数组
 *
 *  @return
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    if ([rcMessage.content isMemberOfClass:[RCDLiveGiftMessage class]]) {
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

/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 *
 *  @return
 */
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

/**
 *  UIResponder
 *
 *  @return
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

/**
 *  找出消息的位置
 *
 *  @return
 */
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



#pragma mark - Install Notifiacation
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    //支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayResult) name:kGetPayResultNotification object:nil];
}

/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}

/**
 *  注册cell
 *
 *  @param cellClass  cell类型
 *  @param identifier cell标示
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//#pragma mark - dealloc
//- (void)dealloc
//{
//    [self removeMovieNotificationObservers];
//}

/**
 *  关闭提示框
 *
 *  @param theTimer theTimer description
 */
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
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
/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 *
 *  @param text  输入框的内容
 */
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
#pragma mark - ZYBottomPayViewDelegate
// 打赏金额调用接口
- (void)clickPayBtnUKey:(NSInteger)moneyNumber
{
    WEAKSELF
    NSString *payMoney = [NSString stringWithFormat:@"%lf", moneyNumber / 10.0];
    NSDictionary *parameters= @{
                                @"spaceName":self.liveModel.spaceName,
                                @"streamName":self.liveModel.streamName,
                                @"price":@"0.01",
                                };
    [self.wxApiManger payForWeChat:parameters payUrl:Post_Flower_Live withSuccessBolck:^{
        weakSelf.payView.hidden = YES;
    } andFailBlock:^{
        
    }];
}
#pragma mark RCInputBarControlDelegate
/**
 *  根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
 *
 *  @param frame    输入框即将占用的大小
 *  @param duration 时间
 *  @param curve
 */
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

/**
 *  屏幕翻转
 *
 *
 */
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection
                 withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
         if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
             //To Do: modify something for compact vertical size
         } else {
             //To Do: modify something for other vertical size
         }
         [self.view setNeedsLayout];
     } completion:nil];
}

#pragma mark ---连接状态改变的回调
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}

- (void)praiseGift{
    UIImageView *imageView = [[UIImageView alloc] init];
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

- (CGSize)collectionViewContentSize
{
    return self.conversationMessageCollectionView.frame.size;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
