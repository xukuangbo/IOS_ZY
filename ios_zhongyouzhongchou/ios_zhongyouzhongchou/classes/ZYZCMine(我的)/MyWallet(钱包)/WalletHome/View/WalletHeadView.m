//
//  WalletHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletHeadView.h"
#import "Masonry.h"
#import "ZYCustomBlurView.h"
@interface WalletHeadView ()

/* 模糊背景图*/
@property (nonatomic, strong) ZYCustomBlurView *blurImageView;
/* 转出余额 */
@property (nonatomic, strong) UIButton *ZCMoneyButton;
/* 钱包余额标题 */
@property (nonatomic, strong) UILabel *balanceTitleLabel;
/* 钱包余额 */
@property (nonatomic, strong) UILabel *balanceLabel;
/* 灰色虚线 */
@property (nonatomic, strong) UIView *lineView;
/* U币标题 */
@property (nonatomic, strong) UILabel *UBTitleLabel;
/* U币 */
@property (nonatomic, strong) UILabel *UBLabel;

@end

@implementation WalletHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubviews];
        
        [self setUpConstraints];
    }
    return self;
}


- (void)setUpSubviews
{
    
    //模糊背景
    _blurImageView = [[ZYCustomBlurView alloc] initWithFrame:self.bounds andBlurEffectStyle:UIBlurEffectStyleExtraLight andBlurColor:[UIColor ZYZC_MainColor] andBlurAlpha:0.2 andColorAlpha:0.8];
    _blurImageView.image = [UIImage imageNamed:@"head"];
    [self addSubview:_blurImageView];
    
    //转出按钮
    _ZCMoneyButton = [ZYZCTool getCustomBtnByTilte:@"转出余额" andImageName:@"btn_rig_mor" andtitleFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor whiteColor] andSpacing:2];
    
    //余额标题
    _balanceTitleLabel = [[UILabel alloc] init];
    _balanceTitleLabel.text = @"钱包余额(元)";
    _balanceTitleLabel.font = [UIFont systemFontOfSize:12];
    _balanceTitleLabel.textColor = [UIColor whiteColor];
    
    _balanceLabel = [[UILabel alloc] init];
    _balanceLabel.text = @"¥0.00";
    _balanceLabel.font = [UIFont systemFontOfSize:12];
    _balanceLabel.textColor = [UIColor whiteColor];
    
    _lineView = [[UIView alloc] init];
    _UBTitleLabel = [[UILabel alloc] init];
    _UBLabel = [[UILabel alloc] init];
    
    
    [self addSubview:_ZCMoneyButton];
    [self addSubview:_balanceTitleLabel];
    [self addSubview:_balanceLabel];
    [self addSubview:_lineView];
    [self addSubview:_UBTitleLabel];
    [self addSubview:_UBLabel];
    
    //转出
    [_ZCMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(50);
        make.height.equalTo(@18);
        make.top.equalTo(self.mas_top).offset(KEDGE_DISTANCE);
        make.right.equalTo(self.mas_right).offset(-KEDGE_DISTANCE);
    }];
    
    //余额
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];

    //余额标题
    [_balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(_balanceLabel.mas_top).offset(-KEDGE_DISTANCE);
    }];
}

- (void)setUpConstraints
{
    
}
@end
