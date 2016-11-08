//
//  WalletYbjBottomBar.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletYbjBottomBar.h"
#import "Masonry.h"
#import "UIView+ZYLayer.h"
@implementation WalletYbjBottomBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews
{
    self.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    _moneyNumberLabel = [[UILabel alloc] init];
    _moneyNumberLabel.font = [UIFont systemFontOfSize:20];
    _moneyNumberLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _moneyNumberLabel.text = @"0.00";
    
    _commitButton = [[UIButton alloc] init];
    [_commitButton setTitle:@"确认选择" forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_commitButton setTitleColor:[UIColor ZYZC_TextGrayColor04] forState:UIControlStateNormal];
    [_commitButton setBackgroundColor:[UIColor ZYZC_LineGrayColor]];
    [_commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    _commitButton.layerCornerRadius = 5;
    _commitButton.enabled = NO;
    
    [self addSubview:_moneyNumberLabel];
    [self addSubview:_commitButton];
    
    [_moneyNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-KEDGE_DISTANCE);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(@(38));
    }];
}


- (void)changeUIWithDic:(NSMutableDictionary *)dic
{
    NSArray *array = [dic allKeys];
    if (array.count == 0) {
        self.moneyNumberLabel.text = @"0.00";
        [_commitButton setTitleColor:[UIColor ZYZC_TextGrayColor04] forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:[UIColor ZYZC_LineGrayColor]];
        _commitButton.enabled = NO;
        
    }else{
        NSArray *moneyArray = [dic allValues];
        CGFloat floatMoney = 0;
        for (NSString *string in moneyArray) {
            floatMoney += [string floatValue];
        }
        
        self.moneyNumberLabel.text = [NSString stringWithFormat:@"%.2f",floatMoney];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:[UIColor ZYZC_MainColor]];
        _commitButton.enabled = YES;
    }
}


- (void)clearData
{
    _moneyNumberLabel.text = @"0.00";
    [_commitButton setTitleColor:[UIColor ZYZC_TextGrayColor04] forState:UIControlStateNormal];
    [_commitButton setBackgroundColor:[UIColor ZYZC_LineGrayColor]];
}

#pragma mark - clickAction
- (void)commitAction
{
    self.walletYbjBottomBarSelectBlock();
}
@end
