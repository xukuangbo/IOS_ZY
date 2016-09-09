//
//  ZYZCLiveStartController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCLiveStartController.h"
//#import "ZYZCLiveController.h"
#import <QPSDKCore/QPSDKCore.h>
#import "MBProgressHUD+MJ.h"
//正式
#define kQPDomain @"http://zhongyoulive.s.qupai.me"
//测试
//#define kQPDomain @"http://duanqulive.s.qupai.me"

@interface ZYZCLiveStartController ()
@property (nonatomic,copy  ) NSString *pushUrl;
@property (nonatomic,copy  ) NSString *pullUrl;

@end

@implementation ZYZCLiveStartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"直播";
    [self setBackItem];
    //进入直播按钮
    UIButton *enterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.center=self.view.center;
    enterBtn.bounds=CGRectMake(0, 0, 80, 40);
    enterBtn.backgroundColor=[UIColor orangeColor];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterLive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
}

#pragma mark --- 进入直播
-(void)enterLive
{
    QPLiveRequest *request = [[QPLiveRequest alloc] init];
    [request requestCreateLiveWithDomain:kQPDomain success:^(NSString *pushUrl, NSString *pullUrl) {
        NSLog(@"create live success");
        NSLog(@"pushUrl : %@", pushUrl);
        NSLog(@"pullUrl : %@", pullUrl);
        //进入直播
//        ZYZCLiveController *liveController=[[ZYZCLiveController alloc]init];
//        liveController.pushUrl=pushUrl;
//        liveController.pullUrl=pullUrl;
//        [weakSelf createLiveData:pullUrl];
//        [weakSelf presentViewController:liveController animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"create live failed %@", error);
    }];
}

- (void)createLiveData:(NSString *)pullUrl
{
    NSString *url = Post_Create_Live;
    NSDictionary *parameters = @{
                                 @"img" : @"http://cc.cocimg.com/api/uploads/20150610/1433903549371622.jpg",
                                 @"title" : @"直播",
                                 @"pullUrl" : pullUrl
                                 };
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
          
        }else{
//
        }
    } andFailBlock:^(id failResult) {
        
    }];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
