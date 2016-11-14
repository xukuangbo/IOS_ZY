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
#import "ZYJourneyLiveModel.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "ZYDownloadGiftImageModel.h"

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
    
    [self.personDataView.zhongchouButton addTarget:self action:@selector(clickZhongchouButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personDataView.attentionButton addTarget:self action:@selector(clickAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.personDataView.bannedSpeakButton.hidden = YES;
    
    //打赏界面
    self.dashangMapView = [[showDashangMapView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, self.contentView.top - showDashangMapViewH, showDashangMapViewW, showDashangMapViewH)];
    [self.view addSubview:self.dashangMapView];
}

- (void)initPersonData
{
    NSDictionary *params=@{@"productId":self.liveModel.productId};
   
    WEAKSELF
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getProductMinInfo"] andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
        ZYJourneyLiveModel *journeyLiveModel=[[ZYJourneyLiveModel alloc] mj_setKeyValues:result[@"data"]];
        weakSelf.journeyLiveModel = journeyLiveModel;
        [weakSelf.personDataView.zhongchouButton setTitle:weakSelf.journeyLiveModel.journeyTitle forState:UIControlStateNormal];
//        NSLog(@"resultresult%@", result);
    } andFailBlock:^(id failResult) {
//        NSLog(@"failResult%@", failResult);
    }];
}

#pragma mark - netWork
// 获取个人信息.获取个人中心数据
- (void)requestData:(NSString *)otherUserId
{
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *getUserInfoURL = [[ZYZCAPIGenerate sharedInstance] API:@"u_getUserDetail_action"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:userId forKey:@"selfUserId"];
    [parameter setValue:otherUserId forKey:@"userId"];
    
    WEAKSELF
    [ZYZCHTTPTool GET:getUserInfoURL parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
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
//    NSString *getUserInfoURL = Get_SelfInfo(userId, otherUserId);
//    WEAKSELF
//    [ZYZCHTTPTool getHttpDataByURL:getUserInfoURL withSuccessGetBlock:^(id result, BOOL isSuccess) {
//        if (isSuccess) {
//            NSDictionary *dic = (NSDictionary *)result;
//            NSDictionary *data = dic[@"data"];
//            if ([[NSString stringWithFormat:@"%@", data[@"friend"]] isEqualToString:@"1"]){
//                [weakSelf.personDataView.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
//            }
//            MinePersonSetUpModel  *minePersonModel=[[MinePersonSetUpModel alloc] mj_setKeyValues:data[@"user"]];
//            minePersonModel.gzMeAll = data[@"gzMeAll"];
//            minePersonModel.meGzAll = data[@"meGzAll"];
//            weakSelf.personDataView.minePersonModel = minePersonModel;
//        } else {
//            NSLog(@"bbbbbbb");
//        }
//    } andFailBlock:^(id failResult) {
//        NSLog(@"aaaaaaa");
//    }];
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
- (void)clickZhongchouButton
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
        NSString *unfollowUser = [[ZYZCAPIGenerate sharedInstance] API:@"friends_unfollowUser"];
        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:unfollowUser andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
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
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"friends_followUser"];

        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
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

// 点击打赏一起去
- (void)togetherGoUserContribution
{
    WEAKSELF
    NSDictionary *params=@{@"productId":[NSString stringWithFormat:@"%@", self.liveModel.productId],@"style4":[NSString stringWithFormat:@"%.1lf", self.journeyLiveModel.togetherGoMoney / 10000.0]};

    //判断时间是否有冲突，如果有则不可支持
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"list_checkMyProductsTime"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    [parameter setValue:self.liveModel.productId forKey:@"productId"];
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        //没有冲突
        if ([result[@"data"] isEqual:@1]) {
            WXApiManager *wxManager=[WXApiManager sharedManager];
            [wxManager payForWeChat:params payUrl:[[ZYZCAPIGenerate sharedInstance] API:@"weixinpay_generateAppOrder"] withSuccessBolck:nil andFailBlock:nil];
        }
        else if ([result[@"data"] isEqual:@0])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"此行程与已有行程时间冲突,不可支持一起游" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }

    } andFailBlock:^(id failResult) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
    }];
}

// 点击打赏回报
- (void)rewardUserContribution
{
    NSDictionary *params=@{@"productId":[NSString stringWithFormat:@"%@", self.liveModel.productId],@"style3":[NSString stringWithFormat:@"%.1lf", self.journeyLiveModel.rewardMoney / 10000.0]};
    
    WXApiManager *wxManager=[WXApiManager sharedManager];
    [wxManager payForWeChat:params payUrl:[[ZYZCAPIGenerate sharedInstance] API:@"weixinpay_generateAppOrder"] withSuccessBolck:nil andFailBlock:nil];
}

// 获取关联行程打赏结果
- (void)getUserContributionResultHttpUrl
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getOrderPayStatus"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:appDelegate.out_trade_no forKey:@"outTradeNo"];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        appDelegate.out_trade_no=nil;
        NSArray *arr=result[@"data"];
        NSDictionary *dic=nil;
        if (arr.count) {
            dic=[arr firstObject];
        }
        BOOL payResult=[[dic objectForKey:@"buyStatus"] boolValue];
        //支付成功
        if(payResult){
            NSDictionary *payDict = @{
                                      @"payHeaderUrl":[ZYZCAccountTool account].faceImg,
                                      @"payName":[ZYZCAccountTool account].realName,
                                      @"extra":[NSString stringWithFormat:@"打赏主播%@元", weakSelf.payMoney]
                                      };
            
            NSString *localizedMessage = [ZYZCTool turnJson:payDict];
            RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:localizedMessage];
            rcTextMessage.extra = kPaySucceed;
            [weakSelf sendMessage:rcTextMessage pushContent:nil];
            [MBProgressHUD showSuccess:@"打赏成功!"];
            //展示支付成功动画
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dashangMapView showDashangDataWithModelString:rcTextMessage.content];
            });
        } else {
            [MBProgressHUD showError:@"打赏失败!"];
        }
    } andFailBlock:^(id failResult) {
        appDelegate.out_trade_no=nil;
        [MBProgressHUD showError:@"网络出错,支付失败!"];
    }];
}

#pragma mark - animtion
- (void)showAnimtion:(NSString *)payType
{
    NSMutableArray *giftImageArray;
    for (int k = 0; k < self.giftImageArray.count; k++) {
        ZYDownloadGiftImageModel *model = self.giftImageArray[k];
        if ([model.price integerValue] == [payType integerValue] * 100) {
            giftImageArray = [NSMutableArray arrayWithArray:model.imageArray];
        }
    }
    int arc4randomNumber = arc4random() % 270 + 100;
    int arc4randomWidth = arc4random() % 50;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(arc4randomWidth, KSCREEN_H - arc4randomNumber * 16 / 9, arc4randomNumber, arc4randomNumber * 16 / 9)];
    [self.view addSubview:imageView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *cacheImagePath = [NSString stringWithFormat:@"%@/cacheImagePath%d", documentpath, [payType intValue] * 100];
    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSInteger j;
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i < giftImageArray.count + 5; i++) {
        j = i;
        if (i > giftImageArray.count) {
            j = giftImageArray.count;
        }
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%ld", cacheImagePath, j]];
        if (image) {
            [imgArray addObject:image];
        }
    }
    //把存有UIImage的数组赋给动画图片数组
    imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    imageView.animationDuration = (giftImageArray. count + 5 ) * 0.1;
    //动画重复次数 （0为重复播放）
    imageView.animationRepeatCount = 1;
    //开始播放动画
    [imageView startAnimating];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showAnimtion:payType imageNumber:number];
//    });
}
@end
