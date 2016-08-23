//
//  AboutXieyiVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AboutTousuVC.h"

@interface AboutTousuVC ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AboutTousuVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
        
    }
    return self;
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:1]];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:0]];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//}

- (void)configUI
{
    [self setBackItem];
    
    CGFloat titleLabelW = 100;
    CGFloat titleLabelH = 40;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabelW, titleLabelH)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = @"投诉须知";
    self.navigationItem.titleView = titleLabel;
    
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Get_Tousu]];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}


@end
