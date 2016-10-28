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

@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
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
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"Butttn_support"] forState:UIControlStateNormal];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"Butttn_support-1"] forState:UIControlStateSelected];
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
        _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",walletYbjModel.totles / 100.0];
        _totalMoneyLabel.size = [ZYZCTool calculateStrLengthByText:_totalMoneyLabel.text andFont:_totalMoneyLabel.font andMaxWidth:MAXFLOAT];
    }
    if (walletYbjModel.status == 0) {//未使用
        _walletYbjModel.img = nil;
//        [UIImage imageNamed:@"Butttn_support"];
        
        
    }else if(walletYbjModel.status == 1){//已使用
        
        
    }else{
        
    }
    
    
}
@end
