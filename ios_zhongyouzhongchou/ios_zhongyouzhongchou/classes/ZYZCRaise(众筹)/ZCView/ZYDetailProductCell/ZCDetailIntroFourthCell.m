//
//  ZCDetailIntroFourthCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailIntroFourthCell.h"
#import "ZCDetailCustomButton.h"
@interface ZCDetailIntroFourthCell ()
@property (nonatomic, strong) UILabel *moneyLab;       //金额
@property (nonatomic, strong) UILabel  *rateLab;       //支持比例
@property (nonatomic, strong) UILabel  *limitLab;      //限额标签
@property (nonatomic, strong) UIView   *supportLab; //支持的人
@property (nonatomic, strong) UIView   *separateView;  //分割线
@property (nonatomic, strong) UIView   *supportUsersView; //支持的人
@property (nonatomic, strong) UIButton *supportBtn;       //支持按钮

@end

@implementation ZCDetailIntroFourthCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)configUI
{
    [super configUI];
    [self.topLineView removeFromSuperview];
    self.titleLab.text=@"一起去旅游";
    self.titleLab.textColor=[UIColor ZYZC_RedTextColor];
    self.titleLab.font=[UIFont boldSystemFontOfSize:17.f];
    
    //金额
    _moneyLab=[ZYZCTool createLabWithFrame:CGRectMake(0, self.titleLab.top, self.bgImg.width, self.titleLab.height) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor blackColor]];
    [self.bgImg addSubview:_moneyLab];
    
    //金额比例
    _rateLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, self.titleLab.bottom+KEDGE_DISTANCE, self.bgImg.width, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [self.bgImg addSubview:_rateLab];
    
    //限额人数
    _limitLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, _rateLab.bottom+KEDGE_DISTANCE, 0, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [self.bgImg addSubview:_limitLab];
    
    //参与人数
    _supportLab = [ZYZCTool createLabWithFrame:CGRectMake(0, _rateLab.bottom+KEDGE_DISTANCE, 0, 20) andFont:_limitLab.font andTitleColor:_limitLab.textColor];
    [self.bgImg addSubview:_supportLab];
    
    _supportUsersView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _limitLab.bottom+KEDGE_DISTANCE, 0, 0)];
    [self.bgImg addSubview:_supportUsersView];
    
    _supportBtn=[ZYZCTool createBtnWithFrame:CGRectMake(KEDGE_DISTANCE, _supportUsersView.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 40) andNormalTitle:@"我要报名一起去" andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(support:)];
    _supportBtn.layer.cornerRadius = KCORNERRADIUS;
    _supportBtn.layer.masksToBounds = YES;
    [self.bgImg addSubview:_supportBtn];
    
    
}

- (void) setTogtherModel:(ReportModel *)togtherModel
{
    _togtherModel=togtherModel;
}

-(void) support:(UIButton *)button

{
}

@end
