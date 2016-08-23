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
#import "WalletMingxiViewModel.h"
@interface WalletMingXiVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WalletMingxiViewModel *mingxiViewModel;

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
        self.title=@"众筹明细";
        self.hidesBottomBarWhenPushed = YES;
        self.pageNo = 2;
        
        //刷新ui
        [self configUI];
        
        //请求数据
        self.mingxiViewModel = [WalletMingxiViewModel viewModel];
        __weak typeof(&*self) weakSelf = self;
    
        [self.mingxiViewModel headRefreshDataWithProductID:productId];
        
        [self.mingxiViewModel setBlockWithReturnBlock:^(id returnValue) {
            
            NSMutableArray *tempArray = returnValue;
            
            if (weakSelf.mingxiViewModel.refreshType == WalletMingXiRefreshTypeHead) {//下拉刷新
                
                if (tempArray.count > 0) {
                    
                    weakSelf.moneyListArray = tempArray;
                    weakSelf.pageNo = 2;
                    [weakSelf.tableView reloadData];
                }else{
                    //说明没有更多数据
                    [MBProgressHUD showError:@"没有更多数据了哦"];
                    
                }
            }else{//上啦加载更多
                if (tempArray.count > 0) {
                    
                    [weakSelf.moneyListArray addObjectsFromArray:tempArray];
                    
                    [weakSelf.tableView reloadData];
                    
                    weakSelf.pageNo++;
                    
                }else{
                    //说明没有更多数据
                    [MBProgressHUD showShortMessage:@"没有更多数据了哦"];
                }
            }
            //结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        } WithErrorBlock:^(id errorCode) {
            [MBProgressHUD showError:@"网络错误\n请求失败"];
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        } WithFailureBlock:^{
            [MBProgressHUD showError:@"网络错误\n请求失败"];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
        
        //上啦加载更多
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf.mingxiViewModel footRefreshDataWithProductID:productId pageNo:weakSelf.pageNo];
        }];
        
        //下拉刷新
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.mingxiViewModel headRefreshDataWithProductID:productId];
        }];
    }
    
    return  self;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
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
    
}

#pragma mark - set方法


#pragma mark - button点击方法

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
    
    //发送一个刷新数据的通知
    [ZYNSNotificationCenter postNotificationName:@"refreshWalletData" object:nil];
    
}
@end
