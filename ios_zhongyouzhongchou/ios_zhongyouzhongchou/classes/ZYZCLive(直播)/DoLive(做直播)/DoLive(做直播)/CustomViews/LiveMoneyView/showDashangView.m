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
    
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    //圆角半径
    CGFloat layRadius = ShowDashangViewH * 0.5;
    //间隙
    CGFloat DoLiveHeadMargin = 3;
    //头像高度
    CGFloat iconViewHeight = ShowDashangViewH - DoLiveHeadMargin * 2;
    //时间高度
    CGFloat timelabelHeight = (iconViewHeight - DoLiveHeadMargin) * 0.5;
    
    
    self.layerCornerRadius = layRadius;
    //添加控件
    _headView = [UIImageView new];
    [self addSubview:_headView];
    _headView.layerCornerRadius = iconViewHeight * 0.5;
    //    _headView.backgroundColor = [UIColor redColor];
    
    _nameLabel = [UILabel new];
    [self addSubview:_nameLabel];
    //    _nameLabel.backgroundColor = [UIColor redColor];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _numberPeopleLabel = [UILabel new];
    [self addSubview:_numberPeopleLabel];
    _numberPeopleLabel.font = [UIFont systemFontOfSize:12];
    _numberPeopleLabel.textColor = [UIColor whiteColor];
    _numberPeopleLabel.textAlignment = NSTextAlignmentCenter;
    //    _numberPeopleLabel.backgroundColor = [UIColor redColor];
    
    
    //添加约束
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).offset(3);
        make.size.mas_equalTo(CGSizeMake(iconViewHeight, iconViewHeight));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView);
        make.left.mas_equalTo(_headView.mas_right).offset(DoLiveHeadMargin);
        make.right.mas_equalTo(-(layRadius * 0.5));
        make.height.mas_equalTo(timelabelHeight);
    }];
    
    [_numberPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(DoLiveHeadMargin);
        make.left.mas_equalTo(_headView.mas_right).offset(DoLiveHeadMargin);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(timelabelHeight);
    }];

    
}

- (void)setDashangModel:(LiveShowDashangModel *)dashangModel
{
    _dashangModel = dashangModel;
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:dashangModel.headURL] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    _nameLabel.text = dashangModel.nameLabel;
    
    _numberPeopleLabel.text = [NSString stringWithFormat:@"打赏主播%@",dashangModel.numberPeople];
}
@end
