//
//  MineWalletTableViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MineWalletTableViewCell.h"
#import "MineWalletModel.h"
#import "UploadVoucherVC.h"
@interface MineWalletTableViewCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *totalMoneyLabel;
@property (nonatomic, strong) UILabel *productEndTimeLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UIImageView *mapView;
@end
@implementation MineWalletTableViewCell

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
        CGFloat mapViewH = WalletCellRowHeight - 2 * mapViewY;
        _mapView = [[UIImageView alloc] initWithFrame:CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH)];
        _mapView.userInteractionEnabled = YES;
        _mapView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        [self.contentView addSubview:_mapView];
        
        //头像
        CGFloat iconViewX = KEDGE_DISTANCE;
        CGFloat iconViewY = KEDGE_DISTANCE;
        CGFloat iconViewW = 100;
        CGFloat iconViewH = mapViewH - 2 * iconViewY;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH)];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
        [_mapView addSubview:_iconView];
        
        //项目名字
        CGFloat productNameLabelX = _iconView.right + KEDGE_DISTANCE;
        CGFloat productNameLabelY = _iconView.top;
        CGFloat productNameLabelW = mapViewW - productNameLabelX - KEDGE_DISTANCE;
        CGFloat productNameLabelH = 20;
        _productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(productNameLabelX, productNameLabelY, productNameLabelW, productNameLabelH)];
        _productNameLabel.textColor = [UIColor ZYZC_TextBlackColor];
        [_mapView addSubview:_productNameLabel];
        
        //金钱
        CGFloat totalMoneyLabelX = productNameLabelX;
        CGFloat totalMoneyLabelY = _productNameLabel.bottom + KTextMargin;
        CGFloat totalMoneyLabelW = 50;
        CGFloat totalMoneyLabelH = 20;
        _totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalMoneyLabelX, totalMoneyLabelY, totalMoneyLabelW, totalMoneyLabelH)];
        _totalMoneyLabel.textColor = [UIColor ZYZC_TextGrayColor];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:14];
        [_mapView addSubview:_totalMoneyLabel];
        
        //项目结束时间
        CGFloat productEndTimeLabelX = totalMoneyLabelX;
        CGFloat productEndTimeLabelY = _totalMoneyLabel.bottom + KTextMargin;
        CGFloat productEndTimeLabelW = 50;
        CGFloat productEndTimeLabelH = 20;
        _productEndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productEndTimeLabelX, productEndTimeLabelY, productEndTimeLabelW, productEndTimeLabelH)];
        _productEndTimeLabel.font = [UIFont systemFontOfSize:14];
        _productEndTimeLabel.textColor = [UIColor ZYZC_TextGrayColor];
        [_mapView addSubview:_productEndTimeLabel];
        
        //时间
        CGFloat txLabelW = 70;
        CGFloat txLabelH = 30;
        CGFloat txLabelX = mapViewW - txLabelW - KEDGE_DISTANCE;
        CGFloat txLabelY = mapViewH * 0.5 - txLabelH * 0.5;
        _txLabel = [[UILabel alloc] initWithFrame:CGRectMake(txLabelX, txLabelY, txLabelW, txLabelH)];
        _txLabel.textAlignment = NSTextAlignmentRight;
        [_txLabel addTarget:self action:@selector(txAction)];
        [_mapView addSubview:_txLabel];
        
        
    }
    return self;
}

- (void)setMineWalletModel:(MineWalletModel *)mineWalletModel
{
    _mineWalletModel = mineWalletModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    if (mineWalletModel.headImage.length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:mineWalletModel.headImage] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    }
    if (mineWalletModel.productEndTime.length > 0) {
        _productEndTimeLabel.text = mineWalletModel.productEndTime;
        _productEndTimeLabel.size = [ZYZCTool calculateStrLengthByText:_productEndTimeLabel.text andFont:_productEndTimeLabel.font andMaxWidth:MAXFLOAT];
    }
    if (mineWalletModel.txtotles) {
        _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",mineWalletModel.txtotles / 100.0];
        _totalMoneyLabel.size = [ZYZCTool calculateStrLengthByText:_totalMoneyLabel.text andFont:_totalMoneyLabel.font andMaxWidth:MAXFLOAT];
    }
    if (mineWalletModel.txstatus == 0) {
        _txLabel.text = @"申请提现";
        _txLabel.size = CGSizeMake(80, 30);
        _txLabel.textAlignment = NSTextAlignmentCenter;
        _txLabel.layer.cornerRadius = 5;
        _txLabel.layer.masksToBounds = YES;
        _txLabel.userInteractionEnabled = YES;
        _txLabel.textColor = [UIColor whiteColor];
        _txLabel.backgroundColor = [UIColor ZYZC_MainColor];
        _txLabel.bottom = _mapView.height - KEDGE_DISTANCE;
        _txLabel.right = _mapView.width - KEDGE_DISTANCE;
        
        _totalMoneyLabel.textColor = [UIColor redColor];
        
    }else{
        if (mineWalletModel.txstatus == 1) {
            _txLabel.text = @"正在审核";
            
            _totalMoneyLabel.textColor = [UIColor ZYZC_MainColor];
        }else if (mineWalletModel.txstatus == 2){
            _txLabel.text = @"提现成功";
            
            _totalMoneyLabel.textColor = [UIColor ZYZC_TextGrayColor];
        }
        
        _txLabel.size = [ZYZCTool calculateStrLengthByText:_txLabel.text andFont:_txLabel.font andMaxWidth:MAXFLOAT];
        _txLabel.layer.cornerRadius = 0;
        _txLabel.userInteractionEnabled = NO;
        _txLabel.backgroundColor = [UIColor clearColor];
        _txLabel.textColor = [UIColor ZYZC_TextBlackColor];
        _txLabel.bottom = _mapView.height - KEDGE_DISTANCE;
        _txLabel.right = _mapView.width - KEDGE_DISTANCE;
        
        _totalMoneyLabel.textColor = [UIColor ZYZC_TextGrayColor];
    }
    if (mineWalletModel.productName.length > 0) {
        _productNameLabel.text = mineWalletModel.productName;
//        _productNameLabel.size = [ZYZCTool calculateStrLengthByText:_productNameLabel.text andFont:_productNameLabel.font andMaxWidth:MAXFLOAT];
    }
    
}


#pragma mark ---txAction提现操作
- (void)txAction
{
    if (self.mineWalletModel.productId) {
        UploadVoucherVC *uploadVC = [[UploadVoucherVC alloc] init];
        uploadVC.productID = self.mineWalletModel.productId;
        [self.viewController.navigationController pushViewController:uploadVC animated:YES];
    }else{
//        NSLog(@"没有项目id");
    }
    
}
@end
