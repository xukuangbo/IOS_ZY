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
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
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
-(void )payForWeChat:(NSDictionary *)dict payUrl:(NSString *)payUrl withSuccessBolck:(GetOrderSuccess)getOrderSuccess andFailBlock:(GetOrderFail)getOrderFail
{

    //如果没有安装微信/不能支持微信API，则提示
    if (![WXApi isWXAppInstalled]||![WXApi isWXAppSupportApi]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支持失败" message:@"未安装微信或微信版本过低" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:dict];
    [params setObject:accountModel.userId forKey:@"userId"];
    [params setObject:@"127.0.0.1" forKey:@"ip"];// ip不知道是干嘛用的
    
//    NSLog(@"%@",params);
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:payUrl  andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
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
            if ((params[@"style1"] || params[@"style2"] || params[@"style3"])&&([params[@"style1"] floatValue]+[params[@"style2"] floatValue]+[params[@"style3"] floatValue]+[params[@"style4"] floatValue]==0.0)) {
                
                [MBProgressHUD showSuccess:@"支持成功!"];
                
                //通知支持一起游成功
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Support_Style4_ZeroYuan_Success" object:nil];
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

#pragma mark --- 微信分享
- (void) shareScene:(int)scene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(NSString *)thumbImage andWebUrl:(NSString *)webUrl
{
    WXMediaMessage *message=[WXMediaMessage message];
    message.title=title;
    message.description=description;
    //图片不能大于32k
    if (!thumbImage) {
        [message setThumbImage:[UIImage imageNamed:@"Share_iocn"]];
    }
    else{
        if ([thumbImage hasSuffix:@"/0"]) {
            thumbImage=[thumbImage stringByReplacingCharactersInRange:NSMakeRange(thumbImage.length-2, 2) withString:@"/132"];
        }
        
        NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImage]];
        
        UIImage *sourceimage=[UIImage imageWithData:imgData];
        UIImage *compressImage=[ZYZCTool compressSourceImage:sourceimage underLength:32 withPlaceHolderImage:[UIImage imageNamed:@"Share_iocn"]];

        [message setThumbImage:compressImage];
    }
    WXWebpageObject *webpageObject=[WXWebpageObject object];
    webpageObject.webpageUrl=webUrl;
    message.mediaObject=webpageObject;
    SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
    req.bText=NO;
    req.message=message;
    req.scene=scene;
    [WXApi sendReq:req];
}

#pragma mark ---分享视频
- (void)shareToWeChatWithScene:(int)scene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(UIImage *)thumbImage andVideoUrl:(NSString *)videoUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"Share_iocn"]];
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = videoUrl;
    videoObject.videoLowBandUrl = videoObject.videoUrl;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText=NO;
    req.message = message;
    req.scene =scene;
    [WXApi sendReq:req];
}

#pragma mark --- 生成订单失败提示
-(void)showSupportFailAlertWithTitle:(NSString *)title
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支持失败" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];

}

@end
