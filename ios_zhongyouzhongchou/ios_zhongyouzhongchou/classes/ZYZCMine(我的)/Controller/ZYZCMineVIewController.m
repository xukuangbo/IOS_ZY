//
//  ZYZCMineVIewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCMineVIewController.h"
#import "PersonHeadView.h"
#import "UserModel.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MineTableViewCell.h"
#import "MineSetUpViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCMessageListViewController.h"
#import "ZYZCRCManager.h"
#import "UITabBarItem+WZLBadge.h"
#import "UIBarButtonItem+WZLBadge.h"
#import <RongIMKit/RongIMKit.h>

@interface ZYZCMineVIewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) PersonHeadView *personHeadView;
@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) UILabel        *titleLab;
@property (nonatomic, strong) UserModel      *userModel;
@property (nonatomic, assign) BOOL           hasGetUserData;
@property (nonatomic, assign) int            count;
@end

@implementation ZYZCMineVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItems];
    [self configUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfoData) name:@"userInfoChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnReadChatMsgCount:) name:RCKitDispatchMessageNotification object:nil];
}

#pragma mark --- 收到消息的回调

-(void)getUnReadChatMsgCount:(NSNotification *)notify
{
    RCIMClient *rcIMClient=[RCIMClient sharedRCIMClient];
    _count = [rcIMClient getTotalUnreadCount];
    
        __weak typeof (&*self)weakSelf=self;
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [weakSelf.table reloadData];
                       });
}


-(void)setNavItems
{
    
    _titleLab =[[UILabel alloc]initWithFrame:CGRectMake((self.view.width-200)/2, 0, 200, 44)];
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont boldSystemFontOfSize:20];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:_titleLab];
    
    
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:@"btn_set" andAction:@selector(leftButtonClick)];
    
   
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.size = CGSizeMake(25, 25);
    [messageButton setImage:[UIImage imageNamed:@"btn_pas_ld"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
}

-(void)configUI
{
    UIView *navBgView=[[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:navBgView];
    
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W,KSCREEN_H-49) style:UITableViewStylePlain];
    _table.dataSource=self;
    _table.delegate=self;
    _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _table.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    _table.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_table];
    
    _personHeadView=[[PersonHeadView alloc]initWithType:YES];
    _table.tableHeaderView=_personHeadView;
//    MJRefreshHeader *refreshHeader=[MJRefreshHeader headerWithRefreshingBlock:^{
//        [self getUserInfoData];
//    }];
//    _table.mj_header=refreshHeader;
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DDLog(@"indexPath.row:%ld",indexPath.row);
    if (indexPath.row==1) {
        NSString *cellId=@"mineCell";
        MineTableViewCell *mineCell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!mineCell) {
            mineCell=[[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        mineCell.myBadgeValue=_count;
        
        return mineCell;
    }
    else
    {
        NSString *cellId01=@"normalCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId01];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId01];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor ZYZC_BgGrayColor];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
         return MINE_CELL_HEIGHT;
    }
    else
    {
        return KEDGE_DISTANCE;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY=scrollView.contentOffset.y;
//        NSLog(@"%f",offsetY);
        _personHeadView.tableOffSetY=offsetY;
  
    if (offsetY>=80*KCOFFICIEMNT+10) {
        NSString *name=_userModel.realName?_userModel.realName:_userModel.userName;
        _titleLab.text=name.length>8?[name substringToIndex:8]:name;
    }
    else
    {
        _titleLab.text=nil;
    }
    
    if (offsetY>5) {
        _table.bounces=YES;
    }
    else
    {
        _table.bounces=NO;
    }
}

#pragma mark --- 设置
-(void)leftButtonClick
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MineSetUpVC" bundle:nil];
    MineSetUpViewController *mineSetUpViewController = [board instantiateViewControllerWithIdentifier:@"MineSetUpViewController"];
    mineSetUpViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineSetUpViewController animated:YES];
}

#pragma mark --- 消息
-(void)rightButtonClick
{
    DDLog(@"消息");
    ZYZCMessageListViewController *msgController=[[ZYZCMessageListViewController alloc]init];
    msgController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:msgController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _titleLab.hidden=NO;
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    if (!_hasGetUserData) {
         [self getUserInfoData];
    }
    
    //获取未读消息数
    RCIMClient *rcIMClient=[RCIMClient sharedRCIMClient];
    _count = [rcIMClient getTotalUnreadCount];
    [_table reloadData];
    
    //清除tabbar上的消息提示红点
    if (_count==0) {
        UITabBarItem *item = [self.tabBarController.tabBar.items lastObject];
        [item clearBadge];
    }

    
    
    //系统消息
    [ZYZCAccountTool getUserUnReadMsgCount:^(NSInteger count) {
        if (count>0) {
            [self.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:count animationType:WBadgeAnimTypeNone];
        }
        else
        {
            [self.navigationItem.rightBarButtonItem clearBadge];
        }
    }];
    
}

#pragma mark --- 获取个人信息
-(void)getUserInfoData
{
//    [MBProgressHUD showMessage:@"正在注册" toView:self.view];
    NSString *userId=[ZYZCAccountTool getUserId];
    if (!userId) {
        [_personHeadView cleanUI];
        [MBProgressHUD hideHUDForView:self.view];
        return;
        
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url=[NSString stringWithFormat:@"%@selfUserId=%@&userId=%@",GETUSERDETAIL,[ZYZCAccountTool getUserId],userId];
//    NSLog(@"%@",url);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
//         NSLog(@"%@",result);
         if (isSuccess) {
             _hasGetUserData=YES;
             _personHeadView.hiddenLoginBtn=YES;
             _userModel=[[UserModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
             _personHeadView.meGzAll=result[@"data"][@"meGzAll"];
             _personHeadView.gzMeAll=result[@"data"][@"gzMeAll"];
             _personHeadView.userModel=_userModel;
         }
         [MBProgressHUD hideHUDForView:self.view];
     } andFailBlock:^(id failResult) {
//         NSLog(@"%@",failResult);
         [MBProgressHUD hideHUDForView:self.view];
     }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    _titleLab.hidden=YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
