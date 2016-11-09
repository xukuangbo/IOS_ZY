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
#import "FXBlurView.h"
#import "RACEXTScope.h"
#import "WalletZCMoneyVC.h"
@interface WalletHeadView ()

/* 转出余额 */
@property (nonatomic, strong) UIButton *ZCMoneyButton;
/* 转出余额点击区域 */
@property (nonatomic, strong) UIView *ZCMoneySelectDiv;
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

//背景图三剑客
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIView *blurColorView;
@property (nonatomic, strong) FXBlurView *blurView;
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
    self.layer.masksToBounds = YES;
    //模糊背景
    _blurImageView = [[UIImageView alloc] init];
    [_blurImageView sd_setImageWithURL:[NSURL URLWithString:[ZYZCAccountTool account].faceImg] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addFXBlurView];
    
    //转出可点击区域
    _ZCMoneySelectDiv = [[UIView alloc] init];
    [_ZCMoneySelectDiv addTarget:self action:@selector(pushZhuanchuVC)];
    
    //转出按钮
    _ZCMoneyButton = [ZYZCTool getCustomBtnByTilte:@"转出余额" andImageName:@"btn_right_white" andtitleFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor whiteColor] andSpacing:2];
    _ZCMoneyButton.enabled = NO;
    
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

    [self addSubview:_blurImageView];
    [self addSubview:_ZCMoneySelectDiv];
    [self addSubview:_ZCMoneyButton];
    [self addSubview:_balanceTitleLabel];
    [self addSubview:_balanceLabel];
    [self addSubview:_lineView];
    [self addSubview:_UBTitleLabel];
    [self addSubview:_UBLabel];
    
    //模糊背景图
    [_blurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //转出可点击区域
    [_ZCMoneySelectDiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.height.equalTo(self).multipliedBy(0.3);
    }];
    
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

-(void)addFXBlurView
{
    if (_blurView) {
        [_blurView removeFromSuperview];
        [_blurColorView removeFromSuperview];
    }
    //创建毛玻璃
    _blurView = [[FXBlurView alloc] init];
    [_blurView setDynamic:NO];
    _blurView.blurRadius=10;
    _blurColorView=[[UIView alloc] init];
    _blurColorView.backgroundColor=[UIColor ZYZC_MainColor];
    _blurColorView.alpha=0.7;
    
    [_blurImageView addSubview:_blurView];
    [_blurImageView addSubview:_blurColorView];
    
    [_blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_blurImageView);
    }];
    
    [_blurColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_blurImageView);
    }];
}


- (void)setModel:(WalletHeadModel *)model
{
    _model = model;
    
    _balanceLabel.attributedText = [WalletHeadView getAttributesString:model.cash * 0.01];
    
    _UBLabel.text = [NSString stringWithFormat:@"%zd",model.uCash];
    
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

#pragma mark - pushZhuanchuVC
- (void)pushZhuanchuVC
{
//    DDLog(@"heiehei");
    WalletZCMoneyVC *ZcVC =  [[WalletZCMoneyVC alloc] init];
    ZcVC.kzcMoney = self.model.cash / 100;
    [self.viewController.navigationController pushViewController:ZcVC animated:YES];
}
@end
