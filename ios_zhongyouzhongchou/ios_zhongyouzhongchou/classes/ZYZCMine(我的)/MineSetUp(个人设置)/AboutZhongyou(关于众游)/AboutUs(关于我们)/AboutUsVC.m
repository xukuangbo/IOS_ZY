//
//  AboutXieyiVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) UILabel *titleLabel;
//
//@property (nonatomic, strong) UITextView *textView;
//
//@property (nonatomic, copy) NSString *textString;
@end

@implementation AboutUsVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor ZYZC_MainColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}
- (void)configUI
{
    [self setBackItem];
    
    
    //titleLabel
    CGFloat titleLabelW = 100;
    CGFloat titleLabelH = 40;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabelW, titleLabelH)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = @"关于我们";
    self.navigationItem.titleView = titleLabel;
    // 设置导航默认标题的颜色及字体大小
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]
//                                                                    };
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@about_us.jsp", [[ZYZCAPIGenerate sharedInstance] APIBaseUrl]]]];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
}


@end
