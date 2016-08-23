//
//  TacticSingleViewController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticSingleViewController.h"
#import "TacticSingleFoodModel.h"
#import "TacticSingleTipsModel.h"
#import "TacticSingleTableViewCell.h"
#import "TacticCustomMapView.h"
#import "TacticCityHeadView.h"
#import "TacticCountryHeadView.h"
#import "TacticSingleModelFrame.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MBProgressHUD+MJ.h"
#import "ZCListModel.h"
#import "ZYZCOneProductCell.h"
#import "LoginJudgeTool.h"
#import "ZCProductDetailController.h"
#import "TacticMoreJieshaoVC.h"
#import "NetWorkManager.h"
#import "WXApiShare.h"
#import "TacticGoXXTravelCell.h"
@interface TacticSingleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TacticSingleModelFrame *tacticSingleModelFrame;

@property (nonatomic, strong) NSMutableArray *zhongchouArray;

@property (nonatomic, weak) UIButton *sureButton;

@property (nonatomic,assign) BOOL isWantGo;
@property (nonatomic,assign) int pageNo;
@property (nonatomic,copy  ) NSString  *destName;

@property (nonatomic, strong) UIButton           *scrollTop;//置顶

//@property (nonatomic, strong) MoreJieshaoModel *jieshaoModel;
@end



@implementation TacticSingleViewController
#pragma mark - system方法
- (instancetype)initWithViewId:(NSInteger)viewId
{
    self = [super init];
    if (self) {
        self.viewId = viewId;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _zhongchouArray=[NSMutableArray array];
    _pageNo=1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     *  设置导航栏
     */
    [self setUpNavi];
    /**
     *  创建tableView
     */
    [self createTableView];
    /**
     *  创建底部工具条
     */
    [self createBottomBar];
    
    /**
     *  刷新数据
     */
    [self refreshDataWithViewId:self.viewId];
    
    
    [self requestWantGoWithViewId:_viewId];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self scrollViewDidScroll:self.tableView];
}
#pragma mark - set方法
- (TacticSingleModelFrame *)tacticSingleModelFrame
{
    if(!_tacticSingleModelFrame){
        _tacticSingleModelFrame = [[TacticSingleModelFrame alloc] init];
    }
    return _tacticSingleModelFrame;
}

- (void)setIsWantGo:(BOOL)isWantGo
{
    _isWantGo = isWantGo;
    if (isWantGo == YES) {//已关注
        [_sureButton setTitle:ZYLocalizedString(@"isWantGo") forState:UIControlStateNormal];
    }else{
        [_sureButton setTitle:ZYLocalizedString(@"wantGo") forState:UIControlStateNormal];
    }
}

#pragma mark - configUI方法
/**
 *  设置导航栏
 */
- (void)setUpNavi
{
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(0)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    [self setBackItem];
    
    
    //判断是否安装微信
    if (![WXApi isWXAppInstalled] ||![WXApi isWXAppSupportApi]) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.size = CGSizeMake(25, 25);
        [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        
        [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    }else{
        //不创建按钮
    }
    
    
}
/**
 *  创建tableView
 */
- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 5, 0) ;
    
    __weak typeof(&*self) weakSelf = self;
    MJRefreshAutoNormalFooter *autoFooter=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.destName) {
            weakSelf.pageNo++;
            [weakSelf Get_Dest_ZhongChou_List:weakSelf.destName];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    
    [autoFooter setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer=autoFooter;

    
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

#pragma mark --- 置顶
-(void)scrollToTop
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

/**
 *  创建底部工具条
 */
- (void)createBottomBar
{
    UIView *bottomBar = [[UIView alloc] init];
    [bottomBar addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, KSCREEN_W, 1) andColor:[UIColor lightGrayColor]]];
    bottomBar.size = CGSizeMake(KSCREEN_W, 49);
    bottomBar.left = 0;
    bottomBar.bottom = KSCREEN_H;
    bottomBar.backgroundColor=[UIColor ZYZC_TabBarGrayColor];
    [self.view addSubview:bottomBar];
    CGFloat btn_width = KSCREEN_W/2;
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(btn_width * 0.5, 0, btn_width, bottomBar.height);
    [sureBtn setTitle:ZYLocalizedString(@"wantGo") forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [sureBtn addTarget:self action:@selector(wantToGoAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:sureBtn];
    self.sureButton = sureBtn;
}


#pragma mark --- 分享
-(void)shareButton
{
    __weak typeof (&*self)weakSelf=self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *shareToZoneAction = [UIAlertAction actionWithTitle:@"分享到微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            [weakSelf shareToFriendScene:YES];
                                        }];
    
    UIAlertAction *shareToFriendAction = [UIAlertAction actionWithTitle:@"分享到微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                          {
                                              [weakSelf shareToFriendScene:NO];
                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:shareToZoneAction];
    [alertController addAction:shareToFriendAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)shareToFriendScene:(BOOL)isFriendScene
{
    NSString *url= [NSString stringWithFormat:@"http://www.sosona.com/view?id=%ld&type=%ld",(long)self.viewId,(long)self.tacticSingleModelFrame.tacticSingleModel.viewType];
    NSString *imgURL = KWebImage(self.tacticSingleModelFrame.tacticSingleModel.min_viewImg);
    
    [WXApiShare shareScene:isFriendScene withTitle:@"风景目的地" andDesc:[NSString stringWithFormat:@"%@是个好地方,希望大家多去观光",self.tacticSingleModelFrame.tacticSingleModel.name] andThumbImage:imgURL andWebUrl:url];
}
#pragma mark - requsetData方法
/**
 *  请求目的地详情
 */
- (void)refreshDataWithViewId:(NSInteger)viewId
{
    if (_tacticSingleModel) {
        self.tacticSingleModelFrame.tacticSingleModel = _tacticSingleModel;
        [self.tableView reloadData];
        return;
    }
    
    NSString *url = GET_TACTIC_VIEW(viewId);
//    NSLog(@"%@",url);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [NetWorkManager hideFailViewForView:weakSelf.view];
        if (isSuccess) {
            
            [weakSelf handleResult:result];
            
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [NetWorkManager hideFailViewForView:weakSelf.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf refreshDataWithViewId:viewId];
        }];
    }];
    
}

- (void)handleResult:(NSDictionary *)result
{
    TacticSingleModel *tacticSingleModel = [TacticSingleModel mj_objectWithKeyValues:result[@"data"]];
    self.tacticSingleModelFrame.tacticSingleModel = tacticSingleModel;
    
    //这里获取到到名字数据后，再去访问众筹项目列表
//    NSLog(@"%@",tacticSingleModel.name);
    if (tacticSingleModel.viewType == 1) {
        _destName = tacticSingleModel.name;
        [self Get_Country_ZhongChou_List:_destName];
    }else if (tacticSingleModel.viewType == 2) {
        _destName=tacticSingleModel.name;
        [self Get_Dest_ZhongChou_List:tacticSingleModel.name];
    }
    else
    {
        [self.tableView reloadData];
    }
}

#pragma mark ---获取想去数据
- (void)requestWantGoWithViewId:(NSInteger)viewId
{

    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *url = Get_Tactic_Status_WantGo(userId, self.viewId);
//    NSLog(@"%@",url);
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.isWantGo = [result[@"data"] intValue];
        }
    } andFailBlock:^(id failResult) {
        
    }];
    
}

- (void)wantToGoAction:(UIButton *)button
{
    NSString *userId = [ZYZCAccountTool getUserId];
//    ZYZCAccountModel *accountModel = [ZYZCAccountTool account];
    __weak typeof(&*self) weakSelf = self;
    if (!userId) {//没有账号
        [MBProgressHUD showError:@"请登录后再点击"];
    }else{
        if(_isWantGo == NO){//加关注
            NSString *wantGoUrl = Add_Tactic_WantGo(userId, self.viewId);
//            NSLog(@"%@",wantGoUrl);
            [ZYZCHTTPTool getHttpDataByURL:wantGoUrl withSuccessGetBlock:^(id result, BOOL isSuccess) {
                [MBProgressHUD showSuccess:ZYLocalizedString(@"add_spot_success")];
                //改文字
                weakSelf.isWantGo = YES;
                
            } andFailBlock:^(id failResult) {
                [MBProgressHUD showError:ZYLocalizedString(@"add_spot_fail")];
            }];
            
        }else{//取关
            NSString *wantGoUrl = Del_Tactic__WantGo(userId, self.viewId);
            [ZYZCHTTPTool getHttpDataByURL:wantGoUrl withSuccessGetBlock:^(id result, BOOL isSuccess) {
                [MBProgressHUD showSuccess:ZYLocalizedString(@"del_spot_success")];
                //改文字
//                [self.sureButton setTitle:@"想去" forState:UIControlStateNormal];
                
                weakSelf.isWantGo = NO;
            } andFailBlock:^(id failResult) {
                [MBProgressHUD showError:ZYLocalizedString(@"del_spot_fail")];
            }];
            
        }
    }
}

#pragma mark ---Get_Country_ZhongChou_List
- (void)Get_Country_ZhongChou_List:(NSString *)country
{
    NSString *destStr = [country stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",Get_Dest_ZhongChou_List(1,destStr));
    __weak typeof(&*self) weakSelf = self;
    ;
    NSLog(@"%@",Get_Country_ZhongChou_List(_pageNo,destStr));
    [ZYZCHTTPTool getHttpDataByURL:Get_Country_ZhongChou_List(_pageNo,destStr) withSuccessGetBlock:^(id result, BOOL isSuccess) {
        //
        if (isSuccess) {
            if (weakSelf.pageNo==1&&weakSelf.zhongchouArray.count) {
                [_zhongchouArray removeAllObjects];
            }
            ZCListModel *listModel = [ZCListModel mj_objectWithKeyValues:result];
            for(ZCOneModel *oneModel in listModel.data)
            {
                oneModel.productType=ZCListProduct;
                [weakSelf.zhongchouArray addObject:oneModel];
            }
            
            if (listModel.data.count==0) {
                weakSelf.pageNo--;
            }
        }
        //回主线程更新UI
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        //如果请求不到照样更新UI
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    }];
}

#pragma mark ---Get_Dest_ZhongChou_List
- (void)Get_Dest_ZhongChou_List:(NSString *)dest
{
    NSString *destStr = [dest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@",Get_Dest_ZhongChou_List(1,destStr));
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool getHttpDataByURL:Get_Dest_ZhongChou_List((long)_pageNo,destStr) withSuccessGetBlock:^(id result, BOOL isSuccess) {
//        
            if (isSuccess) {
                if (weakSelf.pageNo==1&&weakSelf.zhongchouArray.count) {
                    [_zhongchouArray removeAllObjects];
                }
                ZCListModel *listModel = [ZCListModel mj_objectWithKeyValues:result];
                for(ZCOneModel *oneModel in listModel.data)
                {
                    oneModel.productType=ZCListProduct;
                    [weakSelf.zhongchouArray addObject:oneModel];
                }
                
                if (listModel.data.count==0) {
                    weakSelf.pageNo--;
                }
            }
        //回主线程更新UI
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        

    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        //如果请求不到照样更新UI
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    }];
}

#pragma mark - UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_zhongchouArray.count > 0) {
        
        return 1 + _zhongchouArray.count*2 + 2;//后面的2是用来放标题的
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *ID = @"TacticSingleTableViewCell";
        TacticSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[TacticSingleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        //这里进行模型的赋值
        cell.tacticSingleModelFrame = self.tacticSingleModelFrame;
        return cell;
    }else if (indexPath.row == 1){
        TacticGoXXTravelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TacticGoXXTravelCell"];
        if (!cell) {
            cell = [[TacticGoXXTravelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TacticGoXXTravelCell"];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"去%@的旅行",self.tacticSingleModelFrame.tacticSingleModel.name];
        return cell;
    }else if (indexPath.row == 2){
        UITableViewCell *normalCell=[ZYZCBaseTableViewCell createNormalCell];
        return normalCell;
    }
    else{
        //众筹项目
        if (indexPath.row%2==1) {
            ZYZCOneProductCell *oneProductCell=(ZYZCOneProductCell *)[ZYZCOneProductCell customTableView:tableView cellWithIdentifier:@"productCell" andCellClass:[ZYZCOneProductCell class]];
            oneProductCell.oneModel.productType=ZCListProduct;
            oneProductCell.oneModel=self.zhongchouArray[(indexPath.row-3)/2];
            return oneProductCell;
        }
        //灰色线条
        else
        {
            UITableViewCell *normalCell=[ZYZCBaseTableViewCell createNormalCell];
            return normalCell;
        }
    }
}

#pragma mark - UITableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TacticSingleHeadViewHeight;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    //进行判断，是国家还是城市
    if (self.tacticSingleModelFrame.tacticSingleModel.viewType == 1) {
        TacticCountryHeadView *headView = [[TacticCountryHeadView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, TacticSingleHeadViewHeight)];
        
        //国家
        headView.flagImageName.text = self.tacticSingleModelFrame.tacticSingleModel.name;
        [headView sd_setImageWithURL:[NSURL URLWithString:KWebImage(self.tacticSingleModelFrame.tacticSingleModel.viewImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        [headView.flagImage sd_setImageWithURL:[NSURL URLWithString:KWebImage(self.tacticSingleModelFrame.tacticSingleModel.countryImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        
        return headView;
    }else if (self.tacticSingleModelFrame.tacticSingleModel.viewType == 2) {
        
        TacticCityHeadView *headView = [[TacticCityHeadView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, TacticSingleHeadViewHeight)];
        
        //添加渐变条
        UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
        bgImg.image=[UIImage imageNamed:@"Background"];
        [headView addSubview:bgImg];
        
        headView.nameLabel.text = self.tacticSingleModelFrame.tacticSingleModel.name;
       
        [headView sd_setImageWithURL:[NSURL URLWithString:KWebImage(self.tacticSingleModelFrame.tacticSingleModel.viewImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        [headView.flagImage sd_setImageWithURL:[NSURL URLWithString:KWebImage(self.tacticSingleModelFrame.tacticSingleModel.countryImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        headView.flagImageName.text = self.tacticSingleModelFrame.tacticSingleModel.country;
        return headView;
        
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        //判断是否登录
        BOOL loginResult=[LoginJudgeTool judgeLogin];
        if (!loginResult) {
            return;
        }
        //推出信息详情页
        ZCProductDetailController *productDetailVC=[[ZCProductDetailController alloc]init];
        productDetailVC.detailProductType=PersonDetailProduct;
        productDetailVC.hidesBottomBarWhenPushed=YES;
        ZCOneModel *oneModel=self.zhongchouArray[(indexPath.row-3)/2];
        productDetailVC.oneModel=oneModel;
        productDetailVC.oneModel.productType=ZCDetailProduct;
        productDetailVC.productId=oneModel.product.productId;
        productDetailVC.detailProductType=PersonDetailProduct;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return self.tacticSingleModelFrame.realHeight;
    }else if (indexPath.row == 1){
        return TacticGoXXTravelCellRowHeight;
    }else if (indexPath.row == 2){
        return KEDGE_DISTANCE;
    }
    else
    {
        if (indexPath.row%2==1) {
            return PRODUCT_CELL_HEIGHT;
        }
        else
        {
            return KEDGE_DISTANCE;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

/**
 *  navi背景色渐变的效果
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"contentY:%.2f",offsetY);
    if (offsetY <= oneViewMapHeight) {
        CGFloat alpha = MAX(0, offsetY/oneViewMapHeight);
        
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(alpha)];
        self.title = @"";
    } else {
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
        if (self.tacticSingleModelFrame) {
            self.title = self.tacticSingleModelFrame.tacticSingleModel.name;
        }
    }
    
    if (scrollView==self.tableView) {
        CGFloat offSetY=scrollView.contentOffset.y;
        if (offSetY>=800.0) {
            _scrollTop.hidden=NO;
        }
        else
        {
            _scrollTop.hidden=YES;
        }
    }
}

- (void)dealloc{
    
}


@end
