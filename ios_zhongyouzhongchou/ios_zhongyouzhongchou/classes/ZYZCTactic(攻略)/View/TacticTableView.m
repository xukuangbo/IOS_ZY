//
//  TacticTableView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticTableView.h"
#import "SDCycleScrollView.h"
#import "TacticMainViewController.h"
#import "TacticModel.h"
#import "MJExtension.h"
#import "TacticCustomMapView.h"
#import "TacticIndexImgModel.h"
#import "ZCWebViewController.h"
#import "TacticTableViewCell.h"
#import "NetWorkManager.h"
@interface TacticTableView ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *headURLArray;

@end

@implementation TacticTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor ZYZC_BgGrayColor];
        self.separatorColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator=NO;
        self.dataSource = self;
        self.delegate = self;
        
        //这里要集成下拉刷新还有
        __weak typeof(&*self) weakSelf = self;
        self.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf reloadRefreshData];
            
            [weakSelf reloadData];
            [weakSelf.mj_header endRefreshing];
        }];
        
        [self.mj_header beginRefreshing];
    }
    return self;
}
/**
 *  下拉刷新数据
 */
- (void)reloadRefreshData
{
    NSString *url = GET_TACTIC;
    //访问网络
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [NetWorkManager hideFailViewForView:weakSelf.viewController.view];
        if (isSuccess) {
            //请求成功，转化为数组
            TacticModel *tacticModel = [TacticModel mj_objectWithKeyValues:result[@"data"]];
            weakSelf.tacticModel = tacticModel;
            
            [weakSelf reloadData];
        }
        
    } andFailBlock:^(id failResult) {
        [NetWorkManager hideFailViewForView:weakSelf.viewController.view];
//        NSLog(@"%@",failResult);
        
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager showMBWithFailResult:failResult];
        [NetWorkManager getFailViewForView:weakSelf.viewController.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf reloadRefreshData];
        }];
    }];
    
}

#pragma mark - UITableDelegate和Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        NSString *ID = @"TacticTableViewCell";
        TacticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[TacticTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.tacticModel = _tacticModel;
        
        return cell;
    }
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *headView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, KSCREEN_W, (KSCREEN_W / 16.0 * 10)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //添加渐变条
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    bgImg.image=[UIImage imageNamed:@"Background"];
    [headView addSubview:bgImg];
    
    headView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    headView.pageDotColor = [UIColor whiteColor];
    headView.autoScrollTimeInterval = 5;
    headView.currentPageDotColor = [UIColor ZYZC_MainColor]; // 自定义分页控件小圆标颜色
    
    if (self.tacticModel.indexImg) {
        NSMutableArray *headImgArray = [NSMutableArray array];
//        NSMutableArray *headTitleArray = [NSMutableArray array];
        NSMutableArray *headURLArray = [NSMutableArray array];
        for (TacticIndexImgModel *indexImgModel in self.tacticModel.indexImg) {
            if (indexImgModel.status == 0) {//有效
                NSString *headImgString = [NSString stringWithFormat:@"%@%@",BASE_URL,indexImgModel.proImg];
                [headImgArray addObject:headImgString];
//                [headTitleArray addObject:indexImgModel.title];
                [headURLArray addObject:indexImgModel.proUrl];
            }else{
                
            }
        }
        self.headURLArray = headURLArray;
        headView.imageURLStringsGroup = headImgArray;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *image = [UIImage imageNamed:@"招商银行广告"];
    CGFloat imageHeight = (KSCREEN_W - 2 * KEDGE_DISTANCE) * image.size.height / image.size.width;
    return (threeViewMapHeight + sixViewMapHeight + sixViewMapHeight) +imageHeight + KEDGE_DISTANCE * 6;
}
/**
 *  navi背景色渐变的效果
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    TacticMainViewController *homeVC = (TacticMainViewController *)self.viewController;
    if (offsetY <= headViewHeight) {
        CGFloat alpha = MAX(0, offsetY/headViewHeight);
        
        [homeVC.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(alpha)];
    }else {
        
        [homeVC.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(1)];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"---点击了第%ld张图片", (long)index);
    
    ZCWebViewController *webVC = [[ZCWebViewController alloc] init];
    webVC.myTitle = @"最新活动";
    webVC.requestUrl = self.headURLArray[index];
    [self.viewController presentViewController:webVC animated:YES completion:nil];
}


- (void)changeNaviAction{
    [self scrollViewDidScroll:self];
}
@end
