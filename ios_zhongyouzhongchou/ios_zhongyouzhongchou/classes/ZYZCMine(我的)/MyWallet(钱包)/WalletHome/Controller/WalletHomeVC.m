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
#import "WalletYbjModel.h"
#import "WalletYbjCell.h"
#import "WalletYbjBottomBar.h"
#import "WalletHeadModel.h"
#import "FXBlurView.h"
#import "WalletUserYbjVC.h"
#import <ReactiveCocoa.h>
static NSInteger KtxPageSize = 10;
static NSInteger YbjPageSize = 10;
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

#pragma mark - System Func
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
    
    [self addNotis];
    
    [self setUpSubviews];
    
    [self setUpTouchUpAction];
    
    [self loadHeadViewData];
    [self.ktxTableView.mj_header beginRefreshing];
    [self.ybjTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)dealloc
{
    [ZYNSNotificationCenter removeObserver:self];
    
    DDLog(@"%@被移除了",[self class]);
}

#pragma mark - Noti
- (void)addNotis{
    
    //使用预备金成功
    @weakify(self);
    [[ZYNSNotificationCenter rac_addObserverForName:WalletUseYbjSuccessNoti object:nil] subscribeNext:^(NSNotification *noti) {
        @strongify(self);
        [self.ybjTableView scrollsToTop];
        [self.ybjTableView.mj_header beginRefreshing];
    }];
    
    //使用预备金失败
    [[ZYNSNotificationCenter rac_addObserverForName:WalletUseYbjFailNoti object:nil] subscribeNext:^(NSNotification *noti) {
        @strongify(self);
        [self.ybjTableView scrollsToTop];
        [self.ybjTableView.mj_header beginRefreshing];
    }];
}

#pragma mark - SetUp UI
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
    
    //预备金底部视图
    _ybjBottomBar = [[WalletYbjBottomBar alloc] init];
    _ybjBottomBar.frame = CGRectMake(0, KSCREEN_H - WalletYbjBottomBarH - KNAV_HEIGHT, KSCREEN_W, WalletYbjBottomBarH);
    _ybjBottomBar.hidden = YES;
    [self.view addSubview:_ybjBottomBar];
    
}

#pragma mark - RequestData
- (void)loadHeadViewData
{
    //    wallet_getMyWallet.action
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"wallet_getMyWallet.action"];
    NSString *userId = [ZYZCAccountTool getUserId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:userId forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
//        data =     {
//            cash = 10100;
//            uCash = 100;
//        };
        WalletHeadModel *model = [WalletHeadModel mj_objectWithKeyValues:result[@"data"]];
        weakSelf.headView.model = model;
    } andFailBlock:^(id failResult) {
        
    }];

}

- (void)loadNewKtxData
{
    _ktxPageNo = 1;
    NSString *userId = [ZYZCAccountTool getUserId];
//    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%zd&pageSize=%zd",Get_MyTxProducts_List,userId,_ktxPageNo,KtxPageSize];
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"list_listMyTxProducts"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"fause" forKey:@"cache"];
    [parameter setValue:userId forKey:@"userId"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", _ktxPageNo] forKey:@"pageNo"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", KtxPageSize] forKey:@"pageSize"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
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
    } andFailBlock:^(id failResult) {
        [weakSelf.ktxTableView.mj_header endRefreshing];
        [weakSelf.ktxTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
    }];
}

- (void)loadMoreKtxData
{
    NSString *userId = [ZYZCAccountTool getUserId];
//    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%zd&pageSize=%zd",Get_MyTxProducts_List,userId,_ktxPageNo,KtxPageSize];
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"list_listMyTxProducts"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"fause" forKey:@"cache"];
    [parameter setValue:userId forKey:@"userId"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", _ktxPageNo] forKey:@"pageNo"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", KtxPageSize] forKey:@"pageSize"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
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
    } andFailBlock:^(id failResult) {
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
    NSString *ybjProducts_Url = [[ZYZCAPIGenerate sharedInstance] API:@"zhibo_reserveListJson"];
    //    NSString *userId = [ZYZCAccountTool getUserId];
    NSDictionary *parameters = @{
                                 @"pageNo" : @(_ybjPageNo),
                                 @"pageSize" : @(YbjPageSize)
                                 };
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:ybjProducts_Url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSArray *tempArray = [WalletYbjModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.ybjTableView.dataArr removeAllObjects];
            [weakSelf.ybjTableView.dataArr addObjectsFromArray:tempArray];
            [weakSelf.ybjTableView reloadData];
            weakSelf.ybjPageNo++;
            
            [weakSelf.ybjBottomBar clearData];
        }else{
            
            
        }
        [weakSelf.ybjTableView.mj_header endRefreshing];
        [weakSelf.ybjTableView.mj_footer endRefreshing];
        
        //        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        //        [MBProgressHUD hideHUD];
        
        [weakSelf.ybjTableView.mj_header endRefreshing];
        [weakSelf.ybjTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
    }];
    
}

- (void)loadMoreYbjData
{
//    _ybjPageNo = 1;
    __weak typeof(&*self) weakSelf = self;
    //    [MBProgressHUD showMessage:@"正在加载"];
    NSString *txProducts_Url = [[ZYZCAPIGenerate sharedInstance] API:@"zhibo_reserveListJson"];
    //    NSString *userId = [ZYZCAccountTool getUserId];
    NSDictionary *parameters = @{
                                 @"pageNo" : @(_ybjPageNo),
                                 @"pageSize" : @(YbjPageSize)
                                 };
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:txProducts_Url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)weakSelf.ybjTableView.mj_footer;
        
        NSArray *tempArray = [WalletYbjModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (tempArray.count > 0) {
            [weakSelf.ybjTableView.dataArr addObjectsFromArray:tempArray];
            [weakSelf.ybjTableView reloadData];
            weakSelf.ybjPageNo++;
            [autoFooter setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
        }else{
            [autoFooter setTitle:@"没有更多数据了.." forState:MJRefreshStateRefreshing];
        }
        [weakSelf.ybjTableView.mj_header endRefreshing];
        [weakSelf.ybjTableView.mj_footer endRefreshing];
        
        //        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        
        //        [MBProgressHUD hideHUD];
        
        [weakSelf.ybjTableView.mj_header endRefreshing];
        [weakSelf.ybjTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        
    }];
    
}
#pragma mark - ClickAction
/* 设置手势动作 */
- (void)setUpTouchUpAction
{
    WEAKSELF
    
    //切换视图
    _selectToolBar.selectBlock = ^(WalletSelectType type){
        if (type == WalletSelectTypeKTX) {
            weakSelf.ktxTableView.hidden = NO;
            weakSelf.ybjTableView.hidden = weakSelf.ybjBottomBar.hidden = YES;
        }else{
            weakSelf.ktxTableView.hidden = YES;
            weakSelf.ybjTableView.hidden = weakSelf.ybjBottomBar.hidden = NO;
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
        weakSelf.selectToolBar.userInteractionEnabled = NO;
    };
    
    _ktxTableView.scrollDidEndDeceleratingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=YES;
        weakSelf.selectToolBar.userInteractionEnabled = YES;
    };
    
    //ybjTableview
    _ybjTableView.headerRefreshingBlock = ^(){
        
        [weakSelf loadNewYbjData];
    };
    
    _ybjTableView.footerRefreshingBlock = ^(){
        
        [weakSelf loadMoreYbjData];
    };
    
    _ybjTableView.scrollDidScrollBlock=^(CGFloat offsetY)
    {
        [weakSelf productTableScrollDidScroll:offsetY];
    };
    
    _ybjTableView.scrollWillBeginDraggingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=NO;
        weakSelf.selectToolBar.userInteractionEnabled = NO;
    };
    
    _ybjTableView.scrollDidEndDeceleratingBlock=^()
    {
        weakSelf.headView.userInteractionEnabled=YES;
        weakSelf.selectToolBar.userInteractionEnabled = YES;
    };
    
    _ybjBottomBar.walletYbjBottomBarSelectBlock = ^(){
        WalletUserYbjVC *userYbjVC = [[WalletUserYbjVC alloc] init];
        userYbjVC.dic = weakSelf.ybjTableView.selectDic;
        [weakSelf.navigationController pushViewController:userYbjVC animated:YES];
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
