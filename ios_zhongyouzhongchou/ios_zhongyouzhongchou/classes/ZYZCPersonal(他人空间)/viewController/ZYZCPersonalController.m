//
//  ZYZCPersonalController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//我的众筹列表
#define GET_MY_LIST(userId,type,pageNo) [NSString stringWithFormat:@"cache=false&userId=%@&self=%ld&pageNo=%d&status_not=0,2&pageSize=10",userId,type,pageNo]

#import "ZYZCPersonalController.h"
#import "PersonHeadView.h"
#import "ZCListModel.h"
#import "ZYZCOneProductCell.h"
#import "ZCProductDetailController.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
@interface ZYZCPersonalController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView       *table;
@property (nonatomic, strong) PersonHeadView    *headView;
@property (nonatomic, strong) UserModel         *userModel;
@property (nonatomic, strong) NSMutableArray    *productArr;
@property (nonatomic, assign) int               pageNo;
@property (nonatomic, assign) PersonProductType productType;
@property (nonatomic, strong) ZCListModel       *listModel;

@property (nonatomic, strong) UIView            *noneProductView;
@end

@implementation ZYZCPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _productArr=[NSMutableArray array];
    _pageNo=1;
    _productType=PublishType;
    [self setBackItem];
    [self configUI];
    [self getUserInfoData];
}

-(void)configUI
{
    UIView *navBgView=[[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:navBgView];
    
    _table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.contentInset=UIEdgeInsetsMake(HEAD_VIEW_HEIGHT, 0, -KTABBAR_HEIGHT+5, 0);
    _table.dataSource=self;
    _table.delegate=self;
    _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _table.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    WEAKSELF
    MJRefreshNormalHeader *normarlHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 1;
        [weakSelf getProductsData];

    }];
    normarlHeader.lastUpdatedTimeLabel.hidden=YES;
    _table.mj_header=normarlHeader;
    
    MJRefreshAutoNormalFooter *normalFooter=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNo++;
        [weakSelf getProductsData];
    }];
    
    [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
    _table.mj_footer=normalFooter;
    
    //添加头视图
    _headView=[[PersonHeadView alloc]initWithType:NO];
    [self.view addSubview:_headView];
//    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.height.mas_equalTo(HEAD_VIEW_HEIGHT);
//
//    }];
    _headView.changeProduct=^(PersonProductType productType)
    {
        weakSelf.productType=productType;
        weakSelf.pageNo=1;
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
       [weakSelf getProductsData];
    };
    
    [self createNoneProductView];
}

#pragma mark --- 获取个人信息
-(void)getUserInfoData
{
    NSString *url=[NSString stringWithFormat:@"%@selfUserId=%@&userId=%@",GETUSERDETAIL,[ZYZCAccountTool getUserId],_userId];
//    NSLog(@"%@",url);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [NetWorkManager hideFailViewForView:self.view];
//         NSLog(@"%@",result);
         if (isSuccess) {
             _userModel=[[UserModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
             NSNumber *friendShip=result[@"data"][@"friend"];
             _headView.friendship=[friendShip isEqual:@1]?YES:NO;
             _headView.meGzAll=result[@"data"][@"meGzAll"];
             _headView.gzMeAll=result[@"data"][@"gzMeAll"];
              _headView.userModel=_userModel;
             [self getProductsData];
         }
         else
         {
             [MBProgressHUD hideHUDForView:self.view];
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
         }
         
     } andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUDForView:self.view];
         [NetWorkManager showMBWithFailResult:failResult];
         [NetWorkManager hideFailViewForView:self.view];
         __weak typeof (&*self)weakSelf=self;
         [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
             [weakSelf getUserInfoData];
         }];
         //         NSLog(@"%@",failResult);
     }];
}

#pragma mark --- 获取他的众筹
-(void)getProductsData
{
    if (!_userModel.userId) {
        [MBProgressHUD hideHUDForView:self.view];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",LISTMYPRODUCTS,
                   GET_MY_LIST(_userModel.userId,_productType-PublishType+1,_pageNo)];
//    NSLog(@"url:%@",url);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            if (_pageNo==1&&_productArr.count) {
                [_productArr removeAllObjects];
            }
            _listModel=[[ZCListModel alloc]mj_setKeyValues:result];
            
            if (_listModel.data.count) {
                for(ZCOneModel *oneModel in _listModel.data)
                {
                    [_productArr addObject:oneModel];
                }
            } else {
                _pageNo--;
            }
            if (!_productArr.count) {
                _noneProductView.hidden=NO;
            } else {
                _noneProductView.hidden=YES;
            }
            [_table reloadData];
        } else {
           [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")]; 
        }
        //停止上拉刷新
        [_table.mj_footer endRefreshing];
        [_table.mj_header endRefreshing];

        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.view];
        //停止上拉刷新
        [_table.mj_footer endRefreshing];
        [_table.mj_header endRefreshing];
        
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getProductsData];
        }];
    }];
}

#pragma mark --- 创建没有众筹项目时的空界面
-(void)createNoneProductView
{
    _noneProductView=[[UIView alloc]initWithFrame:CGRectMake(0, HEAD_VIEW_HEIGHT, KSCREEN_W, KSCREEN_H-(HEAD_VIEW_HEIGHT))];
    _noneProductView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_noneProductView];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 40, _noneProductView.width-2*KEDGE_DISTANCE, 20)];
    lab.text=@"暂时没有任何数据～";
    lab.textColor=[UIColor ZYZC_TextBlackColor];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textAlignment=NSTextAlignmentCenter;
    [_noneProductView addSubview:lab];
    _noneProductView.hidden=YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     return _productArr.count*2+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        NSString *cellId=@"productCell";
        ZYZCOneProductCell *productCell=(ZYZCOneProductCell*)[ZYZCOneProductCell customTableView:tableView cellWithIdentifier:cellId andCellClass:[ZYZCOneProductCell class]];
        ZCOneModel *oneModel=_productArr[(indexPath.row-1)/2];
            oneModel.productType=ZCListProduct;
            productCell.oneModel=oneModel;
        return productCell;
    }
    else{
        UITableViewCell *cell=[ZYZCOneProductCell createNormalCell];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        return PRODUCT_CELL_HEIGHT;
    }
    else
    {
        return KEDGE_DISTANCE;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
    //推出信息详情页
    ZCProductDetailController *personDetailVC=[[ZCProductDetailController alloc]init];
    personDetailVC.hidesBottomBarWhenPushed=YES;
    ZCOneModel *oneModel=_productArr[(indexPath.row+1)/2-1];
    personDetailVC.oneModel=oneModel;
    personDetailVC.oneModel.productType=ZCDetailProduct;
    personDetailVC.productId=oneModel.product.productId;
    personDetailVC.detailProductType=PersonDetailProduct;
    [self.navigationController pushViewController:personDetailVC animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY=scrollView.contentOffset.y;
    CGFloat headViewHeight = HEAD_VIEW_HEIGHT;
//    NSLog(@"offsetYoffsetY%.2f  ",offsetY);
    if (offsetY<=-154) {
        if (offsetY < - headViewHeight) {
            _headView.top=0;
        } else {
            _headView.top=-(offsetY + HEAD_VIEW_HEIGHT);
        }
        _headView.tableOffSetY=offsetY;
    } else {
        _headView.top=-(-154 + HEAD_VIEW_HEIGHT);
        _headView.tableOffSetY=-154;
    }
    
    if (offsetY > -224) {
        NSString *name=_userModel.realName?_userModel.realName:_userModel.userName;
        self.title=name.length>8?[name substringToIndex:8]:name;
    } else {
        self.title=nil;
    }
    
    if (offsetY<=-(HEAD_VIEW_HEIGHT) + KEDGE_DISTANCE) {
//        _table.bounces=NO;
    } else {
        _table.bounces=YES;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
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
