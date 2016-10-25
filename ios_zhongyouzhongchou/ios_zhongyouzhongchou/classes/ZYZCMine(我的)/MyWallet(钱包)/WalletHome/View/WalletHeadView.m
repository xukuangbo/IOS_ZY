//
//  WalletHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletHeadView.h"
#import "Masonry.h"
@interface WalletHeadView ()
/* 转出余额 */
@property (nonatomic, strong) UIButton *ZCMoneyButton;
/* 钱包余额标题 */
@property (nonatomic, strong) IBOutlet UILabel *balanceTitleLabel;
/* 钱包余额 */
@property (nonatomic, strong) IBOutlet UILabel *balanceLabel;
/* 灰色虚线 */
@property (nonatomic, strong) IBOutlet UIView *lineView;
/* U币标题 */
@property (nonatomic, strong) IBOutlet UILabel *UBTitleLabel;
/* U币 */
@property (nonatomic, strong) IBOutlet UILabel *UBLabel;

@end

@implementation WalletHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 256.0 green:arc4random_uniform(256) / 256.0 blue:arc4random_uniform(256) / 256.0 alpha:1];
        
        [self setUpSubviews];
        
        [self setUpConstraints];
    }
    return self;
}


- (void)setUpSubviews
{
//    _ZCMoneyLabel = [[UILabel alloc] init];
//    _balanceTitleLabel = [[UILabel alloc] init];
//    _balanceLabel = [[UILabel alloc] init];
//    _lineView = [[UIView alloc] init];
//    _UBTitleLabel = [[UILabel alloc] init];
//    _UBLabel = [[UILabel alloc] init];
//    
//    [self addSubview:_ZCMoneyLabel];
//    [self addSubview:_balanceTitleLabel];
//    [self addSubview:_balanceLabel];
//    [self addSubview:_lineView];
//    [self addSubview:_UBTitleLabel];
//    [self addSubview:_UBLabel];
    
    // 还可增设间距
    _ZCMoneyButton = [ZYZCTool getCustomBtnByTilte:@"更多" andImageName:@"btn_rig_mor" andtitleFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor ZYZC_TextGrayColor04] andSpacing:2];
    [self addSubview:_ZCMoneyButton];
    
    
}

- (void)setUpConstraints
{
    [_ZCMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
        make.top.equalTo(self).offset(KEDGE_DISTANCE);
        make.right.equalTo(self.mas_right).offset(-KEDGE_DISTANCE);
    }];
}
@end
