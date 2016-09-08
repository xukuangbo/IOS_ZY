//
//  ZYFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintController.h"
#import <objc/runtime.h>
#import "ZYPublishFootprintController.h"
#import "HUImagePickerViewController.h"
@interface ZYFootprintController ()

@end

@implementation ZYFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackItem];
    self.title=@"足迹";
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 100, 40);
    [btn setTitle:@"发布足迹" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor orangeColor];
    btn.center=self.view.center;
    [btn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

-(void)publish:(UIButton *)sender
{
    
    WEAKSELF
    //创建UIAlertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //    选择众游图库
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        ZYPublishFootprintController *publishFootprintController=[[ZYPublishFootprintController alloc]init];
        [weakSelf.navigationController pushViewController:publishFootprintController animated:YES];
    }];
    //选择本地相册
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    //选择拍照
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [cancelAction setValue:[UIColor ZYZC_MainColor]    forKey:@"_titleTextColor"];
    [videoAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    [albumAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    [photoAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    
    [alertController addAction:cancelAction];
    [alertController addAction:videoAction];
    [alertController addAction:albumAction];
    [alertController addAction:photoAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
