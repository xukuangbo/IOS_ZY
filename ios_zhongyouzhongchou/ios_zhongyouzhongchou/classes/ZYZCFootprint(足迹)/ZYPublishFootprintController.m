//
//  ZYPublishFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYPublishFootprintController.h"
#import <objc/runtime.h>
#import "HUImagePickerViewController.h"
@interface ZYPublishFootprintController ()

@end

@implementation ZYPublishFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackItem];
    self.title=@"添加足迹";
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor ZYZC_TextBlackColor]};
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_BgGrayColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
    
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(0, 0, 50, 30);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishMyFootprint) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:publishBtn];
}

-(void)publishMyFootprint
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];

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
