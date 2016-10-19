//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//
#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "ZYZCAccountModel.h"

typedef void(^GetOrderSuccess)();
typedef void(^GetOrderFail)();

@protocol WXApiManagerDelegate <NSObject>

@optional


- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;


- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *weChatAlert;

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;


/**
 *  微信支付
 *  @param dict 支付金额（字典形式）
 */

- (void) payForWeChat:(NSDictionary *)dict payUrl:(NSString *)payUrl withSuccessBolck:(GetOrderSuccess) getOrderSuccess andFailBlock:(GetOrderFail)getOrderFail;

/**
 *  分享网页
 *  @param thumbImage 图片网址
 */
- (void) shareScene:(int)scene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(NSString *)thumbImage andWebUrl:(NSString *)webUrl;

/**
 *  分享视频
 */
- (void)shareToWeChatWithScene:(int)scene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(UIImage *)thumbImage andVideoUrl:(NSString *)videoUrl;





@end
