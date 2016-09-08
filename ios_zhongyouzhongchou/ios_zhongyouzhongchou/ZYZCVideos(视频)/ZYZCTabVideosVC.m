//
//  TacticMoreVideoVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCTabVideosVC.h"
#import "TacticMoreVideoCell.h"
#import "TacticVideoModel.h"
#import "ZCWebViewController.h"
#import "ZYZCPlayViewController.h"
#import "NetWorkManager.h"
#import "MBProgressHUD+MJ.h"
@interface ZYZCTabVideosVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *moreVideosModelArray;
@end

@implementation ZYZCTabVideosVC
#pragma mark - system方法
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self requestData];
    
}

#pragma mark - setUI方法
- (void)configUI
{
//    [self setBackItem];
    self.title = @"视频";
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H - 49) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    __weak typeof(&*self) weakSelf = self;
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
        
    }];
    [self.view addSubview:_tableView];
}
#pragma mark - requsetData方法
- (void)requestData
{
    NSString *url = GET_Tab_Videos;
    NSLog(@"%@",url);
    //访问网络
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            
            //请求成功，转化为数组
            weakSelf.moreVideosModelArray = [TacticVideoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [weakSelf.tableView reloadData];
            
        }
        [MBProgressHUD hideHUD];
        [NetWorkManager hideFailViewForView:self.view];
        [weakSelf.tableView.mj_header endRefreshing];
    } andFailBlock:^(id failResult) {
        NSLog(@"%@",failResult);
        [MBProgressHUD hideHUD];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        [NetWorkManager getFailViewForView:self.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf requestData];
        }];
        
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - set方法

#pragma mark - button点击方法

#pragma mark - delegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_moreVideosModelArray.count * 2 + 1);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        UITableViewCell *cell = [TacticMoreVideoCell createNormalCell];
        
        return cell;
    }else{
        static NSString *const ID = @"TacticMoreVideoCell";
        
        TacticMoreVideoCell *cell = (TacticMoreVideoCell *)[TacticMoreVideoCell customTableView:tableView cellWithIdentifier:ID andCellClass:[TacticMoreVideoCell class]];
        //        cell.backgroundColor = [UIColor redColor];
        cell.tacticVideoModel = self.moreVideosModelArray[(indexPath.row - 1) / 2];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return KEDGE_DISTANCE;
    }else{
        return TacticMoreVideoRowHeight;
    }
}



@end
