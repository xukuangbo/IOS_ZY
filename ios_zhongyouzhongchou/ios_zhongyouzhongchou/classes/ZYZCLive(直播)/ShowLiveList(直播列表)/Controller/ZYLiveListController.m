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
#import "EntryPlaceholderView.h"

@interface ZYLiveListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger pageNo;
/** 无数据占位图 */
@property (nonatomic, strong) EntryPlaceholderView *entryView;

@property (nonatomic, strong) UIButton           *navRightBtn;


@end
static NSString *ID = @"ZYLiveListCell";

@implementation ZYLiveListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNo = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    
    [self setupView];
    
    _viewModel = [[ZYLiveListViewModel alloc] init];
    //请求网络数据
//    [self getLiveListData]
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _navRightBtn.hidden=NO;
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageNo = 1;
        [self requestListDataWithPage:self.pageNo direction:1];
        
    });
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    _navRightBtn.hidden=YES;
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
//    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    navRightBtn.frame=CGRectMake(self.view.width-60, 4, 60, 30);
//    [navRightBtn setTitle:@"发起" forState:UIControlStateNormal];
//    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navRightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:navRightBtn];
//    _navRightBtn=navRightBtn;

    self.view.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];

    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(@64);
        make.bottom.equalTo(@49);
    }];
    self.entryView = [EntryPlaceholderView viewWithSuperView:self.tableView type:EntryTypeLiveList];
//    self.entryView.userInteractionEnabled = NO;
    self.entryView.hidden = YES;
    
    WEAKSELF
    //上啦加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestListDataWithPage:weakSelf.pageNo direction:2];
    }];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //移除占位view
        weakSelf.entryView.hidden = YES;
        weakSelf.pageNo = 1;
        [weakSelf requestListDataWithPage:weakSelf.pageNo direction:1];
    }];
}

#pragma mark - network
- (void)requestListDataWithPage:(NSInteger )pageNO direction:(NSInteger )direction{
    
    NSString *url = Post_Live_List;
    NSDictionary *parameters = @{
                                 @"pageNo" : @(pageNO),
                                 @"pageSize" : @"10"
                                 };
    
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSMutableArray *dataArray = [ZYLiveListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        if (direction == 1) {//说明是下拉
            if (dataArray.count > 0) {
                
                weakSelf.entryView.hidden = YES;
                weakSelf.listArray = dataArray;
                weakSelf.pageNo = 2;
                [weakSelf.tableView reloadData];
                
                [MBProgressHUD hideHUD];
            }else{
                weakSelf.listArray = nil;
                weakSelf.entryView.hidden = NO;
                [weakSelf.tableView reloadData];
                
                [MBProgressHUD hideHUD];
            }
        }else{//上啦
            if (dataArray.count > 0) {
                
                [weakSelf.listArray addObjectsFromArray:dataArray];
                weakSelf.pageNo++;
                [weakSelf.tableView reloadData];
                
                
                [MBProgressHUD hideHUD];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showShortMessage:@"没有更多数据"];
            }
        }
        
        //结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } andFailBlock:^(id failResult) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showShortMessage:@"连接服务器失败,请检查你的网络"];
        
        //结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
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
    return 80 +  (KSCREEN_W - 20) / 20.0 * 9 + 10;
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
