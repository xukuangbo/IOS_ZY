//
//  ZYFootprintListController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintListController.h"
#import "ZYFootprintListView.h"
#import "MBProgressHUD+MJ.h"
@interface ZYFootprintListController ()
@property (nonatomic, strong) ZYFootprintListView *footprintListView;
@property (nonatomic, assign) NSInteger           pageNo;
@property (nonatomic, strong) NSMutableArray     *listArr;
@end

@implementation ZYFootprintListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _listArr=[NSMutableArray array];
    _pageNo=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setBackItem];
    [self configUI];
    [self getHttpData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishFootprintSuccess:) name:PUBLISH_FOOTPRINT_SUCCESS  object:nil];
}

-(void)configUI
{
    _footprintListView=[[ZYFootprintListView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain andFootprintListType:MyFootprintList];

    WEAKSELF;
    _footprintListView.headerRefreshingBlock=^()
    {
        weakSelf.pageNo=1;
        [weakSelf getHttpData];
    };
    
    _footprintListView.footerRefreshingBlock=^()
    {
        weakSelf.pageNo++;
        [weakSelf getHttpData];
    };
    
    [self.view addSubview:_footprintListView];

}

-(void)getHttpData
{
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_getPageList"] andParameters:@{@"pageNo"  :[NSNumber numberWithInteger:_pageNo],
                        @"targetId":[ZYZCAccountTool getUserId]
                        } andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        [MBProgressHUD hideHUD];
        if (isSuccess) {
            MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_footprintListView.mj_footer ;
            if (_pageNo==1&&_listArr.count) {
                [_listArr removeAllObjects];
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            ZYFootprintDataModel  *listModel=[[ZYFootprintDataModel alloc]mj_setKeyValues:result];
        
            for(ZYFootprintListModel *oneModel in listModel.data)
            {
                [_listArr addObject:oneModel];
            }
            
            if (listModel.data.count==0) {
                _pageNo--;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
            }
            else
            {
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            _footprintListView.dataArr=_listArr;
            
            [_footprintListView reloadData];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        [_footprintListView.mj_header endRefreshing];
        [_footprintListView.mj_footer endRefreshing];
        
        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUD];
        [_footprintListView.mj_header endRefreshing];
        [_footprintListView.mj_footer endRefreshing];
    }];
}

-(void)publishFootprintSuccess:(NSNotification *)notify
{
    _pageNo=1;
    [self getHttpData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_footprintListView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
