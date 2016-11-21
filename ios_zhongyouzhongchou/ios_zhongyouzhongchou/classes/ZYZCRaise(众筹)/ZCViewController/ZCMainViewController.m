//
//  ZCMainViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//
//所有众筹列表

//#define GET_PRODUCT_LIST(pageNo) [NSString stringWithFormat:@"cache=false&orderType=4&pageNo=%d&pageSize=10",pageNo]

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
#import "EntryPlaceholderView.h"

#import "ViewController.h"
#import "GuideWindow.h"
#import "ZYNewGuiView.h"
#import "ZYGuideManager.h"

#import "ZYWatchLiveViewController.h"
#import "ZYSystemCommon.h"
@interface ZCMainViewController ()<WXApiManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, ShowDoneDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedView;
@property (nonatomic, strong) ZCMainTableView    *table;
@property (nonatomic, strong) UIImageView        *fitersView;
@property (nonatomic, strong) ZCListModel        *listModel;
@property (nonatomic, strong) NSMutableArray     *listArr;
@property (nonatomic, strong) UIButton           *scrollTop;
@property (nonatomic, strong) UILabel            *titleView;
@property (nonatomic, assign) int                pageNo;
//@property (nonatomic, assign) int                sex;

@property (nonatomic, strong) UISearchBar        *searchBar;//搜索栏
@property (nonatomic, strong) UIButton           *navLeftBtn;//发众筹按钮
@property (nonatomic, strong) UIButton           *navRightBtn;//发众筹按钮
//@property (nonatomic, assign) BOOL               getSearch; //是否是搜索数据

@property (nonatomic, assign) NSInteger         filterType;//过滤条件
@property (nonatomic, strong) NSArray           *filterItems;

@property (nonatomic, strong) EntryPlaceholderView *entryView;

@property (nonatomic, assign) BOOL              isNeedMB;//
// 引导页view
@property (strong, nonatomic) GuideWindow *guideWindow;
@property (strong, nonatomic) ZYNewGuiView *guideView;
@property (strong, nonatomic) ZYNewGuiView *notifitionView;
// 处理直播通知
@property (nonatomic, strong) ZYSystemCommon *systemCommon;
@property (strong, nonatomic) ZYLiveListModel *liveModel;

@end

@implementation ZCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _listArr=[NSMutableArray array];
    self.systemCommon = [[ZYSystemCommon alloc] init];

    _pageNo=1;
//    _isFirstEntry=YES;
    _filterItems=@[@"只看女",@"只看男",@"看成功",@"看最新",@"看全部",@"取消"];
    _filterType=_filterItems.count;//默认
    [self setNavBar];
    [self configUI];
    if (![ZYGuideManager getGuideStartZhongchou]) {
        [self createOpenFlashContextView];
    }
    [self.table.mj_header beginRefreshing];
//    [self getHttpDataByFilterType:_filterType andSeachKey:nil];
}

-(void)setNavBar
{
    UIButton *navLeftBtn=[ZYZCTool createBtnWithFrame:CGRectMake(0, 4, 60, 30) andNormalTitle:@"筛选" andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(clickLeftNavBtn)];
    navLeftBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
    [self.navigationController.navigationBar addSubview:navLeftBtn];
    _navLeftBtn=navLeftBtn;

    UIButton *navRightBtn=[ZYZCTool createBtnWithFrame:CGRectMake(self.view.width-60, 4, 60, 30) andNormalTitle:@"发起" andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(clickRightNavBtn)];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
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
    [_searchBar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    for (UIView* subview in [[_searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            //修改输入字体的颜色
            textField.textColor = [UIColor ZYZC_TextBlackColor];
            textField.font = [UIFont systemFontOfSize:15.f];
            //修改输入框的颜色
            [textField setBackgroundColor:[UIColor whiteColor]];
            //修改placeholder的颜色
            [textField setValue:[UIColor ZYZC_TextGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
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
    
    self.filterType=4;
    [_table.mj_header beginRefreshing];
//    [self getHttpDataByFilterType:4 andSeachKey:searchBar.text];
}

#pragma mark --- 点击右侧导航栏按钮
-(void)clickRightNavBtn
{
    [self enterFZC];
}

#pragma mark --- 点击左侧导航栏按钮
-(void)clickLeftNavBtn
{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }

    if (!_fitersView) {
        _fitersView=[[UIImageView alloc]initWithFrame:CGRectMake(5,2.5+KNAV_HEIGHT, 125, 12.5+FILTER_CELL_HEIGHT*_filterItems.count)];
        _fitersView.hidden=YES;
        _fitersView.image=KPULLIMG(@"bg_sxleft", 15, 0, 15, 0);
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
    return _filterItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCFilterTableViewCell *fiterCell=[[ZCFilterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil andRowAtIndexPath:indexPath];
    fiterCell.textLabel.text=_filterItems[indexPath.row];
    return fiterCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FILTER_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _fitersView.hidden=YES;
    _searchBar.text=nil;
    if (_filterType!=indexPath.row+1) {
        _pageNo=1;
//        _isFirstEntry=YES;
        _filterType=indexPath.row+1;
        [self.table.mj_header beginRefreshing];
//        [self getHttpDataByFilterType:_filterType andSeachKey:nil];
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
        weakSelf.entryView.hidden = YES;
        weakSelf.pageNo=1;
        [weakSelf getHttpDataByFilterType:weakSelf.filterType andSeachKey:weakSelf.searchBar.text];
    };
    _table.footerRefreshingBlock=^()
    {
        weakSelf.entryView.hidden = YES;
        weakSelf.pageNo++;
        [weakSelf getHttpDataByFilterType:weakSelf.filterType andSeachKey:weakSelf.searchBar.text];
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
    
    
    _entryView = [EntryPlaceholderView viewWithSuperView:self.table type:EntryTypeSearch];
    _entryView.hidden = YES;
    
}

#pragma mark -customView
- (GuideWindow *)guideWindow
{
    if (!_guideWindow && ![ZYGuideManager getGuideStartZhongchou]) {
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _guideWindow = [[GuideWindow alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    } else {
        _guideWindow = [[GuideWindow alloc] initWithFrame:CGRectMake(0, KSCREEN_H - 49 - 60, ScreenWidth - 20, 50)];
    }
    return _guideWindow;
}

- (void)createOpenFlashContextView
{
    ZYNewGuiView *newGuideView = [[ZYNewGuiView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [self.guideWindow addSubview:newGuideView];
    self.guideView = newGuideView;
    newGuideView.showDoneDelagate = self;
    [newGuideView initSubViewWithTeacherGuideType:startHomeType withContextViewType:rectTangleType];
    [self.guideWindow bringSubviewToFront:newGuideView];
    [self.guideWindow show];
}

- (void)createNotificationView:(NSString *)content headImage:(NSString *)headImage
{
    ZYNewGuiView *notifitionView = [[ZYNewGuiView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 50) NotificationContent:content liveHeadImage:headImage];
    notifitionView.layer.masksToBounds = YES;
    notifitionView.layer.cornerRadius = 25;
    
    [self.guideWindow addSubview:notifitionView];
    self.notifitionView = notifitionView;
    self.notifitionView.rectTypeOriginalY = 283;
    notifitionView.showDoneDelagate = self;
    [notifitionView initSubViewWithTeacherGuideType:liveWindowType withContextViewType:rectTangleType];
    [self.guideWindow bringSubviewToFront:notifitionView];
    [self.guideWindow show];
}

#pragma mark - ShowDoneDelegate
- (void)showDone
{
    if (![ZYGuideManager getGuideStartZhongchou]) {
        self.guideView = nil;
        [self.guideView removeFromSuperview];
        [self.guideWindow dismiss];
        self.guideWindow = nil;
        
        [ZYGuideManager guideStartZhongchou:YES];
    } else {
        ZYWatchLiveViewController *watchLiveVC = [[ZYWatchLiveViewController alloc] initWatchLiveModel:self.liveModel];
        watchLiveVC.hidesBottomBarWhenPushed = YES;
        watchLiveVC.conversationType = ConversationType_CHATROOM;
        [self.navigationController pushViewController:watchLiveVC animated:YES];
        [self closeNotifitionView];
    }
}

- (void)closeNotifitionView
{
    self.notifitionView = nil;
    [self.notifitionView removeFromSuperview];
    [self.guideWindow dismiss];
    self.guideWindow = nil;
}

#pragma mark - 收到直播通知
- (void)receptionLiveNotification:(NSNotification *)notification
{
    NSDictionary *notificationObject = (NSDictionary *)notification.object;
    NSDictionary *apsDict = notificationObject[@"aps"];
    WEAKSELF
    NSDictionary *parameters= @{
                                @"spaceName":notificationObject[@"spaceName"],
                                @"streamName":notificationObject[@"streamName"]
                                };
    self.systemCommon.getLiveDataSuccess = ^(ZYLiveListModel *liveModel) {
        if (liveModel != nil) {
            weakSelf.liveModel = liveModel;
            [weakSelf createNotificationView:apsDict[@"alert"] headImage:notificationObject[@"headImg"]];
        } else {
            
        }
    };
    [self.systemCommon getLiveContent:parameters];
}


#pragma mark --- 获取众筹列表
-(void)getHttpDataByFilterType:(NSInteger )filterType  andSeachKey:(NSString *)searchKey
{
    _entryView.hidden = YES;
    //获取所有众筹详情
    NSString *httpUrl=nil;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//cache=false&orderType=4&pageNo=%d&pageSize=10
    if (searchKey.length) {
        //搜索关键词
        NSString *keyword= [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        httpUrl=[NSString stringWithFormat:@"%@%@&querytype=6&keyword=%@",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo),keyword];
        httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
        [parameter setValue:@"false" forKey:@"cache"];
        [parameter setValue:@"4" forKey:@"orderType"];
        [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
        [parameter setValue:@"10" forKey:@"pageSize"];
        [parameter setValue:@"6" forKey:@"querytype"];
//        [parameter setValue:keyword forKey:@"keyword"];
        httpUrl =[httpUrl stringByAppendingString:[NSString stringWithFormat:@"?keyword=%@",keyword]];
    }
    else
    {
        //只看女
        if (_filterType==1) {
//            httpUrl=[NSString stringWithFormat:@"%@%@&querytype=1&sex=2",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
            httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
            [parameter setValue:@"false" forKey:@"cache"];
            [parameter setValue:@"4" forKey:@"orderType"];
            [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
            [parameter setValue:@"10" forKey:@"pageSize"];
            [parameter setValue:@"1" forKey:@"querytype"];
            [parameter setValue:@"2" forKey:@"sex"];
        }
        //只看男
        else if(_filterType==2)
        {
//             httpUrl=[NSString stringWithFormat:@"%@%@&querytype=1&sex=1",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
            httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
            [parameter setValue:@"false" forKey:@"cache"];
            [parameter setValue:@"4" forKey:@"orderType"];
            [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
            [parameter setValue:@"10" forKey:@"pageSize"];
            [parameter setValue:@"1" forKey:@"querytype"];
            [parameter setValue:@"1" forKey:@"sex"];
        }
        //看成功
        else if (_filterType==3)
        {
//            httpUrl=[NSString stringWithFormat:@"%@%@&querytype=2",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
            httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
            [parameter setValue:@"false" forKey:@"cache"];
            [parameter setValue:@"4" forKey:@"orderType"];
            [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
            [parameter setValue:@"10" forKey:@"pageSize"];
            [parameter setValue:@"2" forKey:@"querytype"];
        }
        //看最新
        else if (_filterType==4)
        {
//            httpUrl=[NSString stringWithFormat:@"%@%@&querytype=5",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
            httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
            [parameter setValue:@"false" forKey:@"cache"];
            [parameter setValue:@"4" forKey:@"orderType"];
            [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
            [parameter setValue:@"10" forKey:@"pageSize"];
            [parameter setValue:@"5" forKey:@"querytype"];
        }
        //看全部
        else if (_filterType==5)
        {
//            httpUrl=[NSString stringWithFormat:@"%@%@&querytype=3",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
            httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
            [parameter setValue:@"false" forKey:@"cache"];
            [parameter setValue:@"4" forKey:@"orderType"];
            [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
            [parameter setValue:@"10" forKey:@"pageSize"];
            [parameter setValue:@"3" forKey:@"querytype"];
        }
        //默认
        else if (_filterType==6)
        {
//             httpUrl=[NSString stringWithFormat:@"%@%@&querytype=98",LISTALLPRODUCTS,GET_PRODUCT_LIST(_pageNo)];
            httpUrl =[[ZYZCAPIGenerate sharedInstance] API:@"list_listAllProductsApp"];
            [parameter setValue:@"false" forKey:@"cache"];
            [parameter setValue:@"4" forKey:@"orderType"];
            [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
            [parameter setValue:@"10" forKey:@"pageSize"];
            [parameter setValue:@"98" forKey:@"querytype"];
        }
    }
//    DDLog(@"httpUrl:%@",httpUrl);
    if (_isNeedMB) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    STRONGSELF
    [ZYZCHTTPTool GET:httpUrl parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (_isNeedMB) {
            [MBProgressHUD hideHUDForView:self.view];
            _isNeedMB=NO;
        }
        [NetWorkManager hideFailViewForView:self.view];
//       DDLog(@"result：%@",result);
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
            
            _entryView.hidden=_listArr.count;
            
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
        if (_isNeedMB) {
            [MBProgressHUD hideHUDForView:self.view];
            _isNeedMB=NO;
        }
        _isNeedMB=YES;
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        [NetWorkManager getFailViewForView:self.view andFailResult:failResult andReFrashBlock:^{
            [strongSelf.table.mj_header beginRefreshing];
//            [strongSelf getHttpDataByFilterType:strongSelf.filterType andSeachKey:strongSelf.searchBar.text];
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
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"register_checkUserInfoIntegrality"]  andParameters:@{@"userId":[ZYZCAccountTool getUserId]} andSuccessGetBlock:^(id result, BOOL isSuccess)
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEPTION_LIVE_NOTIFICATION object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
     self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    _titleView.hidden   = YES ;
    _searchBar.hidden   = NO  ;
    _navRightBtn.hidden = NO  ;
    _navLeftBtn.hidden  = NO  ;
    [_table reloadData];
    // 收到直播通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receptionLiveNotification:) name:RECEPTION_LIVE_NOTIFICATION  object:nil];
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
