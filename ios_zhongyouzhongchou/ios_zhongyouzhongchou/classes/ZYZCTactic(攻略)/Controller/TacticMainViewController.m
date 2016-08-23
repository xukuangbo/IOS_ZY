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
@property(strong, nonatomic) CLLocationManager *locationManager;
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
    // 判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue]>= 8.0) {
            //如果大于ios大于8.0，就请求获取地理位置授权
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager requestWhenInUseAuthorization];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter
            = 10.0f;//
            [self.locationManager startUpdatingLocation];
        }else{
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [self.cityChoseButton setTitle:@"杭州" forState:UIControlStateNormal];
    }
}
#pragma mark - 获取用户所在位置代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            if (placeMark.locality.length > 2) {
                 self.currentCity = [placeMark.locality substringToIndex:2];
            }else{
                self.currentCity = placeMark.locality;
            }
           
            // ? placeMark.locality : placeMark.administrativeArea;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
            // 获取城市信息后, 异步更新界面信息.      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.cityDict[@*] = @[self.currentCity];
//                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                [self.cityChoseButton setTitle:self.currentCity forState:UIControlStateNormal];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                NSString *location=[user objectForKey:KMY_LOCALTION];
                if (!location||![location isEqualToString:self.currentCity]) {
                    [user setObject:self.currentCity forKey:KMY_LOCALTION];
                    [user synchronize];
                }
            });
    } else if (error == nil && placemarks.count == 0) {
//        NSLog(@"No location and error returned");
    } else if (error) {
//        NSLog(@"Location error: %@", error);
    }
     }];
    
    [manager stopUpdatingLocation];
}

//获取用户位置数据失败的回调方法，在此通知用户

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        [self.cityChoseButton setTitle:@"杭州" forState:UIControlStateNormal];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        [self.cityChoseButton setTitle:@"杭州" forState:UIControlStateNormal];
    }
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
