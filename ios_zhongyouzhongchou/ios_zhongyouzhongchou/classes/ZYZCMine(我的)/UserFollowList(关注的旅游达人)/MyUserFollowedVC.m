//
//  MyUserFollowedVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#import "MyUserFollowedVC.h"
#import "ZYZCAccountModel.h"
#import "ZYZCAccountTool.h"
#import "MyUserFollowedModel.h"
#import "MyUserFollowedCell.h"
#import "ZYUserZoneController.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "EntryPlaceholderView.h"
@interface MyUserFollowedVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *userFollowedArray;

@property (nonatomic, weak) UITableView *tableView;

@end


@implementation MyUserFollowedVC
#pragma mark - system方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackItem];
//        self.title = @"我关注的旅行达人";
        self.hidesBottomBarWhenPushed = YES;
        [self configUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
    
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"我关注的旅行达人";
    
    [self setBackItem];
}

#pragma mark - setUI方法
- (void)configUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = MyUserFollowedCellHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark - requsetData方法
- (void)requestData
{
    
    NSString *url = Get_UserFollowed_List([ZYZCAccountTool getUserId]);
//    NSLog(@"%@",url);
    //访问网络
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        [NetWorkManager hideFailViewForView:self.view];
        if (isSuccess) {
            //请求成功，转化为数组
            weakSelf.userFollowedArray = [MyUserFollowedModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            
            
            if (weakSelf.userFollowedArray.count <= 0) {//没有数据，就显示占位图
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [EntryPlaceholderView viewWithSuperView:weakSelf.view type:EntryTypeGuanzhuDaren];
//                });
            }else{//如果有数据，就刷新
                [weakSelf.tableView reloadData];
            }
        }
        [MBProgressHUD hideHUD];
        
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        [MBProgressHUD hideHUD];
        
        [NetWorkManager showMBWithFailResult:failResult];
        [NetWorkManager hideFailViewForView:self.view];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf requestData];
        }];
    }];
}
#pragma mark - set方法

#pragma mark - delegate方法
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userFollowedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MineMessageCell";
    MyUserFollowedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyUserFollowedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.userFollowModel = self.userFollowedArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyUserFollowedModel *followedModel = _userFollowedArray[indexPath.row];
    
    ZYUserZoneController *userZoneController=[[ZYUserZoneController alloc]init];
    userZoneController.hidesBottomBarWhenPushed=YES;
    userZoneController.friendID=[NSNumber numberWithInteger:followedModel.userId];
    [self.navigationController pushViewController:userZoneController animated:YES];
}
@end
