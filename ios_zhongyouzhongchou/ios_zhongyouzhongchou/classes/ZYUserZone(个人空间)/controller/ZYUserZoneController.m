//
//  ZYUserZoneController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYUserZoneController.h"
#import "ZYUserBottomBarView.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "ZYUserHeadView.h"
#import "ZYFootprintListView.h"
@interface ZYUserZoneController ()
@property (nonatomic, strong) ZYUserBottomBarView *bottomBarView;
@property (nonatomic, strong) UserModel           *userModel;
@property (nonatomic, assign) BOOL                friendship;
@property (nonatomic, assign) NSInteger           fansNumber;//粉丝数
@property (nonatomic, assign) NSInteger           friendNumber;//关注数

@property (nonatomic, strong) ZYUserHeadView       *userheadView;
@property (nonatomic, strong) ZYFootprintListView  *footprintListView;

@end

@implementation ZYUserZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackItem];
    [self configUI];
    [self getUserInfoData];
}

-(void)configUI
{
    _userheadView = [[ZYUserHeadView alloc]initWithUserZoomtype:OtherZoomType];
    [self.view addSubview:_userheadView];
    
    _bottomBarView= [[ZYUserBottomBarView alloc]initWithFrame:CGRectMake(0, KSCREEN_H-49, KSCREEN_W, 49)];
    [self.view addSubview:_bottomBarView];
    
    WEAKSELF;
    _bottomBarView.changeFansNumber=^(NSInteger fansNumber)
    {
        weakSelf.userheadView.fansNumber=fansNumber;
    };
}

#pragma mark --- 获取用户信息
-(void)getUserInfoData
{
    NSString *url=Get_SelfInfo([ZYZCAccountTool getUserId],_friendID);
    
    [MBProgressHUD showMessage:nil];
    
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         [MBProgressHUD hideHUD];
         [NetWorkManager hideFailViewForView:self.view];
         
         if (isSuccess) {
             self.friendship  = [result[@"data"][@"friend"] boolValue];
             self.friendNumber= [result[@"data"][@"meGzAll"] integerValue];
             self.fansNumber  = [result[@"data"][@"gzMeAll"] integerValue];
              self.userModel=[[UserModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
         }
         else
         {
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
