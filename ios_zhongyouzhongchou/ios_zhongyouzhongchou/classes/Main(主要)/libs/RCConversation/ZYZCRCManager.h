//
//  RCManager.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RongIMKit/RongIMKit.h>

typedef void (^LoginSuccess)();//登陆后操作

typedef void (^LoginFail)();//登陆失败后操作

//typedef void (^GetTokenResult)(BOOL isSuccess);//获取token成功后操作

@interface ZYZCRCManager : NSObject

//如果用户退出登陆，记得将haslogin置为no
@property (nonatomic, assign) BOOL hasLogin;//记录是否已经登陆过

+(instancetype )defaultManager;

/**
 *  获取token
 */
-(void)getRCloudToken;

/**
 *  登陆融云
 */
- (void)loginRongCloudSuccess:(LoginSuccess ) loginSuccess orFail:(LoginFail)loginFail;

/**
 *  获取会话列表
 */
-(void)getMyConversationListWithSupperController:(UIViewController *)viewContrroller;

/**
 *  单聊
 */
-(void)connectTarget:(NSString *)targetId andTitle:(NSString *)title andSuperViewController:(UIViewController *)viewController;


@end
