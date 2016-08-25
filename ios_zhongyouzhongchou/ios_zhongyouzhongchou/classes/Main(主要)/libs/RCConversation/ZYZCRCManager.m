//
//  RCManager.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCRCManager.h"
#import "ChatListViewController.h"
#import "ZYZCConversationController.h"
#import <RongIMKit/RCConversationViewController.h>
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "UserModel.h"
#import "MBProgressHUD+MJ.h"
static ZYZCRCManager *_RCManager;

@interface ZYZCRCManager()<UIAlertViewDelegate, RCIMUserInfoDataSource>

@end


@implementation ZYZCRCManager

+(instancetype )defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (!_RCManager) {
            _RCManager=[[ZYZCRCManager alloc]init];
        }
    });
    return _RCManager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//微信登陆成功后获取token并保存，如果退出登陆记得将token清除
#pragma mark --- 获取融云的Token
-(void)getRCloudToken
{
    ZYZCAccountModel *model = [ZYZCAccountTool account];
    if (model.userId) {
        NSString *utf8Str=[model.realName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url=GET_CHAT_TOKEN(model.userId,utf8Str,model.faceImg);
//      NSString *url=GET_CHAT_TOKEN02(model.userId,utf8Str,model.headimgurl);

//        NSLog(@"获取token的url：%@",url);
        [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
            DDLog(@"chatToken:%@",result);
            if (isSuccess) {
                NSDictionary *dic=[ZYZCTool turnJsonStrToDictionary:result[@"data"][@"result"]];
                if ([dic[@"code"] isEqual:@200])
                {
                    NSString *token=dic[@"token"];
                    
                    //获取token后保存到本地
                    [ZYZCAccountTool saveRCloudToken:token];
                    
                    //登录融云
                    [self loginRongCloudSuccess:nil orFail:nil];
                }
            }
        } andFailBlock:^(id failResult) {
            
        }];
    }
}


//进入app或微信登陆后执行这个方法
#pragma mark --- 登陆融云
- (void)loginRongCloudSuccess:(LoginSuccess ) loginSuccess orFail:(LoginFail)loginFail
{
    //如果没有登录app
    if (![ZYZCAccountTool getUserId]) {
        if (loginFail) {
            loginFail();
        }
        return;
    }
    //在 App 整个生命周期，您只需要调用一次此方法与融云服务器建立连接
    if (_hasLogin) {
        //已登陆
        //执行登陆后操作
        if (loginSuccess) {
            loginSuccess();
        }
        return;
    }
    
    //未登录进行登陆操作
    NSString *myToken=[ZYZCAccountTool getRCloudToken];
    if (!myToken) {
        [self getRCloudToken];
        //如果myToken不存在，获取token
        return;
    }
    
//    NSLog(@"myToken:%@",myToken);
    [[RCIM sharedRCIM] connectWithToken:myToken success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        _hasLogin=YES;
        if (loginSuccess) {
            loginSuccess();
        }
        
        
        DDLog(@"Login successfully with userId: %@.", userId);
        
    } error:^(RCConnectErrorCode status) {
//        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
//        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
}

#pragma amrk ---代理方法
/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
//    NSLog(@"融云userid:%ld",[userId integerValue]);
//    NSLog(@"myUserId:%ld",[[ZYZCAccountTool getUserId] integerValue]);
    //如果是自己的userid直接获取
//    if ([userId integerValue]==[[ZYZCAccountTool getUserId] integerValue]) {
//        ZYZCAccountModel *model = [ZYZCAccountTool account];
//        RCUserInfo *user = [[RCUserInfo alloc]init];
//        user.userId = [NSString stringWithFormat:@"%@",model.userId];
//        user.name = model.nickname;
//        user.portraitUri = model.headimgurl;
//        return completion(user);
//    }
//    else
    {
        
        //根据userId获取用户信息
        NSString *url=GET_USERINFO_BYOPENID(userId);
        [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess)
        {
//            NSLog(@"%@",result);
            if(isSuccess)
            {
                UserModel *userModel=[[UserModel alloc]mj_setKeyValues:result[@"data"]];
                //将聊天的用户信息提供到融云上
                RCUserInfo *newUser = [[RCUserInfo alloc]init];
                newUser.userId = [userModel.userId stringValue];
                newUser.name = userModel.realName?userModel.realName:userModel.userName;
                newUser.portraitUri = userModel.faceImg;
                return completion(newUser);
            }
        }
        andFailBlock:^(id failResult)
        {
            
        }];
    }
}

#pragma mark ---直接进入聊天界面
/**
 *  单聊
 *
 *  @param targetId       聊天的对象id
 *  @param viewController 推出聊天界面的控制器
 */
-(void)connectTarget:(NSString *)targetId andTitle:(NSString *)title andSuperViewController:(UIViewController *)viewController
{
    [self loginRongCloudSuccess:^{
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            ZYZCConversationController  *conversationVC = [[ZYZCConversationController alloc]init];
            conversationVC.hidesBottomBarWhenPushed=YES;
            conversationVC.conversationType =ConversationType_PRIVATE;
            conversationVC.targetId = targetId;
            conversationVC.title = title;
            [viewController.navigationController pushViewController:conversationVC animated:YES];
        });
    }
    orFail:^{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"未登录，此项不可操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma mark --- 获取会话列表
-(void)getMyConversationListWithSupperController:(UIViewController *)viewContrroller
{
    [self loginRongCloudSuccess:^{
//        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatListViewController *chatListViewController = [[ChatListViewController alloc]init];
            chatListViewController.hidesBottomBarWhenPushed=YES;
            if ([viewContrroller isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)viewContrroller pushViewController:chatListViewController animated:YES];
            }
            else{
             [viewContrroller.navigationController pushViewController:chatListViewController animated:YES];
            }
        });
    }
    orFail:^{
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"未登录，此项不可操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
        }];
}

@end
