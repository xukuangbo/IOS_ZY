//
//  MyReturnViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//
//我的回报
#define GET_MY_RETURN_LIST(userId,pageNo) [NSString stringWithFormat:@"cache=false&userId=%@&self=4&pageNo=%d&status_not=0&pageSize=10",userId,pageNo]
//我的草稿
#define GET_MY_DRAFT_LIST(userId,pageNo) [NSString stringWithFormat:@"cache=false&userId=%@&self=1&pageNo=%d&status=0&pageSize=10",userId,pageNo]

#import "MyReturnViewController.h"
#import "MyReturnTableView.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "EntryPlaceholderView.h"
@interface MyReturnViewController ()
@property (nonatomic, strong) MyReturnTableView *table;
@property (nonatomic, strong) UIButton           *scrollTop;
@property (nonatomic, strong) NSMutableArray     *listArr;
@property (nonatomic, strong) ZCListModel        *listModel;
@property (nonatomic, assign) int                pageNo;
@property (nonatomic, assign) BOOL               hasEnterView;

@end

@implementation MyReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"%ld",_productType);
    self.automaticallyAdjustsScrollViewInsets=NO;
//    if (_productType==MyReturnProduct) {
//        self.title=@"我的回报";
//    }
//    else if (_productType==MyDraftProduct)
//    {
//        self.title=@"我的草稿";
//    }
    _pageNo=1;
    _listArr=[NSMutableArray array];
    [self setBackItem];
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_productType==MyReturnProduct) {
        self.title=@"我的回报";
    }
    else if (_productType==MyDraftProduct)
    {
        self.title=@"我的草稿";
    }
    [self setBackItem];
}

-(void)configUI
{
    //创建table
    _table=[[MyReturnTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_table];
//    _table.backgroundColor= [UIColor orangeColor];
     __weak typeof (&*self)weakSelf=self;
    if (_productType==MyReturnProduct) {
       
        _table.headerRefreshingBlock=^()
        {
            weakSelf.pageNo=1;
            [weakSelf getHttpData];
        };
        _table.footerRefreshingBlock=^()
        {
            weakSelf.pageNo++;
            [weakSelf getHttpData];
        };
    }
    else
    {
        _table.contentInset=UIEdgeInsetsMake(64, 0, 44, 0) ;
        _table.mj_header=nil;
        _table.mj_footer=nil;
    }
    
    _table.scrollDidScrollBlock=^(CGFloat offSetY)
    {
        if (offSetY>=1000.0) {
            weakSelf.scrollTop.hidden=NO;
        }
        else
        {
            weakSelf.scrollTop.hidden=YES;
        }
    };
    
    //添加置顶按钮
    _scrollTop=[UIButton buttonWithType:UIButtonTypeCustom];
    _scrollTop.layer.cornerRadius=KCORNERRADIUS;
    _scrollTop.layer.masksToBounds=YES;
    _scrollTop.frame=CGRectMake(KSCREEN_W-60,KSCREEN_H-60,50,50);
    [_scrollTop setImage:[UIImage imageNamed:@"回到顶部"] forState:UIControlStateNormal];
    [_scrollTop addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    _scrollTop.hidden=YES;
    [self.view addSubview:_scrollTop];
}

#pragma mark --- 置顶
-(void)scrollToTop
{
    [_table setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark --- 获取我的回报众筹列表
-(void)getHttpData
{
    NSString *httpUrl=nil;
    if(_productType==MyReturnProduct)
    {
        httpUrl=[NSString stringWithFormat:@"%@%@",LISTMYPRODUCTS,GET_MY_RETURN_LIST([ZYZCAccountTool getUserId],_pageNo)];
    }
    else if(_productType ==MyDraftProduct)
    {
        httpUrl=[NSString stringWithFormat:@"%@%@",LISTMYPRODUCTS,GET_MY_DRAFT_LIST([ZYZCAccountTool getUserId],_pageNo)];
    }
    
     _table.productType=_productType;
    
//    NSLog(@"_table.productType:%ld",_table.productType);
    
//    NSLog(@"httpUrl%@",httpUrl);
    if (!_hasEnterView) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hasEnterView=YES;
    }
    [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [EntryPlaceholderView hidePlaceholderForView:self.view];
        if (isSuccess) {
            if (_pageNo==1&&_listArr.count) {
                [_listArr removeAllObjects];
            }
            _listModel=[[ZCListModel alloc]mj_setKeyValues:result];
            for(ZCOneModel *oneModel in _listModel.data)
            {
                [_listArr addObject:oneModel];
            }
            if (!_listModel.data.count) {
                _pageNo--;
            }
            //没有数据，展示数据为空界面提示
            if (!_listArr.count) {
                _table.mj_header=nil;
                _table.mj_footer=nil;
                if (_productType==MyReturnProduct) {
                    [EntryPlaceholderView viewWithSuperView:self.view type:EntryTypeHuibao];
                }
                else if (_productType==MyDraftProduct)
                {
                    [EntryPlaceholderView viewWithSuperView:self.view type:EntryTypeCaogao];
                }
            }
            else
            {
                [EntryPlaceholderView hidePlaceholderForView:self.view];
            }
            
            _table.dataArr=_listArr;
            [_table reloadData];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        
    } andFailBlock:^(id failResult) {
       [MBProgressHUD hideHUDForView:self.view];
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [EntryPlaceholderView hidePlaceholderForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpData];
        }];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [_segmentedView removeFromSuperview];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    if (self.productType==MyDraftProduct) {
         [self getHttpData];
    }
    else
    {
        if (!_hasEnterView) {
            [self getHttpData];
        }
    }
}

#pragma mark --- 删除某个草稿项目
-(void)deleteProductFromProductId:(NSNumber *)productId
{
    for (ZCOneModel *oneModel in _listArr) {
        if ([productId isEqual:oneModel.product.productId]) {
            [_listArr removeObject:oneModel];
            _table.dataArr=_listArr;
            [_table reloadData];
            if (!_listArr.count) {
                [EntryPlaceholderView viewWithSuperView:self.view type:EntryTypeCaogao];
            }
            break;
        }
    }
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
    [ZYNSNotificationCenter removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
