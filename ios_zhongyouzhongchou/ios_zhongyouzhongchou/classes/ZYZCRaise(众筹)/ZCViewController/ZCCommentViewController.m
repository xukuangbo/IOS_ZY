//
//  ZCCommitViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCCommentViewController.h"
#import "ZCCommentCell.h"
#import "ZCCommentModel.h"
#import "AddCommentView.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "ComplainViewController.h"
@interface ZCCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) AddCommentView *addCommentView;
@property (nonatomic, strong) ZCCommentList *commentList;
@property (nonatomic, strong) NSMutableArray *commentArr;
@property (nonatomic, assign) int  pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) UIView         *noneDataView;
@end

@implementation ZCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _commentArr=[NSMutableArray array];
    _pageNo=1;
    _pageSize=10;
    [self setBackItem];
    [self configUI];
    [self getHttpData];
    
}

-(void)getHttpData
{
    NSDictionary *parameters=@{@"userId":[ZYZCAccountTool getUserId],
                               @"productId":_productId,
                               @"pageNo":[NSNumber numberWithInt:_pageNo],
                               @"pageSize":[NSNumber numberWithInt:_pageSize],
                               };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"comment_listZhongchouComment"];

    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            if (_pageNo==1&&_commentArr.count) {
                [_commentArr removeAllObjects];
            }
            _commentList=[[ZCCommentList alloc]mj_setKeyValues:result];
            for(ZCCommentModel *commentModel in _commentList.commentList)
            {
                [_commentArr addObject:commentModel];
            }
            if (!_commentList.commentList.count) {
                _pageNo--;
            }
            
            if (!_commentArr.count) {
                _noneDataView.hidden=NO;
            }
            else
            {
                _noneDataView.hidden=YES;
            }
                        
            [_table reloadData];
            [_table.mj_header endRefreshing];
            [_table.mj_footer endRefreshing];
        }
        else
        {
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.view];
//        NSLog(@"%@",failResult);
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpData];
        }];

    }];
}

-(void)configUI
{
    _table =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.dataSource=self;
    _table.delegate=self;
    _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _table.backgroundColor = [UIColor ZYZC_BgGrayColor];
//    _table.backgroundColor=[UIColor orangeColor]; 
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    _table.contentInset=UIEdgeInsetsMake(64, 0, 5, 0) ;
    [self.view addSubview:_table];
    
    __weak typeof (&*self )weakSelf=self;
    MJRefreshNormalHeader *normarlHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo=1;
        [weakSelf getHttpData];
    }];
    normarlHeader.lastUpdatedTimeLabel.hidden=YES;
    _table.mj_header=normarlHeader;
    

    MJRefreshAutoNormalFooter *autoFooter=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNo++;
        [weakSelf getHttpData];
    }];
    [autoFooter setTitle:@"" forState:MJRefreshStateIdle];
    _table.mj_footer=autoFooter;
    
    [self createNoneDataView];
    
    //添加评论
    _addCommentView=[[AddCommentView alloc]init];
    _addCommentView.top=KSCREEN_H-_addCommentView.height;
    [self.view addSubview:_addCommentView];
    
    _addCommentView.commitComment=^(NSString *content)
    {
        [weakSelf commitCommentWithContent:content];
    };
    
    //投诉
    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame=CGRectMake(0, 0, 50, 44);
    //    [_navRightBtn setTitle:_hasComplain?@"已投诉":@"投诉" forState:UIControlStateNormal];
    [navRightBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(complain) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:navRightBtn];

}

#pragma mark --- 提交评论
-(void)commitCommentWithContent:(NSString *)content
{
    NSDictionary *parameters= @{
                                @"userId":[ZYZCAccountTool getUserId],
                                @"productId":self.productId,
                                @"content":content
                                };
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"comment_addZhongchouComment"];

    WEAKSELF;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_success")];
            if (weakSelf.addCommentView.commentSuccess) {
                weakSelf.addCommentView.commentSuccess();
            }
             weakSelf.addCommentView.top=KSCREEN_H-weakSelf.addCommentView.height;
            weakSelf.pageNo=1;
            [weakSelf getHttpData];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_fail")];
        }
        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
    }];
}

#pragma mark --- 进入投诉页面
-(void)complain
{
    ComplainViewController *complainContriller=[[ComplainViewController alloc]init];
    complainContriller.productId=_productId;
    complainContriller.type=@3;
    complainContriller.role=@3;
    [self.navigationController pushViewController:complainContriller animated:YES];
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView==_table)
    {
        [_addCommentView textFieldRegisterFirstResponse];
    }
}

    

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId=@"commentCell";
    ZCCommentCell *commentCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!commentCell) {
        commentCell=[[ZCCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    commentCell.commentModel=_commentArr[indexPath.row];
    return commentCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCCommentModel *commentModel=_commentArr[indexPath.row];
    return commentModel.cellHeight;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_addCommentView textFieldRegisterFirstResponse];
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
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
