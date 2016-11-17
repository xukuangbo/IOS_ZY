//
//  ZYLiveViewController.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"


#ifndef __RCDLiveChatRoomViewController
#define __RCDLiveChatRoomViewController
#import <UIKit/UIKit.h>
#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLiveInputBar.h"
#import "LivePersonDataView.h"
#import "RCDLiveCollectionViewHeader.h"
#import <RongIMLib/RongIMLib.h>
#import "AppDelegate.h"
#import "RCDLiveMessageCell.h"
#import "RCDLiveTextMessageCell.h"
#import "RCDLiveGiftMessageCell.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveTipMessageCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLive.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "LiveFunctionView.h"
#import "showDashangMapView.h"
#import "ZYZCMCDownloadFileManager.h"
@class ZYLiveListModel;
///输入栏扩展输入的唯一标示
#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003
#if RC_VOIP_ENABLE
#define PLUGIN_BOARD_ITEM_VOIP_TAG     1004
#endif
//输入框的高度
#define MinHeight_InputView 50.0f
@protocol ZYLiveViewControllerDelegate <NSObject>

- (void)backHomePage;

@end
//文本cell标示
static NSString *const rctextCellIndentifier = @"rctextCellIndentifier";
//小灰条提示cell标示
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";
//礼物cell标示
static NSString *const RCDLiveGiftMessageCellIndentifier = @"RCDLiveGiftMessageCellIndentifier";
/*!
 聊天界面类
 */
@interface ZYLiveViewController : ZYZCBaseViewController
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIScrollViewDelegate>

- (instancetype)initLiveModel:(ZYLiveListModel *)createLiveModel;
#pragma mark - 会话属性
@property (nonatomic, copy  ) NSString *pushUrl;
@property (nonatomic, copy  ) NSString *pullUrl;
@property (nonatomic, copy) NSString *productID;
// 下载加锁
@property (nonatomic, strong) NSLock *lock;

// 下载打赏图片manager
@property (nonatomic, strong) ZYZCMCDownloadFileManager *downloadManager;
// 打赏礼物图片
@property (nonatomic, strong) NSMutableArray *giftImageArray;
@property (nonatomic, strong) NSMutableArray *downloadArray;

// 看视频的userid
@property(nonatomic,strong)NSMutableArray *userList;
// 创建直播model
@property (nonatomic, strong) ZYLiveListModel *createLiveModel;

@property (nonatomic, weak)id<ZYLiveViewControllerDelegate>delegate;
// 直播需要的属性
/** 直播任务流 */
@property (nonatomic, strong )  QPLiveSession  *liveSession;

//个人信息view
@property (nonatomic, strong) LivePersonDataView *personDataView;
/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;
//返回按钮
@property (nonatomic, strong) UIButton *backBtn;

//分享按钮
@property(nonatomic,strong)UIButton *shareBtn;

//评论按钮
@property(nonatomic,strong)UIButton *feedBackBtn;

//主播功能端按钮
@property(nonatomic,strong)UIButton *moreBtn;
//主播功能端view
@property (nonatomic, strong) LiveFunctionView *liveFunctionView;

//私信按钮
@property (nonatomic, strong) UIButton *massageBtn;

//刷新的view
@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;

//打赏动图界面
@property (nonatomic, strong) showDashangMapView *dashangMapView;

//点击空白区域事件
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;

/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

/*!
 屏幕方向
 */
@property(nonatomic, assign) BOOL isScreenVertical;

/*!
 播放内容地址
 */
@property(nonatomic, strong) NSString *contentURL;

#pragma mark - 聊天界面属性

/*!
 聊天内容的消息Cell数据模型的数据源
 
 @discussion 数据源中存放的元素为消息Cell的数据模型，即RCDLiveMessageModel对象。
 */
@property(nonatomic, strong) NSMutableArray<RCDLiveMessageModel *> *conversationDataRepository;

/*!
 消息列表CollectionView和输入框都在这个view里
 */
@property(nonatomic, strong) UIView *contentView;

/*!
 聊天界面的CollectionView
 */
@property(nonatomic, strong) UICollectionView *conversationMessageCollectionView;

#pragma mark - 输入工具栏

@property(nonatomic,strong) RCDLiveInputBar *inputBar;

#pragma mark - 显示设置
/*!
 设置进入聊天室需要获取的历史消息数量（仅在当前会话为聊天室时生效）
 
 @discussion 此属性需要在viewDidLoad之前进行设置。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
@property(nonatomic, assign) int defaultHistoryMessageCountOfChatRoom;
- (void)changeModel:(BOOL)isFullScreen;
- (void)leftBarButtonItemPressed:(UIButton *)sender;
@end
#endif
