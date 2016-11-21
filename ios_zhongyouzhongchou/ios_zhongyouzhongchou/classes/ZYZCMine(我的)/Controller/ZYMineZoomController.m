//
//  ZYMineZoomController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYMineZoomController.h"
#import "MineSetUpViewController.h"
#import "ZYZCMessageListViewController.h"
#import "ZYZCRCManager.h"
#import "UITabBarItem+WZLBadge.h"
#import "UIBarButtonItem+WZLBadge.h"
#import <RongIMKit/RongIMKit.h>
#import "MBProgressHUD+MJ.h"
#import "UserModel.h"
#import "ZYUserHeadView.h"
#import "ZYMineBusinessTable.h"
#import "ZYFootprintListView.h"
#import "GuideWindow.h"
#import "ZYNewGuiView.h"
#import "ZYGuideManager.h"
#import "ZYWatchLiveViewController.h"
#import "ZYSystemCommon.h"
#import "ZYZCTabBarController.h"
@interface ZYMineZoomController () <ShowDoneDelegate>

@property (nonatomic, strong) UILabel        *titleLab;
@property (nonatomic, strong) NSNumber       *meGzAll;
@property (nonatomic, strong) NSNumber       *gzMeAll;
@property (nonatomic, assign) BOOL           hasGetUserData;
@property (nonatomic, strong) UserModel      *userModel;

@property (nonatomic, strong) ZYUserHeadView      *mineHeadView;

@property (nonatomic, strong) ZYMineBusinessTable *businessTable;

//足迹
@property (nonatomic, strong) ZYFootprintListView  *footprintListView;
@property (nonatomic, assign) NSInteger             footprint_pageNo;
@property (nonatomic, strong) NSMutableArray       *footprintArr;

@property (nonatomic, assign) NSInteger             contentType;
// 通知view
@property (strong, nonatomic) ZYNewGuiView *notifitionView;
@property (strong, nonatomic) GuideWindow *guideWindow;

// 处理直播通知
@property (nonatomic, strong) ZYSystemCommon *systemCommon;
@property (strong, nonatomic) ZYLiveListModel *liveModel;

@end

@implementation ZYMineZoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setNavItems];
    [self configUI];
    //用户基本信息更改
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfoData) name:@"userInfoChange" object:nil];
    //收到聊天消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnReadChatMsgCount:) name:RCKitDispatchMessageNotification object:nil];
    //发布足迹成功
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishFootprintSuccess:) name:PUBLISH_FOOTPRINT_SUCCESS  object:nil];
    //删除足迹成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteFootprintSuccess:) name:DELETE_ONE_FOOTPRINT_SUCCESS  object:nil];
    

//    [self createNotificationView:@"众游红包正在直播\n点击进入直播间"];
}

#pragma mark - setup 
- (void)setupData
{
    _footprintArr=[NSMutableArray array];
    _footprint_pageNo=1;
    self.systemCommon = [[ZYSystemCommon alloc] init];
}

-(void)setNavItems
{
    _titleLab =[[UILabel alloc]initWithFrame:CGRectMake((self.view.width-200)/2, 0, 200, 44)];
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont boldSystemFontOfSize:20];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:_titleLab];
    
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:@"btn_set" andAction:@selector(leftButtonClick)];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.size = CGSizeMake(25, 25);
    [messageButton setImage:[UIImage imageNamed:@"btn_pas_ld"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
}

#pragma mark - 接收通知提醒
- (void)createNotificationView:(NSString *)content headImage:(NSString *)headImage
{
    ZYNewGuiView *notifitionView = [[ZYNewGuiView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 50) NotificationContent:content liveHeadImage:headImage];
    notifitionView.layer.masksToBounds = YES;
    notifitionView.layer.cornerRadius = 25;
    
    [self.guideWindow addSubview:notifitionView];
    self.notifitionView = notifitionView;
    self.notifitionView.rectTypeOriginalY = 283;
    notifitionView.showDoneDelagate = self;
    [notifitionView initSubViewWithTeacherGuideType:liveWindowType withContextViewType:rectTangleType];
    [self.guideWindow bringSubviewToFront:notifitionView];
    [self.guideWindow show];
}

- (GuideWindow *)guideWindow
{
    if (!_guideWindow) {
        _guideWindow = [[GuideWindow alloc] initWithFrame:CGRectMake(0, KSCREEN_H - 49 - 60, ScreenWidth - 20, 50)];
    }
    return _guideWindow;
}

#pragma mark - ShowDoneDelegate
- (void)showDone
{
    ZYWatchLiveViewController *watchLiveVC = [[ZYWatchLiveViewController alloc] initWatchLiveModel:self.liveModel];
    watchLiveVC.hidesBottomBarWhenPushed = YES;
    watchLiveVC.conversationType = ConversationType_CHATROOM;
    [self.navigationController pushViewController:watchLiveVC animated:YES];
    [self closeNotifitionView];
}

- (void)closeNotifitionView
{
    self.notifitionView = nil;
    [self.notifitionView removeFromSuperview];
    [self.guideWindow dismiss];
    self.guideWindow = nil;
}

-(UIViewController *)currentViewController
{
//    UIViewController *vc;
//    UIResponder* nextResponder = [self.view nextResponder];
//    if ([nextResponder isKindOfClass:[objc_getClass("UIViewController") class]] ) {
//        vc=(UIViewController*)nextResponder;
//        
//        return vc;
//    }
//    return vc;
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    topController = topController.presentedViewController;

    return topController;
}

#pragma mark - 收到直播通知
- (void)receptionLiveNotification:(NSNotification *)notification
{
    UIViewController *viewController = [self currentViewController];
    if ([viewController isKindOfClass:[ZYMineZoomController class]]) {
        NSLog(@"bbbbbbbbbbb");
    } else {
        NSLog(@"ccccccccc");
    }
    NSLog(@"viewController%@", viewController);
    NSDictionary *notificationObject = (NSDictionary *)notification.object;
    NSDictionary *apsDict = notificationObject[@"aps"];
    WEAKSELF
    NSDictionary *parameters= @{
                                @"spaceName":notificationObject[@"spaceName"],
                                @"streamName":notificationObject[@"streamName"]
                                };
    self.systemCommon.getLiveDataSuccess = ^(ZYLiveListModel *liveModel) {
        if (liveModel != nil) {
            weakSelf.liveModel = liveModel;
            [weakSelf createNotificationView:apsDict[@"alert"] headImage:notificationObject[@"headImg"]];
        } else {
            
        }
    };
    [self.systemCommon getLiveContent:parameters];
}


#pragma mark --- 设置
-(void)leftButtonClick
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MineSetUpVC" bundle:nil];
    MineSetUpViewController *mineSetUpViewController = [board instantiateViewControllerWithIdentifier:@"MineSetUpViewController"];
    mineSetUpViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineSetUpViewController animated:YES];
}

#pragma mark --- 消息
-(void)rightButtonClick
{
    DDLog(@"消息");
    ZYZCMessageListViewController *msgController=[[ZYZCMessageListViewController alloc]init];
    msgController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:msgController animated:YES];
}

#pragma mark --- 收到消息的回调
-(void)getUnReadChatMsgCount:(NSNotification *)notify
{
    RCIMClient *rcIMClient=[RCIMClient sharedRCIMClient];
    _businessTable.count = [rcIMClient getTotalUnreadCount];
    
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [weakSelf.businessTable reloadData];
                   });
}

#pragma mark --- 发布足迹成功
-(void)publishFootprintSuccess:(NSNotification *)notify
{
    _footprint_pageNo=1;
    [self getFootprintData];
}

#pragma mark --- 删除足迹成功
-(void)deleteFootprintSuccess:(NSNotification *)notify
{
    NSInteger footprintID=[notify.object integerValue];
    for (NSInteger i=_footprintArr.count-1; i>=0; i--) {
        ZYFootprintListModel *oneModel=_footprintArr[i];
        if (oneModel.ID ==footprintID) {
            [_footprintArr removeObject:oneModel];
            _footprintListView.dataArr=_footprintArr ;
            [_footprintListView reloadData];
            break;
        }
    }
}

-(void)configUI
{
    UIView *navBgView=[[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:navBgView];
    
    _businessTable=[[ZYMineBusinessTable alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _businessTable.contentInset=UIEdgeInsetsMake(My_User_Head_height, 0, KTABBAR_HEIGHT, 0);
    [self.view addSubview:_businessTable];
    [_businessTable setContentOffset:CGPointMake(0, -(My_User_Head_height)) animated:YES];

    _mineHeadView=[[ZYUserHeadView alloc]initWithUserZoomtype:MySelfZoomType];
    [self.view addSubview:_mineHeadView];
    
    WEAKSELF;
    //个人业务
    _businessTable.scrollDidScrollBlock=^(CGFloat offsetY)
    {
        [weakSelf tableScrollDidScroll:offsetY];
    };
    
    _businessTable.scrollWillBeginDraggingBlock=^()
    {
        weakSelf.mineHeadView.travelTypeView.userInteractionEnabled=NO;
        weakSelf.mineHeadView.segmentView.enabled=NO;
    };
    
    _businessTable.scrollDidEndDeceleratingBlock=^()
    {
        weakSelf.mineHeadView.travelTypeView.userInteractionEnabled=YES;
        weakSelf.mineHeadView.segmentView.enabled=YES;
    };
    
    //头部
    _mineHeadView.changeContent=^(NSInteger contentType)
    {
        weakSelf.contentType=contentType;
        weakSelf.mineHeadView.top = 0;
        
        if (contentType==0) {
            [weakSelf.businessTable setContentOffset:CGPointMake(0, -(My_User_Head_height)) animated:YES];
            weakSelf.businessTable.hidden =NO;
            weakSelf.footprintListView.hidden=YES;
        }
        else if (contentType==1)
        {
            [weakSelf createFootprintListView];
            [weakSelf.footprintListView setContentOffset:CGPointMake(0, -(My_User_Head_height)) animated:YES];
            weakSelf.businessTable.hidden =YES;
            weakSelf.footprintListView.hidden=NO;
        }
        weakSelf.mineHeadView.footprintTableOffSetY=-(My_User_Head_height);
    };
}

#pragma mark --- 创建足迹列表
-(void)createFootprintListView
{
    if (!_footprintListView) {
        _footprintListView=[[ZYFootprintListView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain andFootprintListType:MyFootprintList];
        _footprintListView.contentInset=UIEdgeInsetsMake(My_User_Head_height, 0, 0, 0);
        _footprintListView.backgroundColor=[UIColor ZYZC_BgGrayColor];
        [self.view addSubview:_footprintListView];
        [self.view bringSubviewToFront:_mineHeadView];
        //足迹
        WEAKSELF;
        _footprintListView.headerRefreshingBlock=^()
        {
            weakSelf.footprint_pageNo=1;
            [weakSelf getFootprintData];
        };
        
        _footprintListView.footerRefreshingBlock=^()
        {
            weakSelf.footprint_pageNo++;
            [weakSelf getFootprintData];
        };
        
        _footprintListView.scrollDidScrollBlock=^(CGFloat offsetY)
        {
            [weakSelf tableScrollDidScroll:offsetY];
        };
        _footprintListView.scrollWillBeginDraggingBlock=^()
        {
            weakSelf.mineHeadView.segmentView.enabled=NO;
        };
        
        _footprintListView.scrollDidEndDeceleratingBlock=^()
        {
            weakSelf.mineHeadView.segmentView.enabled=YES;
        };
        [weakSelf.footprintListView.mj_header beginRefreshing];
    }
}

#pragma mark --- table滑动
-(void)tableScrollDidScroll:(CGFloat)offsetY
{
    CGFloat headViewHeight =My_User_Head_height ;
    CGFloat min_offsetY=-114;
    CGFloat show_Name_offsetY=-184;
    if (offsetY<=min_offsetY) {
        if (offsetY < - (headViewHeight)) {
            _mineHeadView.top=0;
        } else {
            _mineHeadView.top=-(offsetY + headViewHeight);
        }
        _mineHeadView.footprintTableOffSetY=offsetY;
        
    } else {
        _mineHeadView.top=-(min_offsetY + headViewHeight);
        _mineHeadView.footprintTableOffSetY=min_offsetY;
    }
    if (offsetY > show_Name_offsetY) {
        NSString *name=_userModel.realName?_userModel.realName:_userModel.userName;
        self.titleLab.text=name.length>8?[name substringToIndex:8]:name;
    } else {
        self.titleLab.text=nil;
    }
    if (offsetY<=-(headViewHeight) + KEDGE_DISTANCE) {
    }
    else {
        _businessTable.bounces=YES;
    }

    
}

#pragma mark --- 获取个人信息
-(void)getUserInfoData
{
    NSString *userId=[ZYZCAccountTool getUserId];
    if (!userId) {
        return;
    }
    [MBProgressHUD showMessage:nil toView:self.view];
//    NSString *url=[NSString stringWithFormat:@"%@selfUserId=%@&userId=%@",GETUSERDETAIL,[ZYZCAccountTool getUserId],userId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"u_getUserDetail"];
    [parameter setValue:userId forKey:@"selfUserId"];
    [parameter setValue:userId forKey:@"userId"];

    [ZYZCHTTPTool GET:url parameters:parameter  withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [MBProgressHUD hideHUDForView:self.view];
         if (isSuccess) {
             _hasGetUserData=YES;
              _userModel=[[UserModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
             _mineHeadView.userModel=_userModel;
             _mineHeadView.friendNumber=[result[@"data"][@"meGzAll"] integerValue];
             _mineHeadView.fansNumber=[result[@"data"][@"gzMeAll"] integerValue];
             
         }
     } andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark --- 获取足迹数据
-(void)getFootprintData
{
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_getPageList"] andParameters:@{@"pageNo"  :[NSNumber numberWithInteger:_footprint_pageNo],@"targetId":[ZYZCAccountTool getUserId]}
    andSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        DDLog(@"%@",result);
        if (isSuccess) {
            MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_footprintListView.mj_footer ;
            if (_footprint_pageNo==1&&_footprintArr.count) {
                [_footprintArr removeAllObjects];
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            ZYFootprintDataModel  *listModel=[[ZYFootprintDataModel alloc]mj_setKeyValues:result];
            
            for(ZYFootprintListModel *oneModel in listModel.data)
            {
                [_footprintArr addObject:oneModel];
            }
            if (listModel.data.count==0) {
                _footprint_pageNo--;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
            }
            else
            {
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            _footprintListView.dataArr=_footprintArr;
            [_footprintListView reloadData];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        [_footprintListView.mj_header endRefreshing];
        [_footprintListView.mj_footer endRefreshing];
        
    }
     andFailBlock:^(id failResult) {
         [_footprintListView.mj_header endRefreshing];
         [_footprintListView.mj_footer endRefreshing];
     }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _titleLab.hidden=NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    if (!_hasGetUserData) {
        [self getUserInfoData];
    }
    // 收到直播通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receptionLiveNotification:) name:RECEPTION_LIVE_NOTIFICATION  object:nil];
    //获取未读消息数
    RCIMClient *rcIMClient=[RCIMClient sharedRCIMClient];
    _businessTable.count=[rcIMClient getTotalUnreadCount];
    [_businessTable reloadData];
    
    //清除tabbar上的消息提示红点
    if (_businessTable.count==0) {
        UITabBarItem *item = [self.tabBarController.tabBar.items lastObject];
        [item clearBadge];
    }
    
    //系统消息
    [ZYZCAccountTool getUserUnReadMsgCount:^(NSInteger count) {
        if (count>0) {
            [self.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:count animationType:WBadgeAnimTypeNone];
        }
        else
        {
            [self.navigationItem.rightBarButtonItem clearBadge];
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEPTION_LIVE_NOTIFICATION object:nil];

    _titleLab.hidden=YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
