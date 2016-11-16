//
//  MineSetUpViewController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MineSetUpViewController.h"
#import "MinePersonSetUpController.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MBProgressHUD+MJ.h"
#import "MineSaveContactInfoVC.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "LoginJudgeTool.h"
#import "AboutZhongyouVC.h"
#import "CertificationVC.h"
@interface MineSetUpViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiManagerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (nonatomic, strong) WXApiManager      *wxManager;
- (IBAction)sixinTSAction:(id)sender;
- (IBAction)sixinZhendonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginButton;
@end

@implementation MineSetUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:1]];
    _wxManager=[WXApiManager sharedManager];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_back_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    self.title = @"设置";
    
    //判断账号，然后显示登录或者退出按钮
    [self showLoginButton];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    BOOL openSound=YES;
    BOOL openShake=YES;
    if([user objectForKey:KOPEN_SOUND_ALERT])
    {
        openSound=[[user objectForKey:KOPEN_SOUND_ALERT] boolValue];
    }
    if ([user objectForKey:KOPEN_SHAKE_ALERT]) {
        openShake=[[user objectForKey:KOPEN_SHAKE_ALERT] boolValue];
    }
    _soundSwitch.on=openSound;
    _shakeSwitch.on=openShake;
    
 }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self calculateSize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  展示登录或者退出账号按钮
 */
- (void)showLoginButton
{
    NSString *userId=[ZYZCAccountTool getUserId];
    if (!userId) {//无账号
        _loginButton.text = @"登录";
        
        return;
        
    }else{//有账号
        _loginButton.text = @"退出账号";
    }
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        ZYZCAccountModel *model = [ZYZCAccountTool account];
        if (model) {//登录了
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否退出登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];
        }else//没登录
        {
//            [_wxManager judgeAppGetWeChatLoginWithViewController:self];
        }

        return;
    }
    
    //当选中的时候就会调用
    ZYZCAccountModel *model = [ZYZCAccountTool account];
    if (model) {//登录了
        
    }else//没登录
    {
        [MBProgressHUD setAnimationDuration:2];
        [MBProgressHUD showError:@"请先登录后设置"];
        
        return;
    }
    
    //在这里实现各种方法
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
//            NSLog(@"个人信息");
            MinePersonSetUpController *personVC = [[MinePersonSetUpController alloc] init];
            personVC.wantFZC = NO;
            [self.navigationController pushViewController:personVC animated:YES];
            
            return ;
        }else if (indexPath.row == 1){
            //                NSLog(@"收货地址");
            [self.navigationController pushViewController:[[MineSaveContactInfoVC alloc] init] animated:YES];
            return ;
        }else if (indexPath.row == 2){
            //                NSLog(@"实名认证");
            [self.navigationController pushViewController:[[CertificationVC alloc] init] animated:YES];
            return ;
        }else{
            
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0://清空缓存
                //这个是清空缓存的方法，弹出一个alert
//                NSLog(@"清空缓存");
                [self presentClearCacheAlert];
                
                break;
            case 1:
                //打开关于众游
//                NSLog(@"关于众游");
                
                [self.navigationController pushViewController:[[AboutZhongyouVC alloc] init] animated:YES];
                break;
            default:
                break;
        }
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self loginOut];
    }

}

-(void)loginOut
{
    [ZYZCAccountTool deleteAccount];
    
    [LoginJudgeTool judgeLogin];
}


/**
 *  弹出清楚缓存内容
 */
- (void)presentClearCacheAlert
{
    __weak typeof(&*self) weakSelf = self;
    NSString *chcheSize = [NSString stringWithFormat:@"缓存大小为%.1f M，确认清除?",[SDImageCache sharedImageCache].getSize /1024.0/1024.0];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:chcheSize preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf clearCache];
        [weakSelf calculateSize];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 文件相关操作
- (void)calculateSize
{
    CGFloat cacheSize = [SDImageCache sharedImageCache].getSize /1024.0/1024.0;
    _cacheSize.text = [NSString stringWithFormat:@"%.1f M",cacheSize];
}

-(void)clearCache{
    [[SDImageCache sharedImageCache] clearDisk];
}

- (IBAction)sixinTSAction:(id)sender {
    UISwitch *switchUI = (UISwitch *)sender;
    DDLog(@"%d",switchUI.on);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithBool:switchUI.on] forKey:KOPEN_SOUND_ALERT];
    [user synchronize];
    
}

- (IBAction)sixinZhendonAction:(id)sender {
    UISwitch *switchUI = (UISwitch *)sender;
    DDLog(@"%d",switchUI.on);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithBool:switchUI.on] forKey:KOPEN_SHAKE_ALERT];
    [user synchronize];
}
@end
