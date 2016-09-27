//
//  WalletMingXiVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletMingXiVC.h"
#import "MBProgressHUD+MJ.h"
#import "MineWalletMingxiCell.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "WalletMingXiModel.h"
@interface WalletMingXiVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


/**
 *  可提现列表
 */
@property (nonatomic, strong) NSMutableArray *moneyListArray;

@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation WalletMingXiVC
#pragma mark - system方法
- initWIthProductId:(NSNumber *)productId
{
    self = [super init];
    if (self) {
        
        
        self.productId = productId;
//        self.title=@"众筹明细";
        self.hidesBottomBarWhenPushed = YES;
        self.pageNo = 1;
        
        //刷新ui
        [self configUI];
        
        [self requestListDataWithPage:self.pageNo direction:1];
        
    }
    
    return  self;
}

#pragma mark - network
- (void)requestListDataWithPage:(NSInteger )pageNO direction:(NSInteger )direction{
    //direction 方向:1为下拉刷新 2为上拉加载更多
    
    NSString *url = Get_RecordDetail([ZYZCAccountTool getUserId], self.productId, pageNO);
    
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在加载"];
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            
            NSMutableArray *dataArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (direction == 1) {//说明是下拉
                if (dataArray.count > 0) {
                    
                    weakSelf.moneyListArray = dataArray;
                    weakSelf.pageNo = 2;
                    [weakSelf.tableView reloadData];
                    
                    [MBProgressHUD hideHUD];
                }else{
                    weakSelf.moneyListArray = nil;
                    [weakSelf.tableView reloadData];
                    
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showShortMessage:@"没有更多数据"];
                }
                
                
            }else{//上啦
                if (dataArray.count > 0) {
                    
                    [weakSelf.moneyListArray addObjectsFromArray:dataArray];
                    weakSelf.pageNo++;
                    [weakSelf.tableView reloadData];
                    
                    
                    [MBProgressHUD hideHUD];
                }else{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showShortMessage:@"没有更多数据"];
                }
            }
            
            
        }else{
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showShortMessage:@"连接服务器失败,请检查你的网络"];
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

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title=@"众筹明细";
    [self setBackItem];
}

#pragma mark - configUI方法

- (void)configUI
{
    [self setBackItem];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake( 5, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    
    WEAKSELF
    //上啦加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestListDataWithPage:weakSelf.pageNo direction:2];
    }];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //移除占位view
        weakSelf.pageNo = 1;
        [weakSelf requestListDataWithPage:weakSelf.pageNo direction:1];
    }];
}

#pragma mark - 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_moneyListArray.count == 0) {
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
    }
    return _moneyListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"WalletMingXiCell";
    MineWalletMingxiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MineWalletMingxiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.walletMingXiModel = _moneyListArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WalletMingXiCellRowHeight;
}


- (void)pressBack
{
    [super pressBack];
    
    
}
@end
