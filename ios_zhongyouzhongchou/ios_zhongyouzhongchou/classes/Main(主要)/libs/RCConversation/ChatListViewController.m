//
//  ChatListViewController.m
//  RongCloudDemo
//
//  Created by 杜立召 on 15/4/18.
//  Copyright (c) 2015年 dlz. All rights reserved.
//

#import "ChatListViewController.h"
#import "ZYZCConversationController.h"
#import "UINavigationBar+Background.h"
#import "ChatBlackListVC.h"
#import "EntryPlaceholderView.h"
#import "AppDelegate.h"
@interface ChatListViewController ()

@end

@implementation ChatListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"私信列表";
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_back_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    
    UIButton *lahei_List_Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    lahei_List_Btn.frame=CGRectMake(0, 0, 60, 44);
    //    [lahei_List_Btn setTitle:@"投诉" forState:UIControlStateNormal];
    [lahei_List_Btn setTitle:@"黑名单" forState:UIControlStateNormal];
    [lahei_List_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lahei_List_Btn addTarget:self action:@selector(pushToLaheiListVC) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:lahei_List_Btn];
    
    
    EntryPlaceholderView *emptyView=[EntryPlaceholderView viewWithFrame:self.view.bounds type:EntryTypeSixin];
//    emptyView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"abc"]];
    self.emptyConversationView=emptyView;
    
    self.conversationListTableView.tableFooterView = [UIView new];
    
    
}

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---推送到黑名单列表
- (void)pushToLaheiListVC
{
    ChatBlackListVC *blackListVC = [[ChatBlackListVC alloc] init];

    [self.navigationController pushViewController:blackListVC animated:YES];

}

/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    ZYZCConversationController *conversationVC = [[ZYZCConversationController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"会话";
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



/**
 *  退出登录
 *
 *  @param sender <#sender description#>
 */
- (void)leftBarButtonItemPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alertView show];
}

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender <#sender description#>
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    ZYZCConversationController *conversationVC = [[ZYZCConversationController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = @"oulbuvolvV8uHEyZwU7gAn8icJFw"; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
    conversationVC.title = @"聊天";
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
//        [[RCIM sharedRCIM]disconnect];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end