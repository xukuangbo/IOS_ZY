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
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *bgImageView;

@end

@implementation ZYPublishFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
    [self configNavUI];
    [self configBodyUI];
}

-(void)configNavUI
{
    //navUI
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    navView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:navView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleLab.text=@"添加足迹";
    titleLab.textColor=[UIColor ZYZC_TextBlackColor];
    titleLab.font=[UIFont systemFontOfSize:20];
    titleLab.centerX=navView.centerX;
    [navView addSubview:titleLab];
    
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 20, 50, 44);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [backBtn  addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(KSCREEN_W-60, 20, 50, 44);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(publishMyFootprint) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:publishBtn];
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, navView.height-1, KSCREEN_W, 1) andColor:[UIColor lightGrayColor]];
    [navView addSubview:lineView];
}

-(void)configBodyUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_W, KSCREEN_H-64)];
    _scrollView.contentSize=CGSizeMake(0, _scrollView.height+1);
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:_scrollView];
    
    _bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, _scrollView.width-2*KEDGE_DISTANCE, 300)];
    _bgImageView.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    [_scrollView addSubview:_bgImageView];
    
    
    
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---  发布足迹👣
-(void)publishMyFootprint
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",[self class]);
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
