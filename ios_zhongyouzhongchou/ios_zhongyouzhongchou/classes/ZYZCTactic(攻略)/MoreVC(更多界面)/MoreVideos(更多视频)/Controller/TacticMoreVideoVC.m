//
//  TacticMoreVideoVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMoreVideoVC.h"
#import "TacticMoreVideoCell.h"
#import "TacticVideoModel.h"
#import "ZCWebViewController.h"
#import "ZYZCPlayViewController.h"
@interface TacticMoreVideoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *moreVideosModelArray;
@end

@implementation TacticMoreVideoVC
#pragma mark - system方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
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
    [self setBackItem];
    self.title = @"视频攻略";
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - requsetData方法
- (void)requestData
{
//    NSString *url = GET_TACTIC_More_Videos;
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"adminback_getViewVideoList"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"2" forKey:@"viewType"];

    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功，转化为数组
            weakSelf.moreVideosModelArray = [TacticVideoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [weakSelf.tableView reloadData];
        }
    } andFailBlock:^(id failResult) {
        
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


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TacticVideoModel *model = self.moreVideosModelArray[(indexPath.row - 1) / 2];
//    NSRange range=[model.videoUrl rangeOfString:@".html"];
//    if (range.length) {//网页
//        ZCWebViewController *webController=[[ZCWebViewController alloc]init];
//        webController.requestUrl=model.videoUrl;
//        webController.myTitle=@"视频播放";
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webController animated:YES completion:nil];
//        return;
//    }
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {//视频
//        ZYZCPlayViewController *playVC = [[ZYZCPlayViewController alloc] init];
//        playVC.urlString = model.videoUrl;
//        [self presentViewController:playVC animated:YES completion:nil];
//        return;
//    }
//}

@end
