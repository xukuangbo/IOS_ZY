//
//  ZYZCTestModeViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCTestModeViewController.h"
#import "LoginJudgeTool.h"
#import "ZYZCTestModeManager.h"
@interface ZYZCTestModeViewController ()

@end

@implementation ZYZCTestModeViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupview];
    [self setBackItem];
    // Do any additional setup after loading the view.
}

#pragma mark - setup
- (void)setupview
{
    NSArray *buttonTitle = [NSArray arrayWithObjects:@"设置为正式服务器", @"设置为测试服务器", @"设置为海外服务器", @"设置为华子服务器", nil];
    for (int i = 0; i < 4; i++) {
        UIButton *testServerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        testServerButton.tag = 100 + i;
        testServerButton.backgroundColor = [UIColor ZYZC_MainColor];
        testServerButton.layer.masksToBounds = YES;
        testServerButton.layer.cornerRadius = 4;
        testServerButton.frame = CGRectMake(50 , 120 + 60 * i, KSCREEN_W - 50 * 2, 40);
        [testServerButton setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [testServerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        testServerButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [testServerButton addTarget:self action:@selector(testServerButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:testServerButton];
    }
}

#pragma mark - event
- (void)testServerButtonEvent:(UIButton *)sender
{
    [ZYZCTestModeManager setServerStatus:sender.tag - 100];
    [ZYZCAPIGenerate sharedInstance].serverType = sender.tag - 100;
    [ZYZCAccountTool deleteAccount];
    [LoginJudgeTool judgeLogin];
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
