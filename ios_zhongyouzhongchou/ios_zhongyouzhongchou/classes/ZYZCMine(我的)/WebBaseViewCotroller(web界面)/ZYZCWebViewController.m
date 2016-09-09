//
//  ZYZCWebViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCWebViewController.h"

@interface ZYZCWebViewController () <UIWebViewDelegate, UIScrollViewDelegate>
{
    UIWebView *_adWebView;
    
    NSString *_urlString;
    
}
@end

@implementation ZYZCWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _urlString = urlString;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    webView.scalesPageToFit = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    webView.delegate = self;
    webView.allowsInlineMediaPlayback = YES;
    webView.scrollView.delegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:webView];
    _adWebView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConstraints];
    [self setBackItem];

    // load data
    [self loadUrlRequest];
}

- (void)setupConstraints
{
    [_adWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadUrlRequest
{
    if (_urlString) {
        NSURL *url = [[NSURL alloc] initWithString:_urlString];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [_adWebView loadRequest:urlRequest];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _adWebView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//#pragma mark - UIWebviewDelegate
//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //    NSLog(@"请求");
    return YES;
}
//
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //
    //    NSLog(@"开始");
}

//
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

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
