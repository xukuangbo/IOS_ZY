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
#import "WalletHeadModel.h"
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
        
//        [self setUpConstraints];
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
//    _balanceLabel.font = [UIFont boldSystemFontOfSize:45];
    _balanceLabel.textColor = [UIColor whiteColor];
    _balanceLabel.attributedText = [WalletHeadView getAttributesString:0.00];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor ZYZC_LineGrayColor];
    
    _UBTitleLabel = [[UILabel alloc] init];
    _UBTitleLabel.font = [UIFont systemFontOfSize:12];
    _UBTitleLabel.textAlignment = NSTextAlignmentCenter;
    _UBTitleLabel.textColor = [UIColor whiteColor];
    _UBTitleLabel.text = @"U币";

    _UBLabel = [[UILabel alloc] init];
    _UBLabel.font = [UIFont systemFontOfSize:15];
    _UBLabel.textAlignment = NSTextAlignmentCenter;
    _UBLabel.textColor = [UIColor whiteColor];
    _UBLabel.text = @"0.00";

    
    [self addSubview:_ZCMoneyButton];
    [self addSubview:_balanceTitleLabel];
    [self addSubview:_balanceLabel];
    [self addSubview:_lineView];
    [self addSubview:_UBTitleLabel];
    [self addSubview:_UBLabel];
    
    //转出
    [_ZCMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(50);
//        make.height.equalTo(@18);
        make.top.equalTo(self.mas_top).offset(KEDGE_DISTANCE);
        make.right.equalTo(self.mas_right).offset(-KEDGE_DISTANCE);
    }];
    
    //余额
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];

    //余额标题
    [_balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(_balanceLabel.mas_top).offset(-KEDGE_DISTANCE);
    }];
    
    
    [_UBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [_UBTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(_UBLabel.mas_top).offset(-5);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom).offset(-53);
    }];
    
}

- (void)setModel:(WalletHeadModel *)model
{
    _model = model;
    
    _balanceLabel.attributedText = [WalletHeadView getAttributesString:model.cash * 0.01];
    
    _UBLabel.text = @(model.uCash);
    
}

/* 获取属性文本格式 */
+ (NSMutableAttributedString *)getAttributesString:(CGFloat )number
{
    //2.53
    NSString *numberString = [NSString stringWithFormat:@"%.2f",number];
    //¥2.53
    NSString *totalString = [NSString stringWithFormat:@"¥%@",numberString];
    //¥2.53
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    //[2,53]
    NSArray *strArray = [numberString componentsSeparatedByString:@"."];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(0, 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:45] range:[totalString rangeOfString:strArray[0]]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:[totalString rangeOfString:[NSString stringWithFormat:@".%@",strArray[1]] options:NSBackwardsSearch]];
    
    return attrString;
}
@end
