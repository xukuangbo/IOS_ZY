//
//  WalletMingXiCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//


#import "WalletMingXiCell.h"
#import "ZCDetailCustomButton.h"
@interface WalletMingXiCell ()
@property (nonatomic, strong) ZCDetailCustomButton *iconView;
@property (nonatomic, strong) UILabel *styleLabel;
@property (nonatomic, strong) UILabel *supportTimeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *supportMoneyLabel;
@property (nonatomic, strong) UIImageView *mapView;
@end

@implementation WalletMingXiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //需要5个控件
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //容器
        CGFloat mapViewX = KEDGE_DISTANCE;
        CGFloat mapViewY = 5;
        CGFloat mapViewW = KSCREEN_W - 2 * mapViewX;
        CGFloat mapViewH = WalletMingXiCellRowHeight - 2 * mapViewY;
        _mapView = [[UIImageView alloc] initWithFrame:CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH)];
        _mapView.userInteractionEnabled = YES;
        _mapView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        [self.contentView addSubview:_mapView];
        
        //头像
        CGFloat iconViewX = KEDGE_DISTANCE;
        CGFloat iconViewY = KEDGE_DISTANCE;
        CGFloat iconViewWH = mapViewH - 2 * iconViewY;
        _iconView = [[ZCDetailCustomButton alloc] initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH)];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
        [_mapView addSubview:_iconView];
        
        //名字
        CGFloat nameLabelX = _iconView.right + KEDGE_DISTANCE;
        CGFloat nameLabelY = _iconView.top;
        CGFloat nameLabelW = mapViewW - nameLabelX - KEDGE_DISTANCE;
        CGFloat nameLabelH = 20;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
        _nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
        [_mapView addSubview:_nameLabel];
        
        //style支持方式
        CGFloat styleLabelX = nameLabelX;
        CGFloat styleLabelY = _nameLabel.bottom + KTextMargin;
        CGFloat styleLabelW = 50;
        CGFloat styleLabelH = 20;
        _styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(styleLabelX, styleLabelY, styleLabelW, styleLabelH)];
        _styleLabel.textColor = [UIColor ZYZC_TextGrayColor];
        _styleLabel.font = [UIFont systemFontOfSize:14];
        [_mapView addSubview:_styleLabel];
        
        //时间
        CGFloat supportTimeLabelX = styleLabelX;
        CGFloat supportTimeLabelY = _styleLabel.bottom + KTextMargin;
        CGFloat supportTimeLabelW = 50;
        CGFloat supportTimeLabelH = 20;
        _supportTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(supportTimeLabelX, supportTimeLabelY, supportTimeLabelW, supportTimeLabelH)];
        _supportTimeLabel.font = [UIFont systemFontOfSize:14];
        _supportTimeLabel.textColor = [UIColor ZYZC_TextGrayColor];
        [_mapView addSubview:_supportTimeLabel];
        
        //支持金额
        CGFloat supportMoneyLabelW = 70;
        CGFloat supportMoneyLabelH = 30;
        CGFloat supportMoneyLabelX = mapViewW - supportMoneyLabelW - KEDGE_DISTANCE;
        CGFloat supportMoneyLabelY = mapViewH * 0.5 - supportMoneyLabelH * 0.5;
        _supportMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(supportMoneyLabelX, supportMoneyLabelY, supportMoneyLabelW, supportMoneyLabelH)];
        _supportMoneyLabel.textAlignment = NSTextAlignmentRight;
//        [_supportMoneyLabel addTarget:self action:@selector(txAction)];
        [_mapView addSubview:_supportMoneyLabel];
    }
    return self;
}

- (void)setWalletMingXiModel:(WalletMingXiModel *)walletMingXiModel
{
    _walletMingXiModel = walletMingXiModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    if (walletMingXiModel.faceImg.length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:walletMingXiModel.faceImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        _iconView.userId=walletMingXiModel.userId;
    }
    if (walletMingXiModel.realName.length > 0) {
        _nameLabel.text = walletMingXiModel.realName?walletMingXiModel.realName:walletMingXiModel.userName;
        _nameLabel.size = [ZYZCTool calculateStrLengthByText:_nameLabel.text andFont:_nameLabel.font andMaxWidth:MAXFLOAT];
    }

    if (walletMingXiModel.style == 1) {
        _styleLabel.text = @"支持1元";
    }else if(walletMingXiModel.style == 2){
        _styleLabel.text = @"支持任意金额";
    }else if(walletMingXiModel.style == 3){
        _styleLabel.text = @"支持回报众筹";
    }else if(walletMingXiModel.style == 4){
        _styleLabel.text = @"支持一起去";
    }else{
        
    }
    _styleLabel.size = [ZYZCTool calculateStrLengthByText:_styleLabel.text andFont:_styleLabel.font andMaxWidth:MAXFLOAT];
    
    
    if (walletMingXiModel.buyDate.length > 0) {
        _supportTimeLabel.text = walletMingXiModel.buyDate;
        _supportTimeLabel.size = [ZYZCTool calculateStrLengthByText:_supportTimeLabel.text andFont:_supportTimeLabel.font andMaxWidth:MAXFLOAT];
    }
    
    if (walletMingXiModel.buyPrice) {
        _supportMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",walletMingXiModel.buyPrice * 0.01];
        _supportMoneyLabel.size = [ZYZCTool calculateStrLengthByText:_supportMoneyLabel.text andFont:_supportMoneyLabel.font andMaxWidth:MAXFLOAT];
    }
    
}
@end
