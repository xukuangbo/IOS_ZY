//
//  ZYLiveListController.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveListController.h"
#import "ZYLiveListCell.h"
#import "ZYLiveListModel.h"
#import "ZYLiveListViewModel.h"
#import <RACEXTScope.h>
#import "MBProgressHUD+MJ.h"
#import "ZYWatchLiveViewController.h"
#import "ZYLiveViewController.h"
#import "ZYFaqiLiveViewController.h"
@interface ZYLiveListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger pageNo;
@end
static NSString *ID = @"ZYLiveListCell";

@implementation ZYLiveListController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    
    [self setupView];
    
    _viewModel = [[ZYLiveListViewModel alloc] init];
    //请求网络数据
    [self getLiveListData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getLiveListData];
}

- (void)rightBtnAction
{
    ZYFaqiLiveViewController *liveController=[[ZYFaqiLiveViewController alloc]init];
    liveController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:liveController animated:YES];
}

#pragma mark - setup
- (void)setupView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addLive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
//    
//    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    [button setImage:[UIImage imageNamed:@"addLive"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.view.backgroundColor = [UIColor ZYZC_MainColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - network
- (void)getLiveListData
{
    WEAKSELF
    [self.viewModel headRefreshData];
    [self.viewModel setBlockWithReturnBlock:^(id returnValue) {
        
        NSMutableArray *tempArray = returnValue;
        
        if (weakSelf.viewModel.refreshType == RefreshTypeHead) {//下拉刷新
            
            if (tempArray.count > 0) {
                weakSelf.listArray = tempArray;
                weakSelf.pageNo = 2;
                [weakSelf.tableView reloadData];
                
            }else{
                weakSelf.listArray = nil;
                [weakSelf.tableView reloadData];
            }
        }else{//上啦加载更多
            if (tempArray.count > 0) {
                
                [weakSelf.listArray addObjectsFromArray:tempArray];
                
                [weakSelf.tableView reloadData];
                
                weakSelf.pageNo++;
                
            }else{
                //说明没有更多数据
            }
        }
        //结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } WithErrorBlock:^(id errorCode) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } WithFailureBlock:^{
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //上啦加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.viewModel footRefreshDataWithPageNo:_pageNo];
    }];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel headRefreshData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYLiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZYLiveListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.model = self.listArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 +  KSCREEN_W - 20 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYWatchLiveViewController *watchLiveVC = [[ZYWatchLiveViewController alloc] initWatchLiveModel:self.listArray[indexPath.row]];
    watchLiveVC.hidesBottomBarWhenPushed = YES;
    watchLiveVC.conversationType = ConversationType_CHATROOM;
    [self.navigationController pushViewController:watchLiveVC animated:YES];
}

@end
