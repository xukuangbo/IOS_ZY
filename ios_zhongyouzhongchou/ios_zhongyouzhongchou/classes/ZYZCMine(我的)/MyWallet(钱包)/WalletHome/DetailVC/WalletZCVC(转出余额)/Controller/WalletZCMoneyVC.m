//
//  WalletZCMoneyVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletZCMoneyVC.h"
#import "WalletZCMoneyView.h"
#import "RACEXTScope.h"
@interface WalletZCMoneyVC ()
@property (nonatomic, strong) WalletZCMoneyView *moneyView;

@end

@implementation WalletZCMoneyVC
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
    
    [self setBackItem];
    
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    _moneyView = [[[NSBundle mainBundle] loadNibNamed:@"WalletZCMoneyView" owner:nil options:nil] lastObject];
    _moneyView.frame = self.view.bounds;
    _moneyView.kzcMoney = self.kzcMoney;
    [self.view addSubview:_moneyView];
    
    [self addNotis];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)addNotis{
    //    键盘弹出
    [ZYNSNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘收起
    [ZYNSNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 通知
- (void)keyboardWillShow:(NSNotification *)noti {
    
    // 键盘的Y值
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardH = value.CGRectValue.size.height;
    
    // 动画
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    DDLog(@"%f",self.view.bottom);
    @weakify(self);
    [UIView animateWithDuration:duration.doubleValue animations:^{
        @strongify(self);
        //获取到的位置很怪,暂时用全屏位置
        self.moneyView.bottom = KSCREEN_H - KNAV_HEIGHT - keyboardH;
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    // 键盘的Y值
    NSDictionary *userInfo = [noti userInfo];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    DDLog(@"%f,%f",self.view.bottom,self.moneyView.bottom);
    [UIView animateWithDuration:duration.doubleValue animations:^{
         self.moneyView.bottom = KSCREEN_H - KStatus_Height - KNAV_HEIGHT;
    }];
}

@end
