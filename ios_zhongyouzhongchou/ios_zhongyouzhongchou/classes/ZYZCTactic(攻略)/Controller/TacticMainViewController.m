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
#import "UIBarButtonItem+WZLBadge.h"
#import "ZYLocationManager.h"
//#import "UploadVoucherVC.h"



@interface TacticMainViewController ()<CLLocationManagerDelegate>
/**
 *  消息按钮
 */
@property (nonatomic, weak) UIButton *messageButton;
/**
 *  城市选择
 */
@property (nonatomic, weak) UIButton *cityChoseButton;
/**
 *  当地位置管理者
 */
//@property(strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) ZYLocationManager *locationManager;
/**
 * 当地位置
 */
@property (nonatomic, copy) NSString *currentCity;


@property (nonatomic, weak) TacticTableView *tableView;

@end

@implementation TacticMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    //设置导航栏的颜色为透明
    
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(0)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    UIButton *cityChoseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityChoseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    cityChoseButton.size = CGSizeMake(40, 25);
//    UIImageView *downBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@ "ico_pla_more"]];
//    downBtn.centerY = 0.5 * cityChoseButton.height;
//    downBtn.right = cityChoseButton.width;
//    [cityChoseButton addSubview:downBtn];
    [cityChoseButton addTarget:self action:@selector(cityChoseButton:) forControlEvents:UIControlEventTouchUpInside];
//    cityChoseButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *cityBarbtn = [[UIBarButtonItem alloc] initWithCustomView:cityChoseButton];
    self.navigationItem.leftBarButtonItem = cityBarbtn;
    self.cityChoseButton = cityChoseButton;
    
    //设置右边的消息
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.size = CGSizeMake(25, 25);
    [messageButton setImage:[UIImage imageNamed:@"btn_pas_ld"] forState:UIControlStateNormal];
    
    [messageButton addTarget:self action:@selector(messageButton:) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.messageButton = messageButton;
    
    //设置中间的搜索栏
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat searchButtonW = self.cityChoseButton.right - self.messageButton.left - KEDGE_DISTANCE * 2;
    searchButton.size = CGSizeMake(searchButtonW, 30);
    [searchButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor whiteColor];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    [searchButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索热门城市" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
    _tableView.searchBarBtn = searchButton;
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
- (void)searchButton:(UIButton *)button{
    MoreFZCChooseSceneController *chooseSceneVC = [[MoreFZCChooseSceneController alloc] init];
    chooseSceneVC.isHomeSearch=YES;
    chooseSceneVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chooseSceneVC animated:YES];
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
    
    [self.locationManager stopUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(0)];
    [self.tableView changeNaviAction];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
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

@end
