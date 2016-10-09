//
//  ZYZCConversationController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCConversationController.h"
#import "UINavigationBar+Background.h"
#import "ComplainTypeController.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
@interface ZYZCConversationController ()

@end

@implementation ZYZCConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.conversationMessageCollectionView.backgroundColor=[UIColor whiteColor];
}

#pragma mark --- 进入投诉页面
-(void)complain
{
    ComplainTypeController *complainContriller=[[ComplainTypeController alloc]init];
    complainContriller.targetId=self.targetId;
    [self.navigationController pushViewController:complainContriller animated:YES];
}

#pragma mark --- 添加到拉黑
- (void)addto_Lahei_List
{
    //获取是否拉黑的状态
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.targetId success:^(int bizStatus) {
        
//        NSLog(@"%zd",bizStatus);
        
        if (bizStatus == 0) {//在黑名单中
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showShortMessage:@"已在黑名单中"];
            });
            
            return ;
            
        }else{//不再黑名单中
            
            //添加到拉黑列表
            [[RCIMClient sharedRCIMClient] addToBlacklist:self.targetId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showSuccess:@"拉黑成功"];
                });
                
            } error:^(RCErrorCode status) {
                
//                NSLog(@"失败了%zd",status);
                
            }];
            
        }
    } error:^(RCErrorCode status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD showSuccess:@"网络出错"];
        });
        
    }];
    
}


#pragma mark ---返回

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    //处于聊天列表中
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.enterChatList=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //退出聊天列表
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.enterChatList=NO;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---右上角3个点的点击效果
- (void)showGerenCaozuoAlert
{
    __weak typeof(&*self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *tousu_Action = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf complain];
    }];
    UIAlertAction *lahei_Action = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addto_Lahei_List];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:tousu_Action];
    [alertController addAction:lahei_Action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_back_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_r"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showGerenCaozuoAlert)];
}


@end
