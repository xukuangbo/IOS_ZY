//
//  LivePersonDataView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "LivePersonDataView.h"
#import <Masonry.h>
#import "UIView+ZYLayer.h"
#define headViewWH 100
#define nameLabelH 25
#define guanzhuLabelH 20
#define descH 18
#define roomButtonH 34
#define zhongchouH 34
#define bottomBarH 34
@interface LivePersonDataView ()
/** 头像 */
@property (nonatomic, strong) UIImageView *headView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 性别 */
@property (nonatomic, strong) UIImageView *sexImageView;
/** 关注和粉丝 */
@property (nonatomic, strong) UILabel *guanzhuLabel;
/** 个人描述 */
@property (nonatomic, strong) UILabel *descLabel;
/** 空间 */
@property (nonatomic, strong) UIButton *roomButton;
/** 上灰线 */
@property (nonatomic, strong) UIView *topLine;
/** 下灰线 */
@property (nonatomic, strong) UIView *bottomLine;

/** 众筹 */
@property (nonatomic, strong) UILabel *zhongchouLabel;
/** 底部工具条 */
@property (nonatomic, strong) UIView *bottomBar;
@end

@implementation LivePersonDataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpSubViews];
        
        [self setUpConstraints];
        
    }
    return self;
}


- (void)setUpSubViews
{
    //头像
    _headView = [UIImageView new];
    [self addSubview:_headView];
    _headView.layerCornerRadius = headViewWH * 0.5;
//    _headView.layer.cornerRadius = 50;
//    _headView.layer.masksToBounds = YES;
    _headView.backgroundColor=[UIColor orangeColor];
    _headView.image = [UIImage imageNamed:@"icon_live_placeholder"];
    
    /** 名字 */
    _nameLabel = [UILabel new];
    [self addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
    
    /** 性别 */
    _sexImageView = [UIImageView new];
    [self addSubview:_sexImageView];
    
    /** 关注和粉丝 */
    _guanzhuLabel = [UILabel new];
    [self addSubview:_guanzhuLabel];
    _guanzhuLabel.font = [UIFont systemFontOfSize:15];
    _guanzhuLabel.textColor = [UIColor ZYZC_TextGrayColor];
    
    /** 个人描述 */
    _descLabel = [UILabel new];
    [self addSubview:_descLabel];
    _descLabel.font = [UIFont systemFontOfSize:13];
    _descLabel.textColor = [UIColor ZYZC_TextGrayColor];
    
    /** 空间 */
    _roomButton = [UIButton new];
    [self addSubview:_roomButton];
//    _roomButton.backgroundColor = [UIColor greenColor];
    _roomButton.layerCornerRadius = 5;
    _roomButton.layerBorderWidth = 1;
    _roomButton.layerBorderColor = [UIColor ZYZC_LineGrayColor];
    [_roomButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    
    /**上灰线 */
//    _topLine = [UIView new];
//    [self addSubview:_topLine];
//    _topLine.backgroundColor = [UIColor redColor];
//    /**下灰线 */
//    _bottomLine = [UIView new];
//    [self addSubview:_bottomLine];
//    _bottomLine.backgroundColor = [UIColor yellowColor];
    
    _zhongchouLabel = [UILabel new];
    [self addSubview:_zhongchouLabel];
    _zhongchouLabel.backgroundColor = [UIColor yellowColor];
    _zhongchouLabel.textAlignment = NSTextAlignmentCenter;
    
    /** 底部工具条 */
    _bottomBar = [UIView new];
    [self addSubview:_bottomBar];
    _bottomBar.backgroundColor = [UIColor greenColor];
    

    _nameLabel.text = @"齐德龙";
    _sexImageView.image = [UIImage imageNamed:@"btn_sex_fem"];
    _guanzhuLabel.text = @"20关注 | 60粉丝";
    _descLabel.text = @"23岁,天秤座,174cm,单身";
    [_roomButton setTitle:@"空间" forState:UIControlStateNormal];
    _zhongchouLabel.text = @"正在众筹中'浪漫普及岛自由...'";
    
}
#pragma mark - 设置约束
- (void)setUpConstraints
{
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headViewWH, headViewWH));
        make.top.mas_equalTo(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameLabelH);
        make.centerX.equalTo(_headView);
        make.top.equalTo(_headView.mas_bottom).offset(KEDGE_DISTANCE);
    }];
    
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(_nameLabel.mas_centerY);
    }];
    
    //关注
    [_guanzhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(guanzhuLabelH);
        make.top.equalTo(_nameLabel.mas_bottom).offset(KEDGE_DISTANCE);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //详情描述
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guanzhuLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(descH);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    //他的空间按钮
    [_roomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descLabel.mas_bottom).offset(KEDGE_DISTANCE);
        make.width.equalTo(@200);
        make.height.mas_equalTo(roomButtonH);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
//    //上灰线
//    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_roomButton.mas_top);
//        make.height.mas_equalTo(1);
//        make.width.equalTo(_roomButton.mas_width);
//        make.centerX.equalTo(_roomButton.mas_centerX);
//    }];
//    
//    //下灰线
//    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_roomButton.mas_bottom);
//        make.height.mas_equalTo(1);
//        make.width.mas_equalTo(_roomButton.mas_width);
//        make.centerX.equalTo(_roomButton.mas_centerX);
//    }];
    
    [_zhongchouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_roomButton.mas_bottom);
        make.width.equalTo(@200);
        make.height.mas_equalTo(zhongchouH);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomBarH);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

- (void)showPersonDataWithUserId:(NSString *)userId
{
    CGFloat viewCenterY = self.superview.frame.size.height * 0.5;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.centerY = viewCenterY;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hidePersonDataView
{
    CGFloat viewY = self.superview.frame.size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.top = viewY;
    } completion:^(BOOL finished) {
        //置空数据
    }];
}
@end
