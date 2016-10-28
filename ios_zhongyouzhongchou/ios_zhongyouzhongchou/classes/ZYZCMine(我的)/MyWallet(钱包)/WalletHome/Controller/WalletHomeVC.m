//
//  WalletHomeVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletHomeVC.h"
#import "WalletHeadView.h"
#import "WalletSelectToolBar.h"
#import "WalletKtxTableView.h"
#import "WalletYbjTableView.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "MineWalletModel.h"

static NSInteger pageSize = 2;
@interface WalletHomeVC ()

@property (nonatomic, strong) WalletHeadView *headView;

@property (nonatomic, strong) WalletSelectToolBar *selectToolBar;

@property (nonatomic, strong) WalletKtxTableView *ktxTableView;

@property (nonatomic, strong) WalletYbjTableView *ybjTableView;

/* 钱包当前选择页面 */
@property (nonatomic, assign) WalletSelectType selectType;

@property (nonatomic, assign) NSInteger ktxPageNo;
@property (nonatomic, assign) NSInteger ybjPageNo;
@end

@implementation WalletHomeVC

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
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setUpSubviews];
    
    [self setUpTouchUpAction];
    
    [self.ktxTableView.mj_header beginRefreshing];
    
//    [self loadNewKtxData];
}

/* 设置子视图 */
- (void)setUpSubviews
{
    
    [self setBackItem];
    
    //两个tableview
    _ktxTableView=[[WalletKtxTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _ktxTableView.contentInset=UIEdgeInsetsMake(WalletHeadViewH + WalletSelectToolBarH, 0, KTABBAR_HEIGHT, 0);
    _ktxTableView.contentOffset = CGPointMake(0,- (WalletHeadViewH + WalletSelectToolBarH));
    [self.view addSubview:_ktxTableView];
    
    _ybjTableView=[[WalletYbjTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _ybjTableView.contentInset=UIEdgeInsetsMake(WalletHeadViewH + WalletSelectToolBarH, 0, KTABBAR_HEIGHT, 0);
    _ybjTableView.contentOffset = CGPointMake(0,- (WalletHeadViewH + WalletSelectToolBarH));
    [self.view addSubview:_ybjTableView];
    _ybjTableView.hidden = YES;
    
    
    //头视图
    _headView = [[WalletHeadView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, WalletHeadViewH)];
    [self.view addSubview:_headView];
    
    //工具条
    _selectToolBar = (WalletSelectToolBar *)[[[NSBundle mainBundle] loadNibNamed:@"WalletSelectToolBar" owner:nil options:nil] lastObject];
    CGSize selectToolBarSize = (CGSize){ KSCREEN_W, WalletSelectToolBarH };
    _selectToolBar.frame = (CGRect){0, _headView.height, selectToolBarSize};
    [self.view addSubview:_selectToolBar];

}
#pragma mark - RequestData
- (void)loadNewKtxData
{
    _ktxPageNo = 1;
    __weak typeof(&*self) weakSelf = self;
    //    [MBProgressHUD showMessage:@"正在加载"];
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%zd&pageSize=%zd",Get_MyTxProducts_List,userId,_ktxPageNo,pageSize];
    
    [ZYZCHTTPTool getHttpDataByURL:txProducts_Url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        
        NSArray *tempArray = [MineWalletModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.ktxTableView.dataArr removeAllObjects];
            [weakSelf.ktxTableView.dataArr addObjectsFromArray:tempArray];
            [weakSelf.ktxTableView reloadData];
            weakSelf.ktxPageNo++;
        }else{
            
            
        }
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        
        //        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        
        //        [MBProgressHUD hideHUD];
        
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        
    }];
}

- (void)loadNewYbjData
{
    _ybjPageNo = 1;
    __weak typeof(&*self) weakSelf = self;
    //    [MBProgressHUD showMessage:@"正在加载"];
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%zd&pageSize=%zd",Get_MyTxProducts_List,userId,_ktxPageNo,pageSize];
    
    [ZYZCHTTPTool getHttpDataByURL:txProducts_Url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        
        NSArray *tempArray = [MineWalletModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.ktxTableView.dataArr removeAllObjects];
            [weakSelf.ktxTableView.dataArr addObjectsFromArray:tempArray];
            [weakSelf.ktxTableView reloadData];
            weakSelf.ktxPageNo++;
        }else{
            
            
        }
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        
        //        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        
        //        [MBProgressHUD hideHUD];
        
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        
    }];
}

- (void)loadMoreKtxData
{
    __weak typeof(&*self) weakSelf = self;
    //    [MBProgressHUD showMessage:@"正在加载"];
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%zd&pageSize=%zd",Get_MyTxProducts_List,userId,_ktxPageNo,pageSize];
    [ZYZCHTTPTool getHttpDataByURL:txProducts_Url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)weakSelf.ktxTableView.mj_footer ;
        
        NSArray *tempArray = [MineWalletModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.ktxTableView.dataArr addObjectsFromArray:tempArray];
            [weakSelf.ktxTableView reloadData];
            weakSelf.ktxPageNo++;
            [autoFooter setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
        }else{
            [autoFooter setTitle:@"没有更多数据了.." forState:MJRefreshStateRefreshing];
        }
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        
        //        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        
        //        [MBProgressHUD hideHUD];
        
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        
    }];

}

/* 设置手势动作 */
- (void)setUpTouchUpAction
{
    WEAKSELF
    
    //切换视图
    _selectToolBar.selectBlock = ^(WalletSelectType type){
        if (type == WalletSelectTypeKTX) {
            weakSelf.ktxTableView.hidden = NO;
            weakSelf.ybjTableView.hidden = YES;
        }else{
            weakSelf.ktxTableView.hidden = YES;
            weakSelf.ybjTableView.hidden = NO;
        }
        //然后请求数据
    };
    
    //ktxTableview
    _ktxTableView.headerRefreshingBlock = ^(){
        [weakSelf loadNewKtxData];
    };
    
    _ktxTableView.footerRefreshingBlock = ^(){
        [weakSelf loadMoreKtxData];
    };
    
    _ktxTableView.scrollDidScrollBlock=^(CGFloat offsetY)
    {
        [weakSelf productTableScrollDidScroll:offsetY];
    };
    
    _ktxTableView.scrollWillBeginDraggingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=NO;
    };
    
    _ktxTableView.scrollDidEndDeceleratingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=YES;
    };
    
    //ybjTableview
    _ybjTableView.headerRefreshingBlock = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.ybjTableView.mj_header endRefreshing];
        });
    };
    
    _ybjTableView.footerRefreshingBlock = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.ybjTableView.mj_footer endRefreshing];
        });
    };
    
    _ybjTableView.scrollDidScrollBlock=^(CGFloat offsetY)
    {
        [weakSelf productTableScrollDidScroll:offsetY];
    };
    
    _ybjTableView.scrollWillBeginDraggingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=NO;
    };
    
    _ybjTableView.scrollDidEndDeceleratingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=YES;
    };
}

#pragma mark - 项目的table滑动
-(void)productTableScrollDidScroll:(CGFloat) offsetY
{
//    DDLog(@"%f",offsetY);
    CGFloat TotalViewHeight = WalletHeadViewH + WalletSelectToolBarH;
    CGFloat min_offsetY= -WalletSelectToolBarH;//
    
    CGFloat show_Name_offsetY= -180;
    
    if (offsetY<=min_offsetY) {//当滑动到最小高度以下
        if (offsetY < - (TotalViewHeight)) {//如果滑动到TotalViewHeight以下
            _headView.top=0;
            _selectToolBar.top = WalletHeadViewH;
        } else {//如果滑动到TotalViewHeight以上
            _headView.top=-(offsetY + TotalViewHeight);
            _selectToolBar.top = _headView.bottom;
        }
//        if (_contentType==0) {
//            _headView.prosuctTableOffSetY=offsetY;
//        }
//        else
//        {
//            _headView.footprintTableOffSetY=offsetY;
//        }
        
    } else {//当滑动到最小高度以上
        _headView.top=-(min_offsetY + TotalViewHeight);
        _selectToolBar.top = 0;
//        if (_contentType==0) {
//            _headView.prosuctTableOffSetY=min_offsetY;
//        }
//        else
//        {
//            _headView.footprintTableOffSetY=min_offsetY;
//        }
    }
    
    if (offsetY > show_Name_offsetY) {
        NSString *name=@"王小二";
        self.title=name;
    } else {
        self.title=nil;
    }
    if (offsetY<=-(TotalViewHeight) + KEDGE_DISTANCE) {
    }
    else {
        _ybjTableView.bounces=YES;
        _ktxTableView.bounces=YES;
    }
}

@end
