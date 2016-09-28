//
//  ZYUserZoneController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define Get_Uer_List(userId,type,pageNo) [NSString stringWithFormat:@"cache=false&userId=%@&self=%ld&pageNo=%d&status_not=0,2&pageSize=10",userId,type,pageNo]

#import "ZYUserZoneController.h"
#import "ZYUserBottomBarView.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "ZYUserHeadView.h"
#import "ZCListModel.h"
#import "ZYUserProductTable.h"

#import "ZYFootprintListView.h"
#import "MBProgressHUD+MJ.h"

@interface ZYUserZoneController ()
@property (nonatomic, strong) ZYUserBottomBarView *bottomBarView;
@property (nonatomic, strong) UserModel           *userModel;
@property (nonatomic, assign) BOOL                friendship;
@property (nonatomic, assign) NSInteger           fansNumber;//粉丝数
@property (nonatomic, assign) NSInteger           friendNumber;//关注数

@property (nonatomic, strong) ZYUserHeadView       *userheadView;

//行程
@property (nonatomic, strong) NSMutableArray      *productArr;
@property (nonatomic, assign) TravelType           productType;//行程类型
@property (nonatomic, assign) int                  travel_pageNo;
@property (nonatomic, strong) ZYUserProductTable   *userProductTable;
@property (nonatomic, strong) UIView               *noneProductView;

//足迹
@property (nonatomic, strong) ZYFootprintListView  *footprintListView;
@property (nonatomic, strong) UIView               *noneFootprintView;
@property (nonatomic, assign) NSInteger             footprint_pageNo;
@property (nonatomic, strong) NSMutableArray       *footprintArr;

@property (nonatomic, assign) NSInteger             contentType;


@end

@implementation ZYUserZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _productType=Travel_PublishType;
    _productArr=[NSMutableArray array];
    _travel_pageNo=1;
    _footprintArr=[NSMutableArray array];
    _footprint_pageNo=1;
    [self setBackItem];
    [self configUI];
    [self getUserInfoData];
}

-(void)configUI
{
    UIView *navBgView=[[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:navBgView];
    
    _userProductTable=[[ZYUserProductTable alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _userProductTable.contentInset=UIEdgeInsetsMake(User_Head_Height, 0, KTABBAR_HEIGHT, 0);
    [self.view addSubview:_userProductTable];
    
    _userheadView = [[ZYUserHeadView alloc]initWithUserZoomtype:OtherZoomType];
    [self.view addSubview:_userheadView];
    
    _bottomBarView= [[ZYUserBottomBarView alloc]initWithFrame:CGRectMake(0, KSCREEN_H-49, KSCREEN_W, 49)];
    [self.view addSubview:_bottomBarView];
    
    _noneProductView = [self createNoneViewWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H-(User_Head_Height)-49)];
    [_userProductTable addSubview:_noneProductView];
    
    WEAKSELF;
    //行程
    _userProductTable.headerRefreshingBlock=^()
    {
        weakSelf.travel_pageNo = 1;
        [weakSelf getProductsData];
    };
    
    _userProductTable.footerRefreshingBlock=^()
    {
        weakSelf.travel_pageNo++;
        [weakSelf getProductsData];
    };
    
    _userProductTable.scrollDidScrollBlock=^(CGFloat offsetY)
    {
        [weakSelf productTableScrollDidScroll:offsetY];
    };
    
    _userProductTable.scrollWillBeginDraggingBlock=^()
    {
        weakSelf.userheadView.travelTypeView.userInteractionEnabled=NO;
        weakSelf.userheadView.segmentView.enabled=NO;
    };
    
    _userProductTable.scrollDidEndDeceleratingBlock=^()
    {
        weakSelf.userheadView.travelTypeView.userInteractionEnabled=YES;
        weakSelf.userheadView.segmentView.enabled=YES;
    };
    
    //底部
    _bottomBarView.changeFansNumber=^(NSInteger fansNumber)
    {
        weakSelf.userheadView.fansNumber=fansNumber;
    };
    
    //头部
    _userheadView.travelTypeView.changeTravelType=^(TravelType travelType)
    {
        weakSelf.productType=travelType;
        weakSelf.travel_pageNo=1;
        [MBProgressHUD showMessage:nil];
        [weakSelf getProductsData];
    };
    
    _userheadView.changeContent=^(NSInteger contentType)
    {
        weakSelf.contentType=contentType;
        
        weakSelf.userheadView.top = 0;
        
        if (contentType==0) {
            [weakSelf.userProductTable setContentOffset:CGPointMake(0, -(User_Head_Height)) animated:YES];
            weakSelf.userheadView.prosuctTableOffSetY=-(User_Head_Height);
            weakSelf.userProductTable.hidden =NO;
            weakSelf.footprintListView.hidden=YES;
        }
        else if (contentType==1)
        {
            [weakSelf createFootprintListView];
            [weakSelf.footprintListView setContentOffset:CGPointMake(0, -(My_User_Head_height)) animated:YES];
             weakSelf.userheadView.footprintTableOffSetY=-(My_User_Head_height);
            weakSelf.userProductTable.hidden =YES;
            weakSelf.footprintListView.hidden=NO;
        }
    };
}
#pragma mark --- 创建足迹列表
-(void)createFootprintListView
{
    if (!_footprintListView) {
        _footprintListView=[[ZYFootprintListView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain andFootprintListType:OtherFootprintList];
        _footprintListView.contentInset=UIEdgeInsetsMake(My_User_Head_height, 0, KTABBAR_HEIGHT, 0);
        _footprintListView.backgroundColor=[UIColor ZYZC_BgGrayColor];
        [self.view addSubview:_footprintListView];
        
        _noneFootprintView = [self createNoneViewWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H-(My_User_Head_height)-49)];
        [_footprintListView addSubview:_noneFootprintView];
        
        [self.view bringSubviewToFront:_userheadView];
        [self.view bringSubviewToFront:_bottomBarView];
        
        //足迹
        WEAKSELF;
        _footprintListView.headerRefreshingBlock=^()
        {
            weakSelf.footprint_pageNo=1;
            [weakSelf getFootprintData];
        };
        
        _footprintListView.footerRefreshingBlock=^()
        {
            weakSelf.footprint_pageNo++;
            [weakSelf getFootprintData];
        };
        
        _footprintListView.scrollDidScrollBlock=^(CGFloat offsetY)
        {
            [weakSelf productTableScrollDidScroll:offsetY];
        };
        _footprintListView.scrollWillBeginDraggingBlock=^()
        {
            weakSelf.userheadView.segmentView.enabled=NO;
        };
        
        _footprintListView.scrollDidEndDeceleratingBlock=^()
        {
            weakSelf.userheadView.segmentView.enabled=YES;
        };

        [self getFootprintData];
    }
}

#pragma mark --- 创建没空界面
-(UIView *)createNoneViewWithFrame:(CGRect)frame
{
    UIView  *noneProductView=[[UIView alloc]initWithFrame:frame];
    noneProductView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:noneProductView];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 40, noneProductView.width-2*KEDGE_DISTANCE, 20)];
    lab.text=@"暂时没有任何数据～";
    lab.textColor=[UIColor ZYZC_TextBlackColor];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textAlignment=NSTextAlignmentCenter;
    [noneProductView addSubview:lab];
    noneProductView.hidden=YES;
    return noneProductView;
}


#pragma mark --- 项目的table滑动
-(void)productTableScrollDidScroll:(CGFloat) offsetY
{
    CGFloat headViewHeight =_contentType==0?User_Head_Height:My_User_Head_height ;
    CGFloat min_offsetY=_contentType==0?-154:-114;
    
    CGFloat show_Name_offsetY=_contentType==0?-224:-184;
  
    if (offsetY<=min_offsetY) {
        if (offsetY < - (headViewHeight)) {
            _userheadView.top=0;
        } else {
            _userheadView.top=-(offsetY + headViewHeight);
        }
        if (_contentType==0) {
            _userheadView.prosuctTableOffSetY=offsetY;
        }
        else
        {
            _userheadView.footprintTableOffSetY=offsetY;
        }
        
    } else {
        _userheadView.top=-(min_offsetY + headViewHeight);
        if (_contentType==0) {
            _userheadView.prosuctTableOffSetY=min_offsetY;
        }
        else
        {
            _userheadView.footprintTableOffSetY=min_offsetY;
        }
    }
    
    if (offsetY > show_Name_offsetY) {
        NSString *name=_userModel.realName?_userModel.realName:_userModel.userName;
        self.title=name.length>8?[name substringToIndex:8]:name;
    } else {
        self.title=nil;
    }
    if (offsetY<=-(headViewHeight) + KEDGE_DISTANCE) {
    }
    else {
        _userProductTable.bounces=YES;
        _footprintListView.bounces=YES;
    }
}

#pragma mark --- 获取用户信息
-(void)getUserInfoData
{
    NSString *url=Get_SelfInfo([ZYZCAccountTool getUserId],_friendID);
    
    [MBProgressHUD showMessage:nil];
    
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [NetWorkManager hideFailViewForView:self.view];
         
         if (isSuccess) {
             self.friendship  = [result[@"data"][@"friend"] boolValue];
             self.friendNumber= [result[@"data"][@"meGzAll"] integerValue];
             self.fansNumber  = [result[@"data"][@"gzMeAll"] integerValue];
              self.userModel=[[UserModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
            [self getProductsData];
         }
         else
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
         }
     }
    andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUD];
         [NetWorkManager showMBWithFailResult:failResult];
         [NetWorkManager hideFailViewForView:self.view];
         __weak typeof (&*self)weakSelf=self;
         [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
             [weakSelf getUserInfoData];
         }];
     }];
}

#pragma mark --- 获取TA的众筹
-(void)getProductsData
{
    if (!_userModel.userId) {
        [MBProgressHUD hideHUD];
        return;
    }

    NSString *url=[NSString stringWithFormat:@"%@%@",LISTMYPRODUCTS, Get_Uer_List(_userModel.userId,_productType-Travel_PublishType+1,_travel_pageNo)];
    
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [MBProgressHUD hideHUD];
         [NetWorkManager hideFailViewForView:self.view];
         if (isSuccess) {
             MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_userProductTable.mj_footer ;
             if (_travel_pageNo==1&&_productArr.count) {
                 [_productArr removeAllObjects];
                 [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
             }
             ZCListModel *listModel=[[ZCListModel alloc]mj_setKeyValues:result];
             if (listModel.data.count) {
                 for(ZCOneModel *oneModel in listModel.data)
                 {
                     [_productArr addObject:oneModel];
                 }
                 [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
             }
             else {
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
                 _travel_pageNo--;
             }
             _noneProductView.hidden=_productArr.count;
             
             _userProductTable.dataArr=_productArr;
             [_userProductTable reloadData];
         } else {
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
         }
         //停止上拉刷新
         [_userProductTable.mj_footer endRefreshing];
         [_userProductTable.mj_header endRefreshing];
     } andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUD];
         //停止上拉刷新
         [_userProductTable.mj_footer endRefreshing];
         [_userProductTable.mj_header endRefreshing];
         [NetWorkManager hideFailViewForView:self.view];
         [NetWorkManager showMBWithFailResult:failResult];
         __weak typeof (&*self)weakSelf=self;
         [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
             [weakSelf getProductsData];
         }];
     }];
}

#pragma mark --- 获取足迹数据
-(void)getFootprintData
{
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:List_Footprint andParameters:@{@"pageNo"  :[NSNumber numberWithInteger:_footprint_pageNo],@"targetId":_friendID
     } andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        [MBProgressHUD hideHUD];
         if (isSuccess) {
             MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_footprintListView.mj_footer ;
             if (_footprint_pageNo==1&&_footprintArr.count) {
               [_footprintArr removeAllObjects];
              [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
               }
               ZYFootprintDataModel  *listModel=[[ZYFootprintDataModel alloc]mj_setKeyValues:result];
                                                        
             for(ZYFootprintListModel *oneModel in listModel.data)
               {
               [_footprintArr addObject:oneModel];
             }
            if (listModel.data.count==0) {
                _footprint_pageNo--;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
         }
         else
         {
          [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
           }
             
         _noneFootprintView.hidden=_footprintArr.count;
         
            _footprintListView.dataArr=_footprintArr;
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


-(void)setUserModel:(UserModel *)userModel
{
    _userModel=userModel;
    _userheadView.userModel=userModel;
    _bottomBarView.friendID=userModel.userId;
    _bottomBarView.friendName=userModel.realName?userModel.realName:userModel.userName;
}

#pragma mark --- 关注关系
-(void)setFriendship:(BOOL)friendship
{
    _friendship=friendship;
    _bottomBarView.friendship=friendship;
}

#pragma mark --- 关注人数
-(void)setFriendNumber:(NSInteger)friendNumber
{
    _friendNumber=friendNumber;
    _userheadView.friendNumber=friendNumber;
}

#pragma mark --- 粉丝数
-(void)setFansNumber:(NSInteger)fansNumber
{
    _fansNumber=fansNumber;
    _userheadView.fansNumber=fansNumber;
    _bottomBarView.fansNumber=fansNumber;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    
    if(_contentType==1&&_footprintListView)
    {
        [_footprintListView reloadData];
    }
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
