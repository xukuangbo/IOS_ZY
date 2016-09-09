//
//  ZYLiveListCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveListCell.h"
#import <Masonry.h>
#import "ZYLiveListModel.h"
#import "UIView+ZYLayer.h"
#import "ZYLiveListController.h"
#import "ZYLiveListViewModel.h"
#import "ZCDetailCustomButton.h"
@interface ZYLiveListCell ()
{
    UIImageView *_bgView;//背景
    UIImageView *_viewImg;//封面
    UILabel *_liveStatusLabel;//直播状态
    
    UIView *_bottomBar;//底部容器
    ZCDetailCustomButton *_iconImageView;//头像
    UILabel *_nameLabel;//名字
    UILabel *_titleLabel;//标题
    UILabel *_numberLabel;//人数
    
}
@end
@implementation ZYLiveListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        //创建内容
        [self configUI];
        
    }
    return self;
}

- (void)configUI
{
    //背景
    _bgView = [UIImageView new];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    _bgView.layerCornerRadius = 5;
    _bgView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _bgView.userInteractionEnabled = YES;
    
    
    //封面
    _viewImg = [UIImageView new];
    [_bgView addSubview:_viewImg];
    [_viewImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_bgView).offset(0);
        make.height.mas_equalTo(_viewImg.mas_width).multipliedBy(9 / 20.0);
    }];
    _viewImg.image = [UIImage imageNamed:@"image_placeholder"];
    
    //直播状态
    _liveStatusLabel = [UILabel new];
    [_bgView addSubview:_liveStatusLabel];
    CGFloat liveStatusLabelH = 20;
    [_liveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(10);
        make.right.equalTo(_bgView).offset(-10);
        make.height.mas_equalTo(liveStatusLabelH);
        make.width.mas_equalTo(60);
    }];
    _liveStatusLabel.layerBorderWidth = 1;
    _liveStatusLabel.font = [UIFont systemFontOfSize:15];
    _liveStatusLabel.textColor = [UIColor whiteColor];
    _liveStatusLabel.layerCornerRadius = liveStatusLabelH * 0.5;
    _liveStatusLabel.layerBorderColor = [UIColor whiteColor];
    _liveStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    //底部容器
    _bottomBar = [UIView new];
    [_bgView addSubview:_bottomBar];
    [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_viewImg.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(_bgView.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    //头像
    _iconImageView = [[ZCDetailCustomButton alloc] init];
    [_bottomBar addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomBar.mas_top).offset(10);
        make.left.mas_equalTo(_bottomBar.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    //名字
    _nameLabel = [UILabel new];
    [_bottomBar addSubview:_nameLabel];
//    _nameLabel.backgroundColor = [UIColor redColor];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
    //人数
    _numberLabel = [UILabel new];
    [_bottomBar addSubview:_numberLabel];
//    _numberLabel.backgroundColor = [UIColor yellowColor];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor ZYZC_MainColor];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        
        make.right.equalTo(_numberLabel.mas_left).offset(-10);
        
    }];
    [_numberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top);
        make.right.mas_equalTo(_bottomBar.mas_right).offset(-10);
        make.height.mas_equalTo(20);
        make.left.equalTo(_nameLabel.mas_right).offset(10);
        
    }];
    
    
    //标题
    _titleLabel = [UILabel new];
    [_bottomBar addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor ZYZC_TextGrayColor];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_iconImageView.mas_bottom);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(_bottomBar.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
}


- (void)setModel:(ZYLiveListModel *)model
{
    _model = model;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    if (model.img.length > 0) {
        [_viewImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil options:options];
        
    }else{
        _viewImg.image = [UIImage imageNamed:@"image_placeholder"];
    }
    
    //状态
    if (model.liveStatus == 0) {
        _liveStatusLabel.text = @"直播中";
    }else{
        _liveStatusLabel.text = @"休息中";
    }
    
    //头像
    if (model.faceImg.length> 0) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.faceImg] forState:UIControlStateNormal placeholderImage:nil options:options];
    }else{
        [_iconImageView setImage:[UIImage imageNamed:@"icon_live_placeholder"] forState:UIControlStateNormal];
    }
    
    //头像的userid
    if (model.userId) {
        _iconImageView.userId = model.userId;
    }else{
        _iconImageView.userId = nil;
    }
    
    //名字
    if (model.realName.length> 0) {
        _nameLabel.text = model.realName;
    }else{
        _nameLabel.text = @"名字被吃了~";
    }
    
    //人数
    if (model.onLiveNum > 0) {
        _numberLabel.text =[NSString stringWithFormat:@"%zd人",model.onLiveNum];
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"0人"];
    }
    
    //标题
    if (model.title.length > 0) {
        _titleLabel.text = model.title;
    }else{
        _titleLabel.text = @"标题走丢了~";
    }
}
@end
