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
#import "NetWorkManager.h"

typedef enum : NSUInteger {
    VCTypeKtxMx,
    VCTypeYbjMx,
} VCType;

static int pagesize = 10;
@interface WalletMingXiVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  可提现列表
 */
@property (nonatomic, strong) NSMutableArray *moneyListArray;

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, assign) VCType VCType;
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
        self.pageNo = 1;
        self.VCType = VCTypeKtxMx;
        
        self.moneyListArray = [NSMutableArray array];
        //刷新ui
        [self configUI];
        
        [self.tableView.mj_header beginRefreshing];
    }
    
    return  self;
}

- initWIthYbjSpaceName:(NSString *)spaceName StreamName:(NSString *)streamName{
    self = [super init];
    if (self) {
        
        
        self.spaceName = spaceName;
        self.streamName = streamName;
        self.title=@"旅费筹集记录";
        self.hidesBottomBarWhenPushed = YES;
        self.pageNo = 1;
        self.VCType = VCTypeYbjMx;
        
        self.moneyListArray = [NSMutableArray array];
        //刷新ui
        [self configUI];
        
        [self.tableView.mj_header beginRefreshing];
    }
    return  self;
}


//down = 0;
//hbstatus = 1;
//headImage = "http://www.sosona.cn:8080/viewSpot/images/317/1471319305999_640.jpg";
//productDest = "[\"\U676d\U5dde\",\"\U5b89\U7279\U536b\U666e\",\"\U91d1\U8fb9\",\"\U91dc\U5c71\",\"\U91d1\U8fb9\",\"\U91dc\U5c71\",\"\U91d1\U8fb9\",\"\U91dc\U5c71\",\"\U5df4\U5398\U5c9b\"]";
//productEndTime = "2016-11-01";
//productId = 144;
//productName = ingot;
//productPrice = 100;
//productStartTime = "2016-10-27";
//pzstatus = 0;
//status = 5;
//travelendTime = "2016-11-03";
//travelstartTime = "2016-11-02";
//txstatus = 2;
//txtotles = 300;
//up = 0;

#pragma mark - network
- (void)loadNewData
{
    _pageNo = 1;
    NSString *url;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if (self.VCType == VCTypeKtxMx) {//1.可提现明细,get请求
        
        url = [[ZYZCAPIGenerate sharedInstance] API:@"list_recordDetail"];
        [parameter setValue:[NSString stringWithFormat:@"%@", self.productId] forKey:@"productId"];
        [parameter setValue:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"pageNo"];
        [parameter setValue:@(pagesize) forKey:@"pageSize"];
//        [parameter setValue:[ZYZCAccountTool getOpenid] forKey:@"openid"];
        [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
        WEAKSELF
        [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
            
            NSArray *tempArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (tempArray.count > 0) {
                [weakSelf.moneyListArray removeAllObjects];
                [weakSelf.moneyListArray addObjectsFromArray:tempArray];
                [weakSelf.tableView reloadData];
                weakSelf.pageNo++;
            }else{
                
                [MBProgressHUD showError:result[@"data"] toView:weakSelf.view];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } andFailBlock:^(id failResult) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        }];
    }else if(self.VCType == VCTypeYbjMx){//2.预备金明细
        
        url = [[ZYZCAPIGenerate sharedInstance] API:@"zhibo_zhiboOrderList"];
        [parameter setValue:[NSString stringWithFormat:@"%@", self.spaceName] forKey:@"spaceName"];
        [parameter setValue:[NSString stringWithFormat:@"%@", self.streamName] forKey:@"streamName"];
        [parameter setValue:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"pageNo"];
        [parameter setValue:@(pagesize) forKey:@"pageSize"];
        [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
        
        WEAKSELF
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
            
            NSArray *tempArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (tempArray.count > 0) {
                [weakSelf.moneyListArray removeAllObjects];
                [weakSelf.moneyListArray addObjectsFromArray:tempArray];
                [weakSelf.tableView reloadData];
                weakSelf.pageNo++;
            }else{
                
                [MBProgressHUD showError:result[@"data"] toView:weakSelf.view];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } andFailBlock:^(id failResult) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        }];
    }else{
        
        return ;
    }
   
}

- (void)loadMoreData
{
    NSString *url;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if (self.VCType == VCTypeKtxMx) {//1.可提现明细
        
        url = [[ZYZCAPIGenerate sharedInstance] API:@"list_recordDetail"];
        [parameter setValue:[NSString stringWithFormat:@"%@", self.productId] forKey:@"productId"];
        [parameter setValue:@"fause" forKey:@"cache"];
        [parameter setValue:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"pageNo"];
        [parameter setValue:@(pagesize) forKey:@"pageSize"];
        
        WEAKSELF
        [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
            DDLog(@"result:%@",result);
            MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)weakSelf.tableView.mj_footer ;
            NSArray *tempArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (tempArray.count > 0) {
                [weakSelf.moneyListArray addObjectsFromArray:tempArray];
                [weakSelf.tableView reloadData];
                weakSelf.pageNo++;
                [autoFooter setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
            }else{
                [autoFooter setTitle:@"没有更多数据了.." forState:MJRefreshStateRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } andFailBlock:^(id failResult) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        }];
    }else if(self.VCType == VCTypeYbjMx){//2.预备金明细
        
        url = [[ZYZCAPIGenerate sharedInstance] API:@"zhibo_zhiboOrderList"];
        [parameter setValue:[NSString stringWithFormat:@"%@", self.spaceName] forKey:@"spaceName"];
        [parameter setValue:[NSString stringWithFormat:@"%@", self.streamName] forKey:@"streamName"];
        [parameter setValue:@"fause" forKey:@"cache"];
        [parameter setValue:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"pageNo"];
        [parameter setValue:@(pagesize) forKey:@"pageSize"];
        
        WEAKSELF
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
            
            MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)weakSelf.tableView.mj_footer ;
            NSArray *tempArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (tempArray.count > 0) {
                [weakSelf.moneyListArray addObjectsFromArray:tempArray];
                [weakSelf.tableView reloadData];
                weakSelf.pageNo++;
                [autoFooter setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
            }else{
                [autoFooter setTitle:@"没有更多数据了.." forState:MJRefreshStateRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } andFailBlock:^(id failResult) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        }];
    }else{
        
        return ;
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - configUI方法

- (void)configUI
{
    [self setBackItem];
    
    CGRect tableViewRect = CGRectMake(0, 0, KSCREEN_W, KSCREEN_H - KNAV_HEIGHT - 5);
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake( 5, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    
    WEAKSELF
    //上啦加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //移除占位view
        [weakSelf loadNewData];
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
