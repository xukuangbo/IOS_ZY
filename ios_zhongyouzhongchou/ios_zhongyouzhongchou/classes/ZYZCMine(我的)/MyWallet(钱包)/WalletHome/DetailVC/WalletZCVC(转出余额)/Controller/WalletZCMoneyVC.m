//
//  WalletZCMoneyVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletZCMoneyVC.h"
#import "WalletZCMoneyView.h"
@interface WalletZCMoneyVC ()
@property (nonatomic, strong) WalletZCMoneyView *moneyView;

@end

@implementation WalletZCMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _moneyView = [[[NSBundle mainBundle] loadNibNamed:@"WalletZCMoneyView" owner:nil options:nil] lastObject];
    [self.view addSubview:_moneyView];
    
    
}


@end
