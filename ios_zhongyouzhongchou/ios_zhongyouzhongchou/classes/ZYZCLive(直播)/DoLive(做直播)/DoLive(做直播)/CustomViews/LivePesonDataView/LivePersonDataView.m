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
#import "MinePersonSetUpModel.h"
#import "NSDate+RMCalendarLogic.h"

#define headViewWH 100
#define nameLabelH 25
#define guanzhuLabelH 20
#define descH 18
#define roomButtonH 40
#define zhongchouH 40
#define bottomBarH 40
#define FOLLIOW_AND_BEFOLLOW(follow,befollow)  [NSString stringWithFormat:@"关注 %ld   ｜   粉丝 %ld",follow,befollow]
@interface LivePersonDataView ()
/** 头像 */
@property (nonatomic, strong) UIImageView *headImageView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 性别 */
@property (nonatomic, strong) UIImageView *sexImageView;
/** 关注和粉丝 */
@property (nonatomic, strong) UILabel *attentionLabel;
/** 个人描述 */
@property (nonatomic, strong) UILabel *descLabel;
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
    self.headImageView = [UIImageView new];
    [self addSubview:self.headImageView];
    self.headImageView.layerCornerRadius = headViewWH * 0.5;
//    _headView.layer.cornerRadius = 50;
//    _headView.layer.masksToBounds = YES;
    self.headImageView.image = [UIImage imageNamed:@"icon_live_placeholder"];
    
    /** 名字 */
    _nameLabel = [UILabel new];
    [self addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
    
    /** 性别 */
    _sexImageView = [UIImageView new];
    [self addSubview:_sexImageView];
    
    /** 关注和粉丝 */
    self.attentionLabel = [UILabel new];
    [self addSubview:self.attentionLabel];
    self.attentionLabel.font = [UIFont systemFontOfSize:15];
    self.attentionLabel.textColor = [UIColor ZYZC_TextGrayColor];
    
    /** 个人描述 */
    _descLabel = [UILabel new];
    [self addSubview:_descLabel];
    _descLabel.font = [UIFont systemFontOfSize:13];
    _descLabel.textColor = [UIColor ZYZC_TextGrayColor];
    
    /** 空间 */
    self.roomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.roomButton.userInteractionEnabled = YES;
    [self.roomButton addTarget:self action:@selector(aaaaaaa) forControlEvents:UIControlEventTouchUpInside];
    [self.roomButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [self addSubview:self.roomButton];
    
    UIImageView *roomArrow = [[UIImageView alloc] init];
    roomArrow.image = [UIImage imageNamed:@"btn_rightin"];
    [self addSubview:roomArrow];
    [roomArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_roomButton.mas_top).offset(12);
        make.width.equalTo(@9);
        make.height.equalTo(@16);
        make.right.equalTo(self).offset(-10);
    }];
    /**上灰线 */
    UILabel *topLine = [[UILabel alloc] init];
    [self addSubview:topLine];
    topLine.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_roomButton.mas_top);
        make.width.equalTo(@200);
        make.height.mas_equalTo(1);
        make.centerX.equalTo(self.mas_centerX);
    }];
    /**下灰线 */
    UILabel *bottomLine = [[UILabel alloc] init];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_roomButton.mas_bottom);
        make.width.equalTo(@200);
        make.height.mas_equalTo(1);
        make.centerX.equalTo(self.mas_centerX);
    }];

    self.zhongchouButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhongchouButton setTitleColor:[UIColor colorWithHexString:@"637fc0"] forState:UIControlStateNormal];
    [self addSubview:self.zhongchouButton];
    
    UIImageView *zhongchouArrow = [[UIImageView alloc] init];
    zhongchouArrow.image = [UIImage imageNamed:@"btn_rightin"];
    [self addSubview:zhongchouArrow];
    [zhongchouArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhongchouButton.mas_top).offset(12);
        make.width.equalTo(@9);
        make.height.equalTo(@16);
        make.right.equalTo(self).offset(-10);
    }];
    
    UILabel *zhongchouBottomLine = [[UILabel alloc] init];
    [self addSubview:zhongchouBottomLine];
    zhongchouBottomLine.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    [zhongchouBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.zhongchouButton.mas_bottom);
        make.width.equalTo(@200);
        make.height.mas_equalTo(1);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    /** 底部工具条 */
    _bottomBar = [UIView new];
//    _bottomBar.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [self addSubview:_bottomBar];
    
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [self addSubview:self.attentionButton];
    
    self.bannedSpeakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bannedSpeakButton setTitle:@"禁言" forState:UIControlStateNormal];
    [self.bannedSpeakButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [self addSubview:self.bannedSpeakButton];
    
    _nameLabel.text = @"匿名";
    _sexImageView.image = [UIImage imageNamed:@"btn_sex_fem"];
    self.attentionLabel.text = @"0关注 | 0粉丝";
    _descLabel.text = @"";
    [_roomButton setTitle:@"空间" forState:UIControlStateNormal];
    [self.zhongchouButton setTitle:@"正在众筹中'浪漫普及岛自由...'" forState:UIControlStateNormal];
}
#pragma mark - 设置约束
- (void)setUpConstraints
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headViewWH, headViewWH));
        make.top.mas_equalTo(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameLabelH);
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(KEDGE_DISTANCE);
    }];
    
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(_nameLabel.mas_centerY);
    }];
    
    //关注
    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(guanzhuLabelH);
        make.top.equalTo(_nameLabel.mas_bottom).offset(KEDGE_DISTANCE);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //详情描述
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.attentionLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(descH);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //他的空间按钮
    [self.roomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(KEDGE_DISTANCE);
        make.width.equalTo(@200);
        make.height.mas_equalTo(roomButtonH);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.zhongchouButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(100);
        make.bottom.equalTo(self).offset(-3);
        make.left.equalTo(self).offset(10);
    }];
    
    [self.bannedSpeakButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(60);
        make.bottom.equalTo(self).offset(-3);
        make.right.equalTo(self).offset(-10);
    }];
}

- (void)showPersonDataWithUserId:(NSString *)userId
{
    CGFloat viewCenterY = self.superview.frame.size.height * 0.5;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.centerY = viewCenterY;
        NSLog(@"1111111111");
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

- (void)setMinePersonModel:(MinePersonSetUpModel *)minePersonModel
{
    _minePersonModel = minePersonModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:minePersonModel.faceImg] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    self.nameLabel.text = minePersonModel.realName?minePersonModel.realName:minePersonModel.userName;
    if ([minePersonModel.sex isEqualToString:@"1"]) {
        _sexImageView.image=[UIImage imageNamed:@"btn_sex_mal"];
    } else if ([minePersonModel.sex isEqualToString:@"2"]) {
        _sexImageView.image=[UIImage imageNamed:@"btn_sex_fem"];
    } else if ([minePersonModel.sex isEqualToString:@"0"]) {
        _sexImageView.image=nil;
    }
    
    //关注和粉丝
    NSString *attentionText = [NSString stringWithFormat:@"关注%@ | 粉丝%@", minePersonModel.gzMeAll, minePersonModel.meGzAll];
    self.attentionLabel.text = attentionText;
    
    //基础信息
    NSInteger age;
    if (minePersonModel.birthday.length) {
        age=[NSDate getAgeFromBirthday:minePersonModel.birthday];
    }
    //    NSString *personInfo=@"23岁、天枰座、50kg、170cm、单身";
    NSMutableString *personInfo1=[NSMutableString string];
    age>0?[personInfo1 appendString:[NSString stringWithFormat:@"%ld岁、",age]]:nil;
    minePersonModel.constellation.length>0?[personInfo1 appendString:[NSString stringWithFormat:@"%@、",minePersonModel.constellation]]:nil;
    minePersonModel.weight>0?[personInfo1 appendString:[NSString stringWithFormat:@"%zdkg、",minePersonModel.weight]]:nil;
    
    minePersonModel.height>0?[personInfo1 appendString:[NSString stringWithFormat:@"%zdcm、",minePersonModel.height]]:nil;
    
    NSString *marital;
    if (minePersonModel.maritalStatus) {
        if ([minePersonModel.maritalStatus isEqualToString:@"0"]) {
            marital=@"单身";
        } else if ([minePersonModel.maritalStatus isEqualToString:@"1"]) {
            marital=@"恋爱中";
        } else if ([minePersonModel.maritalStatus isEqualToString:@"2"]) {
            marital=@"已婚";
        } else {
            marital = @"未知";
        }
    }
    minePersonModel.maritalStatus?[personInfo1 appendString:[NSString stringWithFormat:@"%@",marital]]:nil;
    
    if ([personInfo1 hasSuffix:@"、"]) {
        [personInfo1 replaceCharactersInRange:NSMakeRange(personInfo1.length-1, 1) withString:@""];
    }
    self.descLabel.text=personInfo1;

}

- (void)aaaaaaa
{
    NSLog(@"");
}
@end
