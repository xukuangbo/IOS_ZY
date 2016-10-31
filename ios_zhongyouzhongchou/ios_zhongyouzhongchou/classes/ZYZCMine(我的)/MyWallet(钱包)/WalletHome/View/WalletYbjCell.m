//
//  WalletYbjCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletYbjCell.h"
#import "UIView+ZYLayer.h"
//#import "WalletKtxModel.h"
#import "WalletYbjModel.h"
@interface WalletYbjCell ()


@end
@implementation WalletYbjCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self setUpViews];
}
- (void)setUpViews{
    _mapView.layerCornerRadius = 5;
    _bgImageView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _totalMoneyLabel.textColor = [UIColor ZYZC_MainColor];
    _usedLabel.hidden = YES;
    [_selectButton setImage:[UIImage imageNamed:@"Butttn_support"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"Butttn_support-1"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setWalletYbjModel:(WalletYbjModel *)walletYbjModel
{
    _walletYbjModel = walletYbjModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    if (walletYbjModel.img.length > 0) {
        [_faceImageView sd_setImageWithURL:[NSURL URLWithString:walletYbjModel.img] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    }
    
    if (walletYbjModel.zhibotitle.length > 0) {
        _titleLabel.text = walletYbjModel.zhibotitle;
        
    }
    
    if (walletYbjModel.totles) {
        _totalMoney = [NSString stringWithFormat:@"%.2f",walletYbjModel.totles / 100.0];
        _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",walletYbjModel.totles / 100.0];
        _totalMoneyLabel.size = [ZYZCTool calculateStrLengthByText:_totalMoneyLabel.text andFont:_totalMoneyLabel.font andMaxWidth:MAXFLOAT];
    }
    if (walletYbjModel.status == 0) {//未使用
        
        _selectButton.hidden = NO;
        _selectButton.selected = NO;
        _usedLabel.hidden = YES;
        
    }else if(walletYbjModel.status == 1){//已使用
        
        _selectButton.hidden = YES;
        _selectButton.selected = YES;
        _usedLabel.hidden = NO;
        
    }else if(walletYbjModel.status == 3){//已选择
        _selectButton.hidden = NO;
        _usedLabel.hidden = YES;
    }else{
        
    }
}

- (void)selectButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
    
//    self.selectBlock();
    //发出一个通知,通知控制器去加加减减
    [ZYNSNotificationCenter postNotificationName:WalletYbjSelectNotification object:self];
}
@end
