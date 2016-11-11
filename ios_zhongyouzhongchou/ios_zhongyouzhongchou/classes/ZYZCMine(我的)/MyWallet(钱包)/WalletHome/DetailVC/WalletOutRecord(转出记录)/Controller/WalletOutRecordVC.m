//
//  WalletOutRecordVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletOutRecordVC.h"
#import "MBProgressHUD+MJ.h"
#import "RACEXTScope.h"
#import "WalletOutRecordCell.h"
#import "WalletOutRecordModel.h"

@interface WalletOutRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  可提现列表
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageNo;

@end

static NSString *cellId = @"WalletOutRecordCell";
int pageSize = 10;
@implementation WalletOutRecordVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackItem];
    
    self.title=@"转出记录";
    self.hidesBottomBarWhenPushed = YES;
    self.pageNo = 1;
    self.dataArray = [NSMutableArray array];
    //刷新ui
    [self configUI];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [_tableView registerNib:[UINib nibWithNibName:@"WalletOutRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId];
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


#pragma mark - network
- (void)loadNewData
{
    _pageNo = 1;
    NSString *url;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    url = [[ZYZCAPIGenerate sharedInstance] API:@"wallet_transfersOrderList.action"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"pageNo"];
    [parameter setValue:@(pageSize) forKey:@"pageSize"];
    WEAKSELF
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSArray *tempArray = [WalletOutRecordModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:tempArray];
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
    
}

- (void)loadMoreData
{
    NSString *url;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    url = [[ZYZCAPIGenerate sharedInstance] API:@"wallet_transfersOrderList.action"];
    [parameter setValue:@"fause" forKey:@"cache"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"pageNo"];
    [parameter setValue:@(pageSize) forKey:@"pageSize"];
    
    WEAKSELF
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)weakSelf.tableView.mj_footer ;
        NSArray *tempArray = [WalletOutRecordModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.dataArray addObjectsFromArray:tempArray];
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
}

#pragma mark - 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count == 0) {
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletOutRecordCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletOutRecordCell" owner:nil options:nil] lastObject];
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)pressBack
{
    [super pressBack];
    
    
}
@end
