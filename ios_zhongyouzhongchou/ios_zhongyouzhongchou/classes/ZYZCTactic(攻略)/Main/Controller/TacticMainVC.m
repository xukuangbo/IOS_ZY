//
//  TacticMainVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainVC.h"
#import "TacticMainViewModel.h"
#import "TacticVideoModel.h"
#import "TacticTableView.h"
#import <CoreLocation/CoreLocation.h>
#import "SDCycleScrollView.h"
#import "ZYZCBaseTableViewCell.h"
#import "TacticMainHeadCell.h"
#import "TacticModel.h"
#import "TactciMainVideoCell.h"
#import "TacticMainCountryCell.h"
#import "TacticMainCityCell.h"
#import "ZYZCRCManager.h"
#import "MBProgressHUD+MJ.h"
#import <RongIMKit/RongIMKit.h>


//用于删除的头文件
#import "WalletMingXiVC.h"
@interface TacticMainVC ()<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) TacticModel *tacticModel;

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


@property (nonatomic, weak) UITableView *tableView;


@end

@implementation TacticMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    TacticMainViewModel *viewModel = [TacticMainViewModel viewModel];
    self.viewModel = viewModel;
    
    [viewModel requestMainData];
    __weak typeof(&*self) weakSelf = self;
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        _tacticModel = returnValue;
        
        [self.tableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        [MBProgressHUD showError:@"网络错误\n请求失败"];
    }];
}


- (void)configUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    /**
     *  创建tableView
     */
    [self createTableView];
    /**
     *  设置导航栏
     */
    [self setUpNavi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnReadChatMsgCount:) name:RCKitDispatchMessageNotification object:nil];
}


-(void)getUnReadChatMsgCount:(NSNotification *)notify
{
    RCIMClient *rcIMClient=[RCIMClient sharedRCIMClient];
    int  count = [rcIMClient getTotalUnreadCount];
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.badgeValue = @"1";
//    DDLog(@"未读消息总数：%d",count);
//    if (count>0) {
//        
//    }
//    [self messageButton:nil];
}


#pragma mark ---设置导航栏
- (void)setUpNavi
{
    //设置导航栏的颜色为透明
    [self.navigationController.navigationBar cnSetBackgroundColor:kHome_navi_bgcolor(0)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    UIButton *cityChoseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityChoseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    cityChoseButton.size = CGSizeMake(40, 25);
    [cityChoseButton addTarget:self action:@selector(cityChoseButton:) forControlEvents:UIControlEventTouchUpInside];
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
//    _tableView.searchBarBtn = searchButton;
}

#pragma mark -- event
- (void)searchButton:(UIButton *)sender
{
    
}
#pragma mark - 创建tableView
- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource =self;
    self.tableView = tableView;
}


#pragma mark - UITableDelegate和Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //头饰图
    NSInteger headInt = 1;
    //国家,城市,视频
    NSInteger VCCCount = 3;
    //广告
    NSInteger guanggaoCount =1;
    
    return (headInt + VCCCount + guanggaoCount) * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TacticMainHeadCell *cell = [TacticMainHeadCell cellWithTableView:tableView];
        cell.scrollImageArray = self.tacticModel.indexImg;
        return cell;
    }else if (indexPath.row == 2){//视频
        TactciMainVideoCell *cell = [TactciMainVideoCell cellWithTableView:tableView maxViewCount:3];
        cell.videoArray = self.tacticModel.videos;
        return cell;
    }else if (indexPath.row == 4){//国家
        TacticMainCountryCell *cell = [TacticMainCountryCell cellWithTableView:tableView maxViewCount:6];
        cell.countryArray = self.tacticModel.countryViews;
        return cell;
    }else if (indexPath.row == 6){//城市
        TacticMainCityCell *cell = [TacticMainCityCell cellWithTableView:tableView maxViewCount:6];
        cell.cityArray = self.tacticModel.mgViews;
        return cell;
    }
    
    else{
        if (indexPath.row % 2 == 1) {
            UITableViewCell *cell = [ZYZCBaseTableViewCell createNormalCell];
            return cell;
        }else{
            NSString *ID = @"TacticTableViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 256.0 green:arc4random_uniform(256) / 256.0 blue:arc4random_uniform(256) / 256.0 alpha:1];
            
            return cell;
        }
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//头
        return kHeadImageHeight;
    }else if (indexPath.row == 2){
        return kTacticViewMapHeight(3);
    }else if (indexPath.row == 4){
        return kTacticViewMapHeight(6);
    }else if (indexPath.row == 6){
        return kTacticViewMapHeight(6);
    }
    else{
        if (indexPath.row % 2 == 1) {
            return  KEDGE_DISTANCE;
        }else{
            return 80;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    }
}


#pragma mark ---删除的接口
- (void)messageButton:(UIButton *)button
{
    [self.navigationController pushViewController:[[WalletMingXiVC alloc] initWIthProductId:@95] animated:YES];
}

- (void)dealloc
{
    
}
@end
