//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#define LIMIT_STYLE3_ALERT  @"回报支持已达上限，不可支持该选项"

#define HAS_STYLE3_ALERT    @"您已参与了回报支持，不可再次参与"

#define HAS_STYLE4_ALERT    @"您已参与了一起游支持，不可再次参与"

#define FAIL_NETWORK        @"网络错误，支持失败"

#import "WXApiManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCRCManager.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
//            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
//            [_delegate managerDidRecvMessageResponse:messageResp];
//        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }
    
    //支付结果回调
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                NSNotification *notification = [NSNotification notificationWithName:KORDER_PAY_NOTIFICATION object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default: {
                NSNotification *notification = [NSNotification notificationWithName:KORDER_PAY_NOTIFICATION object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

//======================================================
#pragma mark --- 微信支付
-(void )payForWeChat:(NSDictionary *)dict withSuccessBolck:(GetOrderSuccess) getOrderSuccess andFailBlock:(GetOrderFail)getOrderFail
{
//        post
//        {
//        openid: string  // 微信用户openid
//        ip: string // 用户ip
//        productId: number   // 众筹项目id
//        style1: number      // 支持1元 不传为未选择
//        style2: number      // 支持任意金额的钱数 不传为未选择
//        style3: number      // 回报支持一钱数   不传为未选择
//        style4: number       // 一起去支付的钱数   不传为未选择
//        style5: number       // 回报支持二钱数   不传为未选择
//        }
    
    ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:dict];
    [params setObject:accountModel.userId forKey:@"userId"];
    [params setObject:@"127.0.0.1" forKey:@"ip"];// ip不知道是干嘛用的
    
//    NSLog(@"%@",params);
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:GET_WX_ORDER  andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
//        NSLog(@"result:%@",result);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        if([result[@"code"] isEqual:@1])
        {
            [self showSupportFailAlertWithTitle:result[@"errorMsg"]];
        }
        else if([result[@"code"] isEqual:@0])
        {
            if (getOrderSuccess) {
                getOrderSuccess();
            }
            if ([params[@"style1"] floatValue]+[params[@"style2"] floatValue]+[params[@"style3"] floatValue]+[params[@"style4"] floatValue]==0.0) {
                
                [MBProgressHUD showSuccess:@"支持成功!"];
                
                //通知支持一起游成功
                [[NSNotificationCenter defaultCenter]postNotificationName:@"support_Style4_Success" object:nil];
            }
            else
            {
                //调用支付
                PayReq *request = [[PayReq alloc] init];
                /** 商家向财付通申请的商家id */
                NSDictionary *data=[ZYZCTool turnJsonStrToDictionary:result[@"data"]];
                request.openID    = data[@"appid"];
                request.partnerId = data[@"partnerid"];
                request.prepayId  = data[@"prepayid"];
                request.package   = data[@"package"];
                request.nonceStr  = data[@"noncestr"];
                request.timeStamp = [data[@"timestamp"] intValue];
                request.sign      = data[@"sign"];
                [WXApi sendReq: request];
                AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.out_trade_no=data[@"out_trade_no"];
            }
        }
        
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        [self showSupportFailAlertWithTitle:FAIL_NETWORK];
    }];
}

#pragma mark --- 生成订单失败提示
-(void)showSupportFailAlertWithTitle:(NSString *)title
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支持失败" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];

}

@end
