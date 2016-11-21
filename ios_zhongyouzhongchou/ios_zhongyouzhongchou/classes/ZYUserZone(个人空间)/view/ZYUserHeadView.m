//
//  ZYUserHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define Follow_And_Befollow(follow,befollow)  [NSString stringWithFormat:@"关注 %ld   ｜   粉丝 %ld",follow,befollow]

#import "ZYUserHeadView.h"
#import "FXBlurView.h"
#import "ZYZoomImageVIew.h"
#import "LoginJudgeTool.h"
#import "MinePersonSetUpController.h"
#import "NSDate+RMCalendarLogic.h"

@interface ZYUserHeadView ()

@property (nonatomic, assign) UserZoomType  userZoomType; //他人还是自己的空间

@property (nonatomic, strong) FXBlurView      *blurView;
@property (nonatomic, strong) UIView          *blurColorView;
@property (nonatomic, strong) UIImageView     *iconBgView;
@property (nonatomic, strong) ZYZoomImageVIew *iconImgView;
@property (nonatomic, strong) UILabel         *friendLab;
@property (nonatomic, strong) UIView          *baseInfoView;
@property (nonatomic, strong) UILabel         *nameLab;
@property (nonatomic, strong) UIImageView     *sexImg;
@property (nonatomic, strong) UILabel         *userInfoLab;

@end

@implementation ZYUserHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithUserZoomtype:(UserZoomType)userZoomType
{
    self = [super init];
    if (self) {
        _userZoomType=userZoomType;
        self.frame=CGRectMake(0, 0, KSCREEN_W, User_Head_Height);
        if (_userZoomType==MySelfZoomType) {
            self.height=My_User_Head_height;
        }
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    //背景头像
    _iconBgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, My_User_Head_height)];
    _iconBgView.contentMode=UIViewContentModeScaleAspectFill;
    _iconBgView.layer.masksToBounds=YES;
    _iconBgView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _iconBgView.image=[UIImage imageNamed:@"icon_placeholder"];
    [self addSubview:_iconBgView];
    [self addFXBlurView];
    
    //头像
    CGFloat faceWidth=80*KCOFFICIEMNT;
    _iconImgView=[[ZYZoomImageVIew alloc]initWithFrame:CGRectMake((self.width-faceWidth)/2, 64, faceWidth, faceWidth)];
    _iconImgView.image=[UIImage imageNamed:@"icon_placeholder"];
    _iconImgView.layer.cornerRadius=KCORNERRADIUS;
    _iconImgView.layer.masksToBounds=YES;
    _iconImgView.layer.borderWidth=2;
    _iconImgView.layer.borderColor=[UIColor whiteColor].CGColor;
    [self addSubview:_iconImgView];
    
    if(_userZoomType==MySelfZoomType)
    {
        [_iconImgView addTarget:self action:@selector(enterMyInfoSet)];
    }
    
    //基本信息
    _baseInfoView=[[UIView alloc]initWithFrame:CGRectMake(0, _iconImgView.bottom+KEDGE_DISTANCE, self.width,65)];
    [self addSubview:_baseInfoView];

    //名字
    _nameLab=[ZYZCTool createLabWithFrame:CGRectMake(0, 0, 0, 30) andFont:[UIFont boldSystemFontOfSize:20] andTitleColor:[UIColor whiteColor]];
    [_baseInfoView addSubview:_nameLab];
              
      //性别
    _sexImg=[[UIImageView alloc]initWithFrame:CGRectMake(_nameLab.right, _nameLab.top+5, 20, 20)];
    [_baseInfoView addSubview:_sexImg];
      
     //关注和粉丝
    _friendLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, _nameLab.bottom, _baseInfoView.width-2*KEDGE_DISTANCE, 15) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor whiteColor]];
    _friendLab.textAlignment=NSTextAlignmentCenter;
    [_baseInfoView addSubview:_friendLab];
      
  //基础信息
    _userInfoLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, _friendLab.bottom+5, _baseInfoView.width-2*KEDGE_DISTANCE, 15) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor whiteColor]];
    _userInfoLab.textAlignment=NSTextAlignmentCenter;
  [_baseInfoView addSubview:_userInfoLab];
    
    //足迹／行程  我的空间／足迹
    NSArray *items=nil;
    if (_userZoomType==OtherZoomType) {
        items=@[@"TA的行程",@"TA的足迹"];
    }
    else if(_userZoomType==MySelfZoomType)
    {
        items=@[@"我的中心",@"我的足迹"];
    }
    CGFloat segment_width=200;
    _segmentView=[[UISegmentedControl alloc]initWithItems:items];
    _segmentView.frame=CGRectMake((self.width-segment_width)/2, _baseInfoView.bottom+KEDGE_DISTANCE, segment_width, 30);
    _segmentView.selectedSegmentIndex=0;
    _segmentView.backgroundColor= [UIColor ZYZC_MainColor];
    _segmentView.tintColor=[UIColor whiteColor];
    _segmentView.layer.cornerRadius=4;
    _segmentView.layer.masksToBounds=YES;
    [_segmentView addTarget:self action:@selector(changeSegmented:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segmentView];
    
    //如果是他人空间，创建行程切换
    if (_userZoomType==OtherZoomType) {
        _travelTypeView=[[ZYTravelTypeView alloc]initWithFrame:CGRectMake(0, _segmentView.bottom+KEDGE_DISTANCE, self.width, 40)];
        [self addSubview:_travelTypeView];
    }
   
}

#pragma mark --- 我的空间／足迹切换
- (void)changeSegmented:(UISegmentedControl *)segmented
{
    if (self.changeContent) {
        self.changeContent(segmented.selectedSegmentIndex);
    }
    
    if (_userZoomType==OtherZoomType) {
         _travelTypeView.hidden=(segmented.selectedSegmentIndex==1);
    }
}

#pragma mark --- 加载用户信息数据
-(void)setUserModel:(UserModel *)userModel
{
    _userModel=userModel;
    
    NSArray *textArr=nil;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:[ZYZCTool getSmailIcon:userModel.faceImg]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"] options: SDWebImageRetryFailed | SDWebImageLowPriority];
    
     _iconImgView.urlString=[ZYZCTool getBigIcon:userModel.faceImg640?userModel.faceImg640:userModel.faceImg];
    
    [_iconBgView sd_setImageWithURL:[NSURL URLWithString:userModel.faceImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self addFXBlurView];
    }];
    
    //名字
    UIFont *font=_nameLab.font;
    NSString *name=userModel.realName?userModel.realName:userModel.userName;
    CGFloat nameWidth=[ZYZCTool calculateStrLengthByText:name andFont:font andMaxWidth:self.width].width;
    if (nameWidth>self.width-40) {
        nameWidth=self.width-40;
    }
    _nameLab.left=self.width/2-(nameWidth+20)/2;
    _nameLab.width=nameWidth;
    _nameLab.text=name;
    
    //性别
    _sexImg.left=_nameLab.right;
    if ([userModel.sex isEqualToString:@"1"]) {
        textArr=@[@"他发起的",@"他参与的",@"他推荐的"];
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
        
    }
    else if([userModel.sex isEqualToString:@"2"])
    {
        textArr=@[@"她发起的",@"她参与的",@"她推荐的"];
        _sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    }
    else
    {
        textArr=@[@"TA发起的",@"TA参与的",@"TA推荐的"];
        _sexImg.image=nil;
    }
    
    //关注和粉丝
    NSString *friendText=Follow_And_Befollow(_friendNumber, _fansNumber);
    _friendLab.text=friendText;
    
    //基础信息
    NSInteger age= 0;
    [NSString stringWithFormat:@"%ld岁",age];
    if (userModel.birthday.length) {
        age=[NSDate getAgeFromBirthday:userModel.birthday];
    }
    //    NSString *personInfo=@"23岁、天枰座、50kg、170cm、单身";
    NSMutableString *personInfo1=[NSMutableString string];
    age>0?[personInfo1 appendString:[NSString stringWithFormat:@"%ld岁、",age]]:nil;
    userModel.constellation.length>0?[personInfo1 appendString:[NSString stringWithFormat:@"%@、",userModel.constellation]]:nil;
    userModel.weight>0?[personInfo1 appendString:[NSString stringWithFormat:@"%@kg、",userModel.weight]]:nil;
    
    userModel.height>0?[personInfo1 appendString:[NSString stringWithFormat:@"%@cm、",userModel.height]]:nil;
    NSString *marital=nil;
    if (userModel.maritalStatus) {
        if ([userModel.maritalStatus isEqual:@0]) {
            marital=@"单身";
        }
        else if([userModel.maritalStatus isEqual:@1])
        {
            marital=@"恋爱中";
        }
        else if ([userModel.maritalStatus isEqual:@2])
        {
            marital=@"已婚";
        }
    }
    userModel.maritalStatus?[personInfo1 appendString:[NSString stringWithFormat:@"%@",marital]]:nil;
    
    if ([personInfo1 hasSuffix:@"、"]) {
        [personInfo1 replaceCharactersInRange:NSMakeRange(personInfo1.length-1, 1) withString:@""];
    }
    _userInfoLab.text=personInfo1;
    
    if(_userZoomType==OtherZoomType)
    {
        _travelTypeView.items=textArr;
    }
}

-(void)setFansNumber:(NSInteger)fansNumber
{
    _fansNumber=fansNumber;
    NSString *friendText=Follow_And_Befollow(_friendNumber, _fansNumber);
    _friendLab.text=friendText;
}

-(void)addFXBlurView
{
    if (_blurView) {
        [_blurView removeFromSuperview];
    }
    //创建毛玻璃
    _blurView = [[FXBlurView alloc] initWithFrame:_iconBgView.bounds];
    [_blurView setDynamic:NO];
    _blurView.blurRadius=15;
    [self addSubview:_blurView];
    _blurColorView=[[UIView alloc]initWithFrame:_blurView.bounds];
    _blurColorView.backgroundColor=[UIColor ZYZC_MainColor];
    _blurColorView.alpha=0.9;
    [_blurView addSubview:_blurColorView];
    [self insertSubview:_blurView atIndex:1];
}

#pragma mark --- 点击头像进入个人信息设置
-(void)enterMyInfoSet
{
    BOOL hasLogin=[LoginJudgeTool judgeLogin];
    if (!hasLogin) {
        return;
    }
    MinePersonSetUpController *mineInfoSetVietrroller=[[MinePersonSetUpController alloc] init];
    mineInfoSetVietrroller.hidesBottomBarWhenPushed=YES;
    [self.viewController.navigationController pushViewController:mineInfoSetVietrroller animated:YES];
}

#pragma mark --- 控件随tableView的contentOffSet而改变
-(void)setProsuctTableOffSetY:(CGFloat)prosuctTableOffSetY
{
    _prosuctTableOffSetY=prosuctTableOffSetY;
    if (_userZoomType==OtherZoomType) {
        if (prosuctTableOffSetY>=-(User_Head_Height)&&prosuctTableOffSetY<=64-User_Head_Height) {
            CGFloat rate=MIN(1, (prosuctTableOffSetY+User_Head_Height)/64);
            _iconImgView.alpha=1-rate;
        }
        if (prosuctTableOffSetY>=-(User_Head_Height)&&prosuctTableOffSetY<=_iconImgView.height+KEDGE_DISTANCE-User_Head_Height) {
            CGFloat rate=MIN(1, (prosuctTableOffSetY+User_Head_Height)/(_iconImgView.height+KEDGE_DISTANCE));
            _baseInfoView.alpha=1-rate;
        }
    }
}

-(void)setFootprintTableOffSetY:(CGFloat)footprintTableOffSetY
{
    _footprintTableOffSetY=footprintTableOffSetY;
    if (footprintTableOffSetY>=-(My_User_Head_height)&&
        footprintTableOffSetY<=64-My_User_Head_height) {
        CGFloat rate=MIN(1, (footprintTableOffSetY+My_User_Head_height)/64);
            _iconImgView.alpha=1-rate;
    }
    if (footprintTableOffSetY>=-(My_User_Head_height)&&footprintTableOffSetY<_iconImgView.height+KEDGE_DISTANCE-My_User_Head_height) {
            CGFloat rate=MIN(1, (footprintTableOffSetY+My_User_Head_height)/(_iconImgView.height+KEDGE_DISTANCE));
        _baseInfoView.alpha=1-rate;
    }

}


@end
