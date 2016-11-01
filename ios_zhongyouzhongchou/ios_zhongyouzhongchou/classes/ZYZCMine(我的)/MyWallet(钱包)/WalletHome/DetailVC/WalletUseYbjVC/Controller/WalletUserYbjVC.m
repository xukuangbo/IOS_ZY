//
//  WalletUserYbjVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletUserYbjVC.h"
#import "WalletProductView.h"
@interface WalletUserYbjVC ()

@end

@implementation WalletUserYbjVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackItem];
    
    [self requestData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_BgGrayColor]];
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor01];
    WalletProductView *view = [[WalletProductView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, 300)];
    view.centerY = self.view.centerY;
    [self.view addSubview:view];
    
    
}

#pragma mark - requestData
- (void)requestData
{
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getMyLastProduct"];
    MJWeakSelf
    //    data = {
    //        productTitle = Hehe,
    //        productId = 121
    //    },
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:nil andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSString *title = result[@"data"][@"productTitle"];
        NSString *productID = result[@"data"][@"productId"];
//        if (title) {
//            weakSelf.guanlianView.hidden = NO;
//            weakSelf.guanlianProductID = productID;
//            weakSelf.guanlianView.travelLabel.text = title;
//        }else{
//            weakSelf.guanlianView.hidden = YES;
//        }
    } andFailBlock:^(id failResult) {
        
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
