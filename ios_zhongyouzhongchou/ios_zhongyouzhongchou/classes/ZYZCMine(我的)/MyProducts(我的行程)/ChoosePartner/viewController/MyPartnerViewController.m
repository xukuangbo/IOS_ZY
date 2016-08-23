//
//  MyPartnerViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MyPartnerViewController.h"
#import "PartnerTableView.h"
#import "TogetherUersModel.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
@interface MyPartnerViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedView;
@property (nonatomic, strong) PartnerTableView   *table;
//@property (nonatomic, strong) NSArray            *users;
@property (nonatomic, assign) NSInteger          pageNo;
@property (nonatomic, strong) UIButton           *addPartnerBtn;

@property (nonatomic, strong) UIView            *noneProductView;

@end

@implementation MyPartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageNo=1;
    [self setBackItem];
    [self configUI];
    [self getHttpData];
}

-(void)pressBack
{
    [super pressBack];
    [_segmentedView removeFromSuperview];
}

-(void)configUI
{
    //创建table
    _table=[[PartnerTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.productId=_productId;
    _table.height=KSCREEN_H-90;
    [self.view addSubview:_table];
    
    __weak typeof (&*self)weakSelf=self;
    _table.headerRefreshingBlock=^()
    {
        [weakSelf getHttpData];
    };
    
    _table.mj_footer=nil;
    
     [self createNoneDataView];
    
    //创建➕按钮
    _addPartnerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addPartnerBtn.frame=CGRectMake(KEDGE_DISTANCE, KSCREEN_H-80,KSCREEN_W-2*KEDGE_DISTANCE , 70);
    _addPartnerBtn.layer.cornerRadius=KCORNERRADIUS;
    _addPartnerBtn.layer.masksToBounds=YES;
    [_addPartnerBtn setImage:[UIImage imageNamed:@"add_partner"] forState:UIControlStateNormal];
    [_addPartnerBtn addTarget:self  action:@selector(addPartner) forControlEvents:UIControlEventTouchUpInside];
    _addPartnerBtn.hidden=(_myPartnerType==ReturnPartner);
    [self.view addSubview:_addPartnerBtn];
}

#pragma mark --- 创建空界面
-(void)createNoneDataView
{
    _noneProductView=[[UIView alloc]initWithFrame:self.view.bounds];
    _noneProductView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_noneProductView];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 64+40, _noneProductView.width-2*KEDGE_DISTANCE, 20)];
    lab.text=@"暂时没有任何数据～";
    lab.textColor=[UIColor ZYZC_TextBlackColor];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textAlignment=NSTextAlignmentCenter;
    [_noneProductView addSubview:lab];
    _noneProductView.hidden=YES;
}

-(void)getHttpData
{
    NSString *httpUrl=GET_SELECTED_TOGETHER_PARTNERS([ZYZCAccountTool getUserId], _productId, _myPartnerType);
//    NSLog(@"httpUrl:%@",httpUrl);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        [MBProgressHUD hideHUDForView:self.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            TogetherUersModel *togetherUersModel=[[TogetherUersModel alloc]mj_setKeyValues:result[@"data"]];
//            _users=togetherUersModel.users;
            _table.myListArr=[NSMutableArray arrayWithArray:togetherUersModel.users];
            _table.myPartnerType=_myPartnerType;
            _table.fromMyReturn=_fromMyReturn;
            [_table reloadData];
            
            if (!togetherUersModel.users.count) {
                _noneProductView.hidden=NO;
            }
            else
            {
               _noneProductView.hidden=YES;
            }
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        [_table.mj_header endRefreshing];
    } andFailBlock:^(id failResult)
    {
        [MBProgressHUD hideHUDForView:self.view];
        [_table.mj_header endRefreshing];
        [NetWorkManager showMBWithFailResult:failResult];
//        NSLog(@"%@",failResult);
    }];
}



#pragma mark --- 添加新的partner
-(void)addPartner
{
    if (_fromMyReturn==YES) {
        [MBProgressHUD showShortMessage:@"已过出发时间，不可操作"];
        return;
    }
    
    ChoosePartnerViewController *choosePartnerVC=[[ChoosePartnerViewController alloc]init];
    choosePartnerVC.productId=_productId;
    __weak typeof (&*self)weakSelf=self;
    choosePartnerVC.addPartnerSuccess=^()
    {
        [weakSelf getHttpData];
    };
    [self.navigationController pushViewController:choosePartnerVC animated:YES];
}

-(void)changeSegmented:(UISegmentedControl *)segemented
{
    if (segemented.selectedSegmentIndex==0) {
        //旅伴
        _myPartnerType=TogtherPartner;
        _table.height=_addPartnerBtn.top-KEDGE_DISTANCE;
        _addPartnerBtn.hidden=NO;
    }
    else if(segemented.selectedSegmentIndex==1){
        //回报
        _myPartnerType=ReturnPartner;
        _table.height=self.view.height;
        _addPartnerBtn.hidden=YES;
    }
    [self getHttpData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_segmentedView removeFromSuperview];
    _segmentedView=nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    if (!_segmentedView) {
        NSArray *titleArr=@[@"旅伴",@"回报"];
        _segmentedView = [[UISegmentedControl alloc]initWithItems:titleArr];
        CGFloat width=200;
        _segmentedView.frame = CGRectMake((KSCREEN_W-width)/2, 7, width, 30);
        _segmentedView.backgroundColor=[UIColor ZYZC_MainColor];
        _segmentedView.tintColor = [UIColor whiteColor];
        _segmentedView.layer.cornerRadius=4;
        _segmentedView.layer.masksToBounds=YES;
        [_segmentedView addTarget:self action:@selector(changeSegmented:) forControlEvents:UIControlEventValueChanged];
        _segmentedView.selectedSegmentIndex=_myPartnerType-TogtherPartner;
        [self.navigationController.navigationBar addSubview:_segmentedView];
    }
//    [self getHttpData];
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
