//
//  ZYWatchLiveViewController+LivePersonView.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYWatchLiveViewController+LivePersonView.h"
#import "LivePersonDataView.h"
#import "ZCProductDetailController.h"
//#import "ZYZCPersonalController.h"
#import "ZYUserZoneController.h"
#import "MinePersonSetUpModel.h"
#import "MBProgressHUD+MJ.h"
#import "showDashangMapView.h"
#import "ChatBlackListModel.h"
#import "ZYLiveListModel.h"
@implementation ZYWatchLiveViewController (LivePersonView)
- (void)initLivePersonDataView
{
    //添加个人信息view
    CGFloat personDataViewW = 230;
    CGFloat personDataViewH = 340;
    CGFloat personDataViewX = (self.view.width - personDataViewW) * 0.5;
    CGFloat personDataViewY = self.view.height;
    self.personDataView = [[LivePersonDataView alloc] initWithFrame:CGRectMake(personDataViewX, personDataViewY, personDataViewW, personDataViewH)];
    [self.personDataView.zhongchouButton setTitle:self.liveModel.productTitle forState:UIControlStateNormal];

//    [self.personDataView.zhongchouButton setTitle:self.createLiveModel.productTitle forState:UIControlStateNormal];
    [self.view addSubview:self.personDataView];
    
    [self.personDataView.roomButton addTarget:self action:@selector(clickEnterRoomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personDataView.zhongchouButton addTarget:self action:@selector(clickZhongchouButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personDataView.attentionButton addTarget:self action:@selector(clickAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.personDataView.bannedSpeakButton.hidden = YES;
    
    //打赏界面
    self.dashangMapView = [[showDashangMapView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, self.contentView.top - showDashangMapViewH, showDashangMapViewW, showDashangMapViewH)];
    [self.view addSubview:self.dashangMapView];
}

- (void)initPersonData
{
    
}

#pragma mark - netWork
// 获取个人信息.获取个人中心数据
- (void)requestData:(NSString *)otherUserId
{
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *getUserInfoURL = Get_SelfInfo(userId, otherUserId);
    WEAKSELF
    [ZYZCHTTPTool getHttpDataByURL:getUserInfoURL withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            NSDictionary *dic = (NSDictionary *)result;
            NSDictionary *data = dic[@"data"];
            if ([[NSString stringWithFormat:@"%@", data[@"friend"]] isEqualToString:@"1"]){
                [weakSelf.personDataView.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            MinePersonSetUpModel  *minePersonModel=[[MinePersonSetUpModel alloc] mj_setKeyValues:data[@"user"]];
            minePersonModel.gzMeAll = data[@"gzMeAll"];
            minePersonModel.meGzAll = data[@"meGzAll"];
            weakSelf.personDataView.minePersonModel = minePersonModel;
        } else {
            NSLog(@"bbbbbbb");
        }
    } andFailBlock:^(id failResult) {
        NSLog(@"aaaaaaa");
    }];
}

#pragma mark - event
// 展示个人头像
- (void)showPersonDataImage:(UITapGestureRecognizer *)sender
{
    ChatBlackListModel *user = self.userList[sender.view.tag - 1000];
    [self.personDataView showPersonData];
    
    if ([user.userId intValue] == [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] == 0) {
        self.personDataView.attentionButton.hidden = YES;
        [self.personDataView showTravelNull];
        [self.personDataView setHeight:258];
    } else if ([user.userId intValue] == [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] != 0) {
        self.personDataView.attentionButton.hidden = YES;
        [self.personDataView showTravelNoNull];
        [self.personDataView setHeight:298];
    } else if ([user.userId intValue] != [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] == 0) {
        self.personDataView.attentionButton.hidden = NO;
        [self.personDataView setHeight:300];
        [self.personDataView showTravelNull];
    } else if ([user.userId intValue] != [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] != 0) {
        self.personDataView.attentionButton.hidden = NO;
        [self.personDataView setHeight:340];
        [self.personDataView showTravelNoNull];
    }
    [self requestData:[NSString stringWithFormat:@"%@", user.userId]];
}

- (void)showPersonData
{
    [self.personDataView showPersonData];
    [self requestData:[NSString stringWithFormat:@"%@", self.liveModel.userId]];
    if ([self.liveModel.userId intValue] == [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] == 0) {
        self.personDataView.attentionButton.hidden = YES;
        [self.personDataView showTravelNull];
        [self.personDataView setHeight:258];
    } else if ([self.liveModel.userId intValue] == [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] != 0) {
        self.personDataView.attentionButton.hidden = YES;
        [self.personDataView showTravelNoNull];
        [self.personDataView setHeight:298];
    } else if ([self.liveModel.userId intValue] != [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] == 0) {
        self.personDataView.attentionButton.hidden = NO;
        [self.personDataView setHeight:300];
        [self.personDataView showTravelNull];
    } else if ([self.liveModel.userId intValue] != [[ZYZCAccountTool getUserId] intValue] && [self.liveModel.productId length] != 0) {
        self.personDataView.attentionButton.hidden = NO;
        [self.personDataView setHeight:340];
        [self.personDataView showTravelNoNull];
    }

}
// 进入个人空间界面
- (void)clickEnterRoomButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
 
    ZYUserZoneController *userZoneController=[[ZYUserZoneController alloc]init];
    userZoneController.hidesBottomBarWhenPushed=YES;
    userZoneController.friendID=[NSNumber numberWithInteger:[self.personDataView.minePersonModel.userId intValue]];
    [self.navigationController pushViewController:userZoneController animated:YES];
}

// 进入众筹详情
- (void)clickZhongchouButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    //推出信息详情页
    ZCProductDetailController *productDetailVC=[[ZCProductDetailController alloc]init];
    productDetailVC.hidesBottomBarWhenPushed=YES;
    //    ZCOneModel *oneModel=self.dataArr[indexPath.row/2];
    //    productDetailVC.oneModel=oneModel;
    productDetailVC.productId = [NSNumber numberWithInteger:[self.liveModel.productId integerValue]];
    productDetailVC.detailProductType=PersonDetailProduct;
    productDetailVC.fromProductType=ZCListProduct;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

// 点击关注按钮
- (void)clickAttentionButton:(UIButton *)sender
{
    WEAKSELF
    NSDictionary *params=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":self.personDataView.minePersonModel.userId};
    if ([self.personDataView.attentionButton.titleLabel.text isEqualToString:@"取消关注"]) {
        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:UNFOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
             if (isSuccess) {
                 [MBProgressHUD showSuccess:@"取消成功"];
                 [weakSelf.personDataView.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
             } else {
                 [MBProgressHUD showSuccess:@"取消失败"];
             }
         }andFailBlock:^(id failResult) {
             [MBProgressHUD showSuccess:@"取消失败"];
         }];
        
    } else {
        //添加关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:FOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
            //            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"关注成功"];
                [weakSelf.personDataView.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [MBProgressHUD showSuccess:@"关注失败"];
            }
        } andFailBlock:^(id failResult) {
            [MBProgressHUD showSuccess:@"关注失败"];
        }];
    }
}

@end
