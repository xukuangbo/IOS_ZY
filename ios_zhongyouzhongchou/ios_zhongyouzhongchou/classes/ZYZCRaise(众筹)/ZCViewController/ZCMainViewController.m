//
//  ZCMainViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//
//所有众筹列表
#define GET_PRODUCT_LIST(pageNo) [NSString stringWithFormat:@"cache=false&orderType=4&pageNo=%d&status_not=0,2&pageSize=5",pageNo]

#import "ZCMainViewController.h"
#import "ZCFilterTableViewCell.h"
#import "ZCListModel.h"
#import "ZCMainTableView.h"
#import "WXApiManager.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCAccountModel.h"
#import "NetWorkManager.h"
#import "LoginJudgeTool.h"
#import "MoreFZCViewController.h"
#import "MinePersonSetUpController.h"
#import "MineTravelTagVC.h"

//#import "TestViewController.h"

@interface ZCMainViewController ()<WXApiManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedView;
@property (nonatomic, strong) ZCMainTableView    *table;
@property (nonatomic, strong) UIImageView        *fitersView;
@property (nonatomic, strong) NSMutableArray     *filterArr;
@property (nonatomic, strong) ZCListModel        *listModel;
@property (nonatomic, strong) NSMutableArray     *listArr;
@property (nonatomic, strong) UIButton           *scrollTop;
@property (nonatomic, strong) UILabel            *titleView;
@property (nonatomic, assign) int                pageNo;
@property (nonatomic, assign) int                sex;

@property (nonatomic, strong) UISearchBar        *searchBar;//搜索栏
@property (nonatomic, strong) UIButton           *navLeftBtn;//发众筹按钮
@property (nonatomic, strong) UIButton           *navRightBtn;//发众筹按钮
@property (nonatomic, assign) BOOL               getSearch; //是否是搜索数据

@end

@implementation ZCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _listArr=[NSMutableArray array];
    _pageNo=1;
    [self setNavBar];
    [self configUI];
    [self getHttpData];
}

-(void)setNavBar
{
    //nav左右两边按钮创建
//    [self customNavWithLeftBtnImgName:@"nav_r"
//                      andRightImgName:nil
//                        andLeftAction:@selector(clickLeftNavBtn)
//                       andRightAction:nil];
    
    UIButton *navLeftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navLeftBtn.frame=CGRectMake(0, 4, 60, 30);
    //    navRightBtn.backgroundColor=[UIColor orangeColor];
    [navLeftBtn setTitle:@"筛选" forState:UIControlStateNormal];
    navLeftBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    //    navRightBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [navLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navLeftBtn addTarget:self action:@selector(clickLeftNavBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:navLeftBtn];
    _navLeftBtn=navLeftBtn;

    
    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame=CGRectMake(self.view.width-60, 4, 60, 30);
//    navRightBtn.backgroundColor=[UIColor orangeColor];
    [navRightBtn setTitle:@"发起" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    navRightBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(clickRightNavBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:navRightBtn];
    _navRightBtn=navRightBtn;
    
    //添加搜索框
    CGFloat searchBar_width=KSCREEN_W-120;
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake((KSCREEN_W-searchBar_width)/2, 4, searchBar_width, 30)];
    _searchBar.delegate=self;
//    _searchBar.alpha=0.5;
    _searchBar.layer.cornerRadius=KCORNERRADIUS;
    _searchBar.layer.masksToBounds=YES;
    _searchBar.placeholder=@"请输关键词搜索";
    _searchBar.returnKeyType=UIReturnKeyDone;
    for (UIView* subview in [[_searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            //修改输入字体的颜色
            //textField.textColor = [UIColor redColor];
            //修改输入框的颜色
            [textField setBackgroundColor:[UIColor whiteColor]];
            //修改placeholder的颜色
            [textField setValue:[UIColor ZYZC_TextGrayColor01] forKeyPath:@"_placeholderLabel.textColor"];
            }
        else if([subview isKindOfClass:
                 NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
        }
    }
    [self.navigationController.navigationBar addSubview:_searchBar];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _fitersView.hidden=YES;
    return YES;
}

#pragma mark --- 搜索项目
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    
    searchBar.text=[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL isEmptyStr=[ZYZCTool isEmpty:searchBar.text];
    if (isEmptyStr) {
      return;
    }
    _pageNo=1;
   
    _getSearch=YES;
    
    [self getHttpData];
}

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    searchBar.text=[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    BOOL isEmptyStr=[ZYZCTool isEmpty:searchBar.text];
//    if (isEmptyStr) {
//        return;
//    }
//    if (!searchBar.text.length) {
//         _getSearch=NO;
//         _pageNo=1;
//         _sex=0;
//        [self getHttpData];
//    }
//}

#pragma mark --- 点击右侧导航栏按钮
-(void)clickRightNavBtn
{
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
//    
//    return;
    
    [self enterFZC];
}

#pragma mark --- 点击左侧导航栏按钮
-(void)clickLeftNavBtn
{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    
    _filterArr=[NSMutableArray array];
    NSArray *titleArr=@[@"只看女",@"只看男"];
    NSArray *imgNameArr=@[@"btn_sex_fem",@"btn_sex_mal"];
    for (int i=0; i<2; i++) {
        ZCFilterModel *filterModel=[[ZCFilterModel alloc]init];
        filterModel.title=titleArr[i];
        filterModel.imgName=imgNameArr[i];
        [_filterArr addObject:filterModel];
    }
    
    if (!_fitersView) {
        _fitersView=[[UIImageView alloc]initWithFrame:CGRectMake(5,2.5+KNAV_HEIGHT, 125, 12.5+FILTER_CELL_HEIGHT*3)];
        _fitersView.hidden=YES;
        UIImage * image = [UIImage imageNamed:@"bg_sxleft"] ;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 0) resizingMode:UIImageResizingModeStretch];
        _fitersView.image=image;
        _fitersView.userInteractionEnabled=YES;
        [self.view addSubview:_fitersView];
        
        UITableView *filterTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 12.5, _fitersView.frame.size.width, _fitersView.frame.size.height-17.5) style:UITableViewStylePlain];
        filterTable.dataSource=self;
        filterTable.delegate=self;
        filterTable.backgroundColor=[UIColor clearColor];
        filterTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        filterTable.scrollEnabled=NO;
        filterTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_fitersView addSubview:filterTable];
    }
    
    _fitersView.hidden=!_fitersView.hidden;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCFilterTableViewCell *fiterCell=[[ZCFilterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil andRowAtIndexPath:indexPath];
    if (indexPath.row<2) {
        fiterCell.model=_filterArr[indexPath.row];
    }
    else
    {
        fiterCell.textLabel.text=@"看全部";
    }
    return fiterCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FILTER_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _fitersView.hidden=YES;
    
    _pageNo=1;
    
    _searchBar.text=[_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!_searchBar.text.length) {
        _getSearch=NO;
    }
    else
    {
        _getSearch=YES;
    }
    
    if (indexPath.row==0&&_sex!=2) {
        _sex=2;
        [self getHttpData];
    }
    else if(indexPath.row==1&&_sex!=1)
    {
        _sex=1;
        [self getHttpData];
    }
    else if(indexPath.row==2&&_sex!=0)
    {
        _sex=0;
        [self getHttpData];
    }
}



#pragma mark --- 创建控件
-(void)configUI
{
    //创建table
    _table=[[ZCMainTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.height=self.view.height-KTABBAR_HEIGHT;
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
    
    _table.scrollDidScrollBlock=^(CGFloat offSetY)
    {
        
//        NSLog(@"%.2f",offSetY);
        if (offSetY>=1000.0) {
            weakSelf.scrollTop.hidden=NO;
        }
        else
        {
            weakSelf.scrollTop.hidden=YES;
        }
        
        if (weakSelf.searchBar.isFirstResponder) {
            [weakSelf.searchBar resignFirstResponder];
        }
        
        weakSelf.getSearch=weakSelf.searchBar.text.length;
        
        //        if (offSetY>-54) {
//            [weakSelf.navigationController.navigationBar cnSetBackgroundColor:[[UIColor ZYZC_MainColor] colorWithAlphaComponent:0.95]];
//        }
//        else
//        {
//            [weakSelf.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor] ];
//        }
    };
    
    _table.scrollEndScrollBlock=^(CGPoint velocity)
    {
        weakSelf.fitersView.hidden=YES;
    };

    _titleView=[[UILabel alloc]initWithFrame:CGRectMake((KSCREEN_W-100)/2, 0, 100, 44)];
    _titleView.font=[UIFont boldSystemFontOfSize:20];
    _titleView.textColor=[UIColor whiteColor];
    _titleView.textAlignment=NSTextAlignmentCenter;
    _titleView.text=@"众游众筹";
    [self.navigationController.navigationBar addSubview:_titleView];
    

    //创建置顶按钮
    _scrollTop=[UIButton buttonWithType:UIButtonTypeCustom];
    _scrollTop.layer.cornerRadius=KCORNERRADIUS;
    _scrollTop.layer.masksToBounds=YES;
    _scrollTop.frame=CGRectMake(KSCREEN_W-60,KSCREEN_H-59-55,50,50);
    [_scrollTop setImage:[UIImage imageNamed:@"回到顶部"] forState:UIControlStateNormal];
    
    [_scrollTop addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    _scrollTop.hidden=YES;
    [self.view addSubview:_scrollTop];
}

#pragma mark --- 获取众筹列表
-(void)getHttpData
{
    //获取所有众筹详情
    NSString *httpUrl=nil;
    //搜索关键词
    if (_getSearch) {
        //关键词
        NSString *keyword= [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (_sex>0) {
            httpUrl=[NSString stringWithFormat:@"%@%@&keyword=%@&sex=%d",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo),keyword,_sex];
        }
        else
        {
            httpUrl=[NSString stringWithFormat:@"%@%@&keyword=%@",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo),keyword];
        }
    }
    else
    {
        if (_sex>0) {
            
             httpUrl=[NSString stringWithFormat:@"%@%@&sex=%d",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo),_sex];
        }
        else
        {
             httpUrl=[NSString stringWithFormat:@"%@%@",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
        }
    }

    DDLog(@"httpUrl:%@",httpUrl);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
//        DDLog(@"result：%@",result);
        if (isSuccess) {
            MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_table.mj_footer ;
            if (_pageNo==1&&_listArr.count) {
                [_listArr removeAllObjects];
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            _listModel=[[ZCListModel alloc]mj_setKeyValues:result];
            
            for(ZCOneModel *oneModel in _listModel.data)
            {
                oneModel.productType=ZCListProduct;
                [_listArr addObject:oneModel];
            }
            
            if (_listModel.data.count==0) {
                _pageNo--;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
            }
            else
            {
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
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
//        NSLog(@"failResult：%@",failResult);
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [MBProgressHUD  hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpData];
        }];
    }];
}

#pragma mark --- 置顶
-(void)scrollToTop
{
    [_table setContentOffset:CGPointMake(0, -64) animated:YES];
    
}

#pragma mark --- 发众筹
-(void)enterFZC
{
    //判断是否登录
    BOOL hasLogin=[LoginJudgeTool judgeLogin];
    if (!hasLogin) {
        return;
    }
    //判断是否完善个人信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:CHECK_USERINFO  andParameters:@{@"userId":[ZYZCAccountTool getUserId]} andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [MBProgressHUD hideHUDForView:self.view];
         if (isSuccess) {
             if (![result[@"data"][@"info"] boolValue]) {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"个人信息未完善,无法发送众筹,是否完善" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                 alert.tag=1;
                 [alert show];
                 //                self.selectedIndex=4;
             }
             else if([result[@"data"][@"info"] boolValue]&&![result[@"data"][@"tag"] boolValue])
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"旅行标签未完善,无法发送众筹,是否完善" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                 alert.tag=2;
                 [alert show];
                 //  [MBProgressHUD showError:@"旅行标签未完善,请完善!"];
                 //  self.selectedIndex=4;
             }
             else if ([result[@"data"][@"info"] boolValue]&&[result[@"data"][@"tag"] boolValue])
             {
                 //发起众筹
                 MoreFZCViewController *fzcVC=[[MoreFZCViewController alloc]init];
                 fzcVC.hidesBottomBarWhenPushed=YES;
                 [self.navigationController pushViewController:fzcVC animated:YES];
             }
         }
         else
         {
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
         }
         
     } andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUDForView:self.view];
         [NetWorkManager showMBWithFailResult:failResult];
     }];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1&&buttonIndex==1) {
        [self enterMyInfoSet];
    }
    else if (alertView.tag==2&&buttonIndex==1)
    {
        [self enterTravelTag];
    }
    
}


#pragma mark --- 进入个人信息设置
-(void)enterMyInfoSet
{
    BOOL hasLogin=[LoginJudgeTool judgeLogin];
    if (!hasLogin) {
        return;
    }
    MinePersonSetUpController *mineInfoSetVietrroller=[[MinePersonSetUpController alloc] init];
    mineInfoSetVietrroller.wantFZC = YES;
    mineInfoSetVietrroller.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:mineInfoSetVietrroller animated:YES];
}

#pragma mark --- 进入个人旅行标签
-(void)enterTravelTag
{
    [self.navigationController pushViewController:[[MineTravelTagVC alloc] init] animated:YES];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [_segmentedView removeFromSuperview];
    _titleView.hidden=YES;
    _fitersView.hidden=YES;
    _searchBar.hidden=YES;
    _navRightBtn.hidden=YES;
    _navLeftBtn.hidden=YES;
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    _titleView.hidden   = YES ;
    _searchBar.hidden   = NO  ;
    _navRightBtn.hidden = NO  ;
    _navLeftBtn.hidden  = NO  ;
    [_table reloadData];
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
