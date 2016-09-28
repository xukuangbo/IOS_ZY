//
//  showDashangView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "showDashangView.h"
#import <Masonry.h>
#import "UIView+ZYLayer.h"

@interface showDashangView ()

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *numberPeopleLabel;
@end

@implementation showDashangView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    
//    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    self.backgroundColor = [UIColor colorWithRed:232 / 256.0 green:22 / 256.0  blue:78 / 256.0  alpha:0.9];
    
    //圆角半径
    CGFloat layRadius = ShowDashangViewH * 0.5;
    //间隙
    CGFloat ShowDashangViewMargin = 3;
    //头像高度
    CGFloat iconViewHeight = ShowDashangViewH - ShowDashangViewMargin * 2;
    //名字高度
    CGFloat nameLabelHeight = (iconViewHeight - ShowDashangViewMargin) * 0.6;
    //人数高度
    CGFloat numberLabelHeight = (iconViewHeight - ShowDashangViewMargin) * 0.4;
    
    
    self.layerCornerRadius = layRadius;
    //添加控件
    _headView = [UIImageView new];
    [self addSubview:_headView];
    _headView.layerCornerRadius = iconViewHeight * 0.5;
//        _headView.backgroundColor = [UIColor redColor];
    
    _nameLabel = [UILabel new];
    [self addSubview:_nameLabel];
    //    _nameLabel.backgroundColor = [UIColor redColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    _numberPeopleLabel = [UILabel new];
    [self addSubview:_numberPeopleLabel];
    _numberPeopleLabel.font = [UIFont systemFontOfSize:12];
    _numberPeopleLabel.textColor = [UIColor whiteColor];
    _numberPeopleLabel.textAlignment = NSTextAlignmentLeft;
    //    _numberPeopleLabel.backgroundColor = [UIColor redColor];
    
    
    //添加约束
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).offset(3);
        make.size.mas_equalTo(CGSizeMake(iconViewHeight, iconViewHeight));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView);
        make.left.mas_equalTo(_headView.mas_right).offset(ShowDashangViewMargin);
        make.right.mas_equalTo(-(layRadius * 0.5));
        make.height.mas_equalTo(nameLabelHeight);
    }];
    
    [_numberPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(ShowDashangViewMargin);
        make.left.mas_equalTo(_headView.mas_right).offset(ShowDashangViewMargin);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(numberLabelHeight);
    }];

}

- (void)setDashangModel:(LiveShowDashangModel *)dashangModel
{
    _dashangModel = dashangModel;
    
//    [_headView sd_setImageWithURL:[NSURL URLWithString:dashangModel.headURL] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_headView sd_setImageWithURL:[NSURL URLWithString:dashangModel.headURL]];
    });
    
    _nameLabel.text = dashangModel.nameLabel;
    
    _numberPeopleLabel.text = [NSString stringWithFormat:@"%@",dashangModel.numberPeople];
    
}
@end
