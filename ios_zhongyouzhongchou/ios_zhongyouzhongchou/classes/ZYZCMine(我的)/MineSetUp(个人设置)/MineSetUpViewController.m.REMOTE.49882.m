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
#import "MineTravelTagVC.h"
#import "WXApiManager.h"
@interface MineSetUpViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiManagerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (nonatomic, strong) WXApiManager      *wxManager;
@end

@implementation MineSetUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _wxManager=[WXApiManager sharedManager];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_back_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self calculateSize];
//    UITableViewCell  *loginCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//     ZYZCAccountModel *model = [ZYZCAccountTool account];
//    loginCell.textLabel.text=model?@"退出登录":@"登录";
//    loginCell.textLabel.textAlignment=NSTextAlignmentCenter;
}

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
            [_wxManager loginWeChatWithViewController:self];
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
        switch (indexPath.row) {
            case 0://个人信息
                NSLog(@"个人信息");
                [self.navigationController pushViewController:[[MinePersonSetUpController alloc] init] animated:YES];
                break;
            case 1://旅行标签
                NSLog(@"旅行标签");
                [self.navigationController pushViewController:[[MineTravelTagVC alloc] init] animated:YES];
                break;
            case 2://收货地址
                NSLog(@"收货地址");
                [self.navigationController pushViewController:[[MineSaveContactInfoVC alloc] init] animated:YES];
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0://清空缓存
                //这个是清空缓存的方法，弹出一个alert
                NSLog(@"清空缓存");
                [self presentClearCacheAlert];
                
                break;
            case 1:
                //打开众游链接
                NSLog(@"众游链接");
                
                break;
            case 2://帮助反馈
                NSLog(@"帮助反馈");
                
                break;
            default:
                break;
        }
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self loginOut];
    }
}

-(void)loginOut
{
    [ZYZCAccountTool deleteAccount];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:KUSER_ID];
    [user setObject:nil forKey:KUSER_MARK];
    [user setObject:nil forKey:KCHAT_TOKEN];
    [user synchronize];
    
    _wxManager.delegate=self;
    [_wxManager judgeAppGetWeChatLoginWithViewController:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(failLoginWeChat:) name:KWX_LOGIN_FAIL object:nil];
}


#pragma mark --- 从微信返回的回调方法，获取微信token
-(void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    NSString *url = GET_WX_TOKEN(response.code);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSLog(@"%@",result);
        //获取失败
        if (result[@"data"][@"errcode"]) {
            [_wxManager loginWeChatWithViewController:self];
            return ;
        }
        else
        {
            //获取成功，获取微信信息，并注册我们的平台
            ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"]];
            [_wxManager requstPersonalData:accountModel];
            
        }
        
    } andFailBlock:^(id failResult) {
        NSLog(@"%@",failResult);
    }];
}

-(void)failLoginWeChat:(NSNotification *)notify
{
    [_wxManager loginWeChatWithViewController:self];
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

//-(void)clearCache{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//        }
//    }
//    [[SDImageCache sharedImageCache] cleanDisk];
//
//}
//
//-(float)fileSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if([fileManager fileExistsAtPath:path]){
//        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
//        return size/1024.0/1024.0;
//    }
//    return 0;
//}



//-(float)folderSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    float folderSize;
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            folderSize +=[self fileSizeAtPath:absolutePath];
//        }
//        //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//        return folderSize;
//    }
//    return 0;
//}

@end
