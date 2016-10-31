//
//  ZYZCMessageListViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCMessageListViewController.h"
#import "MsgListTableView.h"
#import "MsgListModel.h"
#import "NetWorkManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
@interface ZYZCMessageListViewController ()
@property (nonatomic, assign) int pageNo;
@property (nonatomic, strong) MsgListTableView *table;
@property (nonatomic, strong) NSMutableArray   *listArr;
@property (nonatomic, strong) UIView           *noneDataView;
@end

@implementation ZYZCMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageNo=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    _listArr = [NSMutableArray array];
    [self configUI];
    [self getHttpData];

}

#pragma mark --- 创建控件
-(void)configUI
{
    //创建table
    _table=[[MsgListTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.top=64;
    _table.height=KSCREEN_H-64;
    [self.view addSubview:_table];
    __weak typeof (&*self)weakSelf=self;
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
    
    [self createNoneDataView];
}

#pragma mark --- 创建空界面
-(void)createNoneDataView
{
    _noneDataView=[[UIView alloc]initWithFrame:self.view.bounds];
    _noneDataView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_noneDataView];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 64+40, _noneDataView.width-2*KEDGE_DISTANCE, 20)];
    lab.text=@"暂时没有任何数据～";
    lab.textColor=[UIColor ZYZC_TextBlackColor];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textAlignment=NSTextAlignmentCenter;
    [_noneDataView addSubview:lab];
    _noneDataView.hidden=YES;
}


#pragma mark --- 获取数据
-(void)getHttpData
{
//    DDLog(@"%@",Post_List_Msg);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"systemMsg_getMsgList"] andParameters:@{@"userId":[ZYZCAccountTool getUserId],
                        @"pageNo":[NSNumber numberWithInt:_pageNo]}
    andSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        DDLog(@"%@",result);
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        
        MsgDataModel *dataModel=[[MsgDataModel alloc]mj_setKeyValues:result];
        
        if (_pageNo==1&&_listArr.count) {
            [_listArr removeAllObjects];
        }
        
        if (dataModel.data.count==0) {
            _pageNo--;
        }

        for(MsgListModel *msgModel in dataModel.data)
        {
            [_listArr addObject:msgModel];
        }
        
        _table.dataArr = _listArr;
        
        if (!_listArr.count) {
            _noneDataView.hidden=NO;
        }
        else
        {
            _noneDataView.hidden=YES;
        }
        
        [_table reloadData];
    }
    andFailBlock:^(id failResult)
    {
        DDLog(@"%@",failResult);
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpData];
        }];

    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor ZYZC_TextBlackColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:@"back_black" andAction:@selector(pressBack)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title=@"通知";
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:@"back_black" andAction:@selector(pressBack)];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];
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
