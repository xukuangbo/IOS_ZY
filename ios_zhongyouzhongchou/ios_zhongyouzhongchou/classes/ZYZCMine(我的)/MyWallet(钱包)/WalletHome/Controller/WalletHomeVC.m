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
@interface WalletHomeVC ()

@property (nonatomic, strong) WalletHeadView *headView;

@property (nonatomic, strong) WalletSelectToolBar *selectToolBar;

@property (nonatomic, strong) WalletKtxTableView *ktxTableView;

@property (nonatomic, strong) WalletYbjTableView *ybjTableView;
@end

@implementation WalletHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setUpSubviews];
    
    [self setUpTouchUpAction];
    
    [self requestProductList];
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
#pragma mark - network
- (void)requestProductList
{
    __weak typeof(&*self) weakSelf = self;
//    [MBProgressHUD showMessage:@"正在加载"];
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%d&pageSize=%d",Get_MyTxProducts_List,userId,1,10000];
    
    [ZYZCHTTPTool getHttpDataByURL:txProducts_Url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        weakSelf.ktxTableView.dataArr = [MineWalletModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        [weakSelf.ktxTableView reloadData];
        
//        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        
//        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
        
    }];
}

/* 设置点击动作 */
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.ktxTableView.mj_header endRefreshing];
        });
    };
    
    _ktxTableView.footerRefreshingBlock = ^(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.ktxTableView.mj_footer endRefreshing];
        });
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
}

#pragma mark --- 项目的table滑动
-(void)productTableScrollDidScroll:(CGFloat) offsetY
{
    DDLog(@"%f",offsetY);
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
