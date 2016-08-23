//
//  MineWalletMingxiCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MineWalletMingxiCell.h"
#import "ZCDetailCustomButton.h"

#import <Masonry.h>
@interface MineWalletMingxiCell ()
@property (nonatomic, strong) ZCDetailCustomButton *iconView;
@property (nonatomic, strong) UILabel *styleLabel;
@property (nonatomic, strong) UILabel *supportTimeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *supportMoneyLabel;
@property (nonatomic, strong) UIImageView *mapView;
@end



@implementation MineWalletMingxiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //需要5个控件
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //白色背景
        _mapView = [UIImageView new];
        _mapView.userInteractionEnabled = YES;
        _mapView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        [self.contentView addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).width.insets(UIEdgeInsetsMake(5, 10, 5, 10));
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        
        //头像
        _iconView = [ZCDetailCustomButton buttonWithType:UIButtonTypeCustom];
        [self.mapView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(10);
//            make.bottom.mas_equalTo(-10);
//            make.width.mas_equalTo(_iconView.height);
            make.width.and.height.mas_equalTo(WalletMingXiCellRowHeight - 3 * KEDGE_DISTANCE);
        }];
        
        //名字
        _nameLabel = [UILabel new];
        [self.mapView addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mapView.mas_top).with.offset(10);
            make.left.mas_equalTo(_iconView.mas_right).with.offset(10);
            make.right.mas_equalTo(_mapView.mas_right).with.offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        //支持方式
        _styleLabel = [UILabel new];
        _styleLabel.textColor = [UIColor ZYZC_TextGrayColor];
        
        _supportMoneyLabel = [UILabel new];
        [self.mapView addSubview:_supportMoneyLabel];
        
        _styleLabel.font = [UIFont systemFontOfSize:14];
        [self.mapView addSubview:_styleLabel];
        [_styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10).mas_equalTo(_iconView.mas_right);
            make.top.offset(5).mas_equalTo(_nameLabel.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        //时间
        _supportTimeLabel = [UILabel new];
        [self.mapView addSubview:_supportTimeLabel];
        _supportTimeLabel.font = [UIFont systemFontOfSize:14];
        _supportTimeLabel.textColor = [UIColor ZYZC_TextGrayColor];
        [_supportTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10).mas_equalTo(_iconView.mas_right);
            make.top.offset(5).mas_equalTo(_styleLabel.mas_bottom);
            make.height.mas_equalTo(20);
            make.right.offset(-10).mas_equalTo(_mapView.mas_right);
        }];
        
        //支持金额
        [_supportMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_mapView.mas_centerY);
            make.right.offset(-10).mas_equalTo(_mapView.mas_right);
            make.height.mas_equalTo(30);
        }];
        
        
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
    if (walletMingXiModel.realName.length > 0 || walletMingXiModel.userName.length > 0) {
        _nameLabel.text = walletMingXiModel.realName?walletMingXiModel.realName:walletMingXiModel.userName;
    }
    
    if (walletMingXiModel.style == 1) {
        _styleLabel.text = [NSString stringWithFormat:@"支持%d元",(int)walletMingXiModel.buyPrice];
    }else if(walletMingXiModel.style == 2){
        _styleLabel.text = @"支持任意金额";
    }else if(walletMingXiModel.style == 3){
        _styleLabel.text = @"支持回报众筹";
    }else if(walletMingXiModel.style == 4){
        _styleLabel.text = @"支持一起去";
    }else{
        
    }
    
    
    if (walletMingXiModel.buyDate.length > 0) {
        _supportTimeLabel.text = walletMingXiModel.buyDate;
        
    }
    
    if (walletMingXiModel.buyPrice) {
        _supportMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",walletMingXiModel.buyPrice * 0.01];
    }else if (walletMingXiModel.buyPrice == 0){
        _supportMoneyLabel.text = @"￥0";
    }
    
}
@end
