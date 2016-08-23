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
@interface MineSetUpViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;

@end

@implementation MineSetUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_back_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressBack)];
    self.title = @"设置";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self calculateSize];
}

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        
    }else{
        
    }
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
