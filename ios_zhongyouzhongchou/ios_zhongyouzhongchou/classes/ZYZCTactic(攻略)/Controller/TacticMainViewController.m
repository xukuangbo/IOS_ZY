//
//  TacticMainViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MoreFZCChooseSceneController.h"
#import "TacticTableView.h"
#import "ZYZCMessageListViewController.h"
#import "UIView+WZLBadge.h"
#import "ZYLocationManager.h"
#import "GuideWindow.h"
#import "ZYNewGuiView.h"
#import "ZYGuideManager.h"
#import "ZYWatchLiveViewController.h"
#import "ZYSystemCommon.h"
@interface TacticMainViewController ()<CLLocationManagerDelegate,UISearchBarDelegate, ShowDoneDelegate>
/**
 *  消息按钮
 */
@property (nonatomic, strong) UIButton *messageButton;
/**
 *  城市选择
 */
@property (nonatomic, strong) UIButton *cityChoseButton;
/**
 *  当地位置管理者
 */
@property (nonatomic, strong) ZYLocationManager *locationManager;
/**
 * 当地位置
 */
@property (nonatomic, copy) NSString *currentCity;


@property (nonatomic, weak) TacticTableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

// 通知view
@property (strong, nonatomic) ZYNewGuiView *notifitionView;
@property (strong, nonatomic) GuideWindow *guideWindow;
// 处理直播通知
@property (nonatomic, strong) ZYSystemCommon *systemCommon;
@property (strong, nonatomic) ZYLiveListModel *liveModel;

@end

@implementation TacticMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.systemCommon = [[ZYSystemCommon alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;
    /**
     *  创建tableView
     */
    [self createTableView];
    /**
     *  设置导航栏
     */
    [self setUpNavi];
    
    /**
     *  获取当地位置
     */
    [self getLocation];

    
}
/**
 *  设置导航栏
 */
- (void)setUpNavi
{
    //设置左边所在地
    UIButton *navLeftBtn=[ZYZCTool createBtnWithFrame:CGRectMake(0, 4, 60, 30) andNormalTitle:nil andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(cityChoseButton:)];
    navLeftBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
    [self.navigationController.navigationBar addSubview:navLeftBtn];
    _cityChoseButton=navLeftBtn;

    //设置右边的消息
    UIButton *messageButton =[ZYZCTool createBtnWithFrame:CGRectMake(self.view.width-41, 9, 25, 25) andNormalTitle:nil andNormalTitleColor:nil andTarget:self andAction:@selector(messageButton:)];
    [messageButton setImage:[UIImage imageNamed:@"btn_pas_ld"] forState:UIControlStateNormal];
//     [self.navigationController.navigationBar addSubview:messageButton];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem  alloc]initWithCustomView:messageButton];
    _messageButton = messageButton;
    
    
    //设置中间的搜索栏
    CGFloat searchBar_width=KSCREEN_W-120;
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake((KSCREEN_W-searchBar_width)/2, 4, searchBar_width, 30)];
    searchBar.layer.cornerRadius=KCORNERRADIUS;
    searchBar.delegate = self;
    searchBar.layer.masksToBounds=YES;
    searchBar.placeholder=@"搜索热门城市";
    searchBar.returnKeyType=UIReturnKeyDone;
    [searchBar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    searchBar.userInteractionEnabled = NO;
    for (UIView* subview in [[searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            textField.font = [UIFont systemFontOfSize:15.f];
            //修改输入框的颜色
            [textField setBackgroundColor:[UIColor whiteColor]];
            //修改placeholder的颜色
            [textField setValue:[UIColor ZYZC_TextGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else if([subview isKindOfClass:
                 NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
        }
    }
    [self.navigationController.navigationBar addSubview:searchBar];
    _searchBar = searchBar;
}
#pragma mark - Notifition
// 接收通知提醒
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

#pragma mark - 收到直播通知
- (void)receptionLiveNotification:(NSNotification *)notification
{
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

#pragma mark - 创建tableView
- (void)createTableView
{
    TacticTableView *tableView = [[TacticTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark - 导航栏的各种按钮动作
/**
 *  城市选择
 */
- (void)cityChoseButton:(UIButton *)button{
//    NSLog(@"____________");
}
/**
 *  消息按钮
 */
- (void)messageButton:(UIButton *)button{
    ZYZCMessageListViewController *msgController=[[ZYZCMessageListViewController alloc]init];
    msgController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:msgController animated:YES];
}

/**
 *  中间的搜索按钮
 */
-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    MoreFZCChooseSceneController *chooseSceneVC = [[MoreFZCChooseSceneController alloc] init];
    chooseSceneVC.isHomeSearch=YES;
    chooseSceneVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chooseSceneVC animated:YES];
    return NO;
}
- (void)searchButton:(UIButton *)button{
    
}
#pragma mark - 获取当前定位城市
- (void)getLocation
{
    WEAKSELF;
    _locationManager=[[ZYLocationManager alloc]init];
    _locationManager.getCurrentLocationResult=^(BOOL isSuccess,NSString *currentCity,NSString *currentAddress,NSString *coordinateStr)
    {
        if (isSuccess) {
            if (currentCity.length > 2) {
                weakSelf.currentCity = [currentCity substringToIndex:2];
            }
            else{
                weakSelf.currentCity = currentCity;
            }
            
            // 获取城市信息后, 异步更新界面信息.      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //                self.cityDict[@*] = @[self.currentCity];
                //                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.cityChoseButton setTitle:weakSelf.currentCity forState:UIControlStateNormal];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                NSString *location=[user objectForKey:KMY_LOCALTION];
                if (!location||![location isEqualToString:weakSelf.currentCity]) {
                    [user setObject:weakSelf.currentCity forKey:KMY_LOCALTION];
                    [user synchronize];
                }
            });
        }
        else
        {
            //访问被拒绝
            [weakSelf.cityChoseButton setTitle:@"杭州" forState:UIControlStateNormal];
        }
    };
    [_locationManager getCurrentLocation];
}

//在viewWillDisappear关闭定位
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEPTION_LIVE_NOTIFICATION object:nil];

    [self.locationManager stopUpdatingLocation];
    _searchBar.hidden=YES;
    _cityChoseButton.hidden=YES;
//    _messageButton.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 收到直播通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receptionLiveNotification:) name:RECEPTION_LIVE_NOTIFICATION  object:nil];
    //设置导航栏的颜色为透明
    [self.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(0)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.tableView changeNaviAction];

    [ZYZCAccountTool getUserUnReadMsgCount:^(NSInteger count) {
        if (count>0) {
            [self.messageButton showBadgeWithStyle:WBadgeStyleNumber value:count animationType:WBadgeAnimTypeNone];
        }
        else
        {
            [self.messageButton clearBadge];
        }
    }];
    _searchBar.hidden=NO;
    _cityChoseButton.hidden=NO;
//    _messageButton.hidden=NO;
    
}

@end
