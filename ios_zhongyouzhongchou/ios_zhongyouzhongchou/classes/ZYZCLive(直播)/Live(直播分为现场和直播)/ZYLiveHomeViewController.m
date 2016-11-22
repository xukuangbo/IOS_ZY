//
//  ZYLiveHomeViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveHomeViewController.h"

#import <GRKPageViewController.h>
#import "ZYSceneViewController.h"
#import "ZYLiveListController.h"
#import "ZYFaqiLiveViewController.h"
#import "UINavigationBar+Awesome.h"
#import "GuideWindow.h"
#import "ZYNewGuiView.h"
#import "ZYGuideManager.h"
#import "ZYWatchLiveViewController.h"
#import "ZYSystemCommon.h"
@interface ZYLiveHomeViewController () <GRKPageViewControllerDataSource, GRKPageViewControllerDelegate, ShowDoneDelegate>
@property (strong, nonatomic) GRKPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (strong, nonatomic) UISegmentedControl *segmentControl;

// 通知view
@property (strong, nonatomic) ZYNewGuiView *notifitionView;
@property (strong, nonatomic) GuideWindow *guideWindow;
// 处理直播通知
@property (nonatomic, strong) ZYSystemCommon *systemCommon;
@property (strong, nonatomic) ZYLiveListModel *liveModel;
@end

@implementation ZYLiveHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationView];
    [self setupData];
    [self setupView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    // 收到直播通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receptionLiveNotification:) name:RECEPTION_LIVE_NOTIFICATION  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEPTION_LIVE_NOTIFICATION object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    [self setRightBarButtonItem:rightItem];
}
#pragma mark - setup
- (void)setupData
{
    self.systemCommon = [[ZYSystemCommon alloc] init];
    self.viewControllers = [NSMutableArray array];
    ZYLiveListController *liveListVC = [[ZYLiveListController alloc] init];
    ZYSceneViewController *sceneVC = [[ZYSceneViewController alloc] init];
    [self.viewControllers addObject:liveListVC];
    [self.viewControllers addObject:sceneVC];
}

- (void)setupView
{
    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame=CGRectMake(KSCREEN_W - 40, 10, 60, 30);
    [navRightBtn setTitle:@"发起" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn=navRightBtn;

    GRKPageViewController *pageViewController = [[GRKPageViewController alloc] init];
    pageViewController.view.backgroundColor = [UIColor whiteColor];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
//    pageViewController.scrollEnabled = NO;
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    [pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.pageViewController = pageViewController;
}

- (void)customNavigationView
{
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"直播", @"现场"]];

    segmentControl.frame = CGRectMake(110, 7, 158, 30);
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5;
    segmentControl.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor whiteColor].CGColor;
    [segmentControl.layer setBorderColor:cgColor];
    segmentControl.tintColor = [UIColor whiteColor];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:15.0f],nil];
//    [segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
//    NSDictionary *selecteddic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:14], [UIColor whiteColor],nil];
//
//    [segmentControl setTitleTextAttributes:selecteddic forState:UIControlStateSelected];
    
    [segmentControl addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl = segmentControl;
    self.navigationItem.titleView = self.segmentControl;
    
}

#pragma mark - liveNotification 接收通知提醒
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


#pragma mark - event
- (void)rightBtnAction
{
    ZYFaqiLiveViewController *liveController=[[ZYFaqiLiveViewController alloc]init];
    liveController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:liveController animated:YES];
}

- (void)segmentChangedValue:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            //  NSLog(@"现场");
            
        }
            break;
        case 1:
        {
            //  NSLog(@"直播");
        }
        default:
            break;
    }
    
    [self.pageViewController setCurrentIndex:sender.selectedSegmentIndex];
}

#pragma mark - GRKPageViewControllerDataSource

- (NSUInteger)pageCountForPageViewController:(GRKPageViewController *)controller {
    return self.viewControllers.count;
}
- (UIViewController *)viewControllerForIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller {
    UIViewController *viewController = nil;
    
    if (index < self.viewControllers.count) {
        viewController = self.viewControllers[index];
    }
    
    if (!viewController) {
        viewController = [[ZYZCBaseViewController alloc] init];
    }
    
    return viewController;
}

#pragma mark - GRKPageViewControllerDelegate

- (void)changedIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller {
    
    [self.segmentControl setSelectedSegmentIndex:index];
    if (index == 1) {
        self.navRightBtn.hidden = YES;
    } else {
        self.navRightBtn.hidden = NO;
    }
}

- (void)changedIndexOffset:(CGFloat)indexOffset forPageViewController:(GRKPageViewController *)controller {
    
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
