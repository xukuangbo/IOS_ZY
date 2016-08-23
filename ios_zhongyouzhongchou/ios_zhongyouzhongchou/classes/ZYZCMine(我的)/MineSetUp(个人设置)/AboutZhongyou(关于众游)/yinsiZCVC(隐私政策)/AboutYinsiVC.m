//
//  AboutXieyiVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AboutYinsiVC.h"

@interface AboutYinsiVC ()

@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) UILabel *titleLabel;
//
//@property (nonatomic, strong) UITextView *textView;
//
//@property (nonatomic, copy) NSString *textString;
@end

@implementation AboutYinsiVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
        
        //        [self requestData];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)configUI
{
    [self setBackItem];
    
    CGFloat titleLabelW = 100;
    CGFloat titleLabelH = 40;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabelW, titleLabelH)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = @"隐私条款";
    self.navigationItem.titleView = titleLabel;
    
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    //正文
    //    _textView = [[UITextView alloc] init];
    //    _textView.backgroundColor = [UIColor clearColor];
    //    _textView.left = KEDGE_DISTANCE;
    //    _textView.top = KEDGE_DISTANCE;
    //    _textView.height = KSCREEN_H - _textView.top - KEDGE_DISTANCE;
    //    _textView.width = KSCREEN_W - 2 * KEDGE_DISTANCE;
    //    //    _titleLabel.backgroundColor = [UIColor redColor];
    //    _textView.textColor = [UIColor ZYZC_TextGrayColor];
    //    _textView.textAlignment = NSTextAlignmentLeft;
    //    _textView.font = [UIFont systemFontOfSize:17];
    //    [self.view addSubview:_textView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Get_Yinsi_ZhengChe]];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}

//- (void)requestData
//{
//    __weak typeof(&*self) weakSelf = self;
//    [ZYZCHTTPTool getHttpDataByURL:Get_Xieyi withSuccessGetBlock:^(id result, BOOL isSuccess) {
//        if (isSuccess) {//请求成功
//            [weakSelf reloadString:result];
//        }
//
//        NSLog(@"%@",result);
//    } andFailBlock:^(id failResult) {
//
//    }];
//}
//
//- (void)reloadString:(NSDictionary *)result
//{
//    _textString = result[@"data"];
//    
//    _textView.text = _textString;
//}
@end
