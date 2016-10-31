//
//  WalletYbjBottomBar.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WalletYbjBottomBarH 50

@interface WalletYbjBottomBar : UIView

@property (nonatomic, strong) UILabel *moneyNumberLabel;

@property (nonatomic, strong) UIButton *commitButton;

- (void)changeUIWithDic:(NSMutableDictionary *)dic;

- (void)clearData;
@end
