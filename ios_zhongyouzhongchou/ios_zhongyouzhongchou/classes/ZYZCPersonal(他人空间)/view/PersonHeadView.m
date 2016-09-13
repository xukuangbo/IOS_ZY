//
//  PersonHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define FOLLIOW_AND_BEFOLLOW(follow,befollow)  [NSString stringWithFormat:@"关注 %ld   ｜   粉丝 %ld",follow,befollow]

#import "PersonHeadView.h"
#import "FXBlurView.h"
#import "ZYZCRCManager.h"
#import "MinePersonSetUpController.h"
#import "NSDate+RMCalendarLogic.h"
#import "LoginJudgeTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZoomImageVIew.h"
@interface PersonHeadView ()
@property (nonatomic, strong) UIImageView *infoView;
@property (nonatomic, strong) ZYZoomImageVIew *faceImgView;
@property (nonatomic, strong) UILabel     *attentionLab;
@property (nonatomic, strong) UIView      *baseInfoView;
@property (nonatomic, strong) UIButton    *preButton;
@property (nonatomic, strong) UIView      *moveLineView;
@property (nonatomic, strong) UIButton    *addInterestBtn;
@property (nonatomic, strong) UIButton    *chatBtn;
@property (nonatomic, strong) FXBlurView  *blurView;
@property (nonatomic, strong) UIView      *blurColorView;
@property (nonatomic, strong) UILabel     *nameLab;
@property (nonatomic, strong) UIImageView *sexImg;
@property (nonatomic, strong) UILabel  *personInfoLab;
@property (nonatomic, strong) ZYZCRCManager *RCManager;

@property (nonatomic, strong) UIButton    *loginButton;
@end

@implementation PersonHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithType:(BOOL)isMineView
{
    self = [super init];
    if (self) {
        _isMineView=isMineView;
        self.frame=CGRectMake(0, 0, KSCREEN_W, HEAD_VIEW_HEIGHT);
        if (_isMineView) {
            self.height=MY_HEAD_VIEW_HEIGHT;
        }
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    //背景图
    _infoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-45)];
    if (_isMineView) {
        _infoView.height=self.height;
    }
    _infoView.contentMode=UIViewContentModeScaleAspectFill;
    _infoView.layer.masksToBounds=YES;
    _infoView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _infoView.image=[UIImage imageNamed:@"icon_placeholder"];
    [self addSubview:_infoView];
    [self addFXBlurView];
    //头像
    CGFloat faceWidth=80*KCOFFICIEMNT;
    _faceImgView=[[ZYZoomImageVIew alloc]initWithFrame:CGRectMake((self.width-faceWidth)/2, 64, faceWidth, faceWidth)];
    _faceImgView.image=[UIImage imageNamed:@"icon_placeholder"];
    _faceImgView.layer.cornerRadius=KCORNERRADIUS;
    _faceImgView.layer.masksToBounds=YES;
    _faceImgView.layer.borderWidth=2;
    _faceImgView.layer.borderColor=[UIColor whiteColor].CGColor;
    [self addSubview:_faceImgView];
    
    if(_isMineView)
    {
        [_faceImgView addTarget:self action:@selector(enterMyInfoSet)];
    }
    
    //基本信息
    _baseInfoView=[[UIView alloc]initWithFrame:CGRectMake(0, _faceImgView.bottom+KEDGE_DISTANCE, self.width, _infoView.bottom-30-_faceImgView.bottom-3*KEDGE_DISTANCE)];
    [self addSubview:_baseInfoView];
    
    //名字
    _nameLab=[self createLabWithFrame:CGRectMake(0, 0, 0, 0) andText:nil andTextColor:[UIColor whiteColor] andFont:[UIFont boldSystemFontOfSize:22] andTextAlignment:NSTextAlignmentRight];
    [_baseInfoView addSubview:_nameLab];
    
    //性别
    _sexImg=[[UIImageView alloc]init];
    [_baseInfoView addSubview:_sexImg];
    
    //关注和粉丝
    _attentionLab=[self createLabWithFrame:CGRectMake(0, 0, 0, 0)  andText:nil andTextColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:13] andTextAlignment:NSTextAlignmentCenter];
    [_baseInfoView addSubview:_attentionLab];
    
    //基础信息
    _personInfoLab=[self createLabWithFrame:CGRectMake(0, 0, 0, 0)  andText:nil andTextColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:13] andTextAlignment:NSTextAlignmentCenter];
    [_baseInfoView addSubview:_personInfoLab];
    
}

-(void)addFXBlurView
{
    if (_blurView) {
        [_blurView removeFromSuperview];
    }
    //创建毛玻璃
    _blurView = [[FXBlurView alloc] initWithFrame:_infoView.bounds];
    [_blurView setDynamic:NO];
    _blurView.blurRadius=10;
    [self addSubview:_blurView];
    _blurColorView=[[UIView alloc]initWithFrame:_blurView.bounds];
    _blurColorView.backgroundColor=[UIColor ZYZC_MainColor];
    _blurColorView.alpha=0.7;
    [_blurView addSubview:_blurColorView];
    [self insertSubview:_blurView atIndex:1];
    
}

-(void)setUserModel:(UserModel *)userModel
{
    NSArray *textArr=nil;
    
    if (![_userModel.faceImg isEqualToString:userModel.faceImg]) {
        [_faceImgView sd_setImageWithURL:[NSURL URLWithString:userModel.faceImg] placeholderImage:nil options: SDWebImageRetryFailed | SDWebImageLowPriority];
        _faceImgView.urlString=userModel.faceImg640?userModel.faceImg640:userModel.faceImg;
        
        [_infoView sd_setImageWithURL:[NSURL URLWithString:userModel.faceImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self addFXBlurView];
        }];
    }
    //名字
    UIFont *font=_nameLab.font;
    NSString *name=userModel.realName?userModel.realName:userModel.userName;
    CGFloat nameWidth=[ZYZCTool calculateStrLengthByText:name andFont:font andMaxWidth:self.width].width;
    if (nameWidth>self.width-40) {
        nameWidth=self.width-40;
    }
    _nameLab.frame=CGRectMake(self.width/2-(nameWidth+20)/2, 0, nameWidth, 30);
    _nameLab.text=name;
    
    //性别
    _sexImg.frame=CGRectMake(_nameLab.right, _nameLab.top+5, 20, 20);
//    NSLog(@"sex:%@",userModel.sex);
    if ([userModel.sex isEqualToString:@"1"]) {
        textArr=@[@"他发起的",@"他参与的",@"他推荐的"];
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
        
    }
    else if([userModel.sex isEqualToString:@"2"])
    {
        textArr=@[@"她发起的",@"她参与的",@"她推荐的"];
        _sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    }
    else if([userModel.sex isEqualToString:@"0"])
    {
        textArr=@[@"ta发起的",@"ta参与的",@"ta推荐的"];
        _sexImg.image=nil;
    }

    
    
    //关注和粉丝
    NSString *attentionText=FOLLIOW_AND_BEFOLLOW([_meGzAll integerValue], [_gzMeAll integerValue]);
    _attentionLab.frame=CGRectMake(KEDGE_DISTANCE, _nameLab.bottom, self.width-2*KEDGE_DISTANCE, 15);
    _attentionLab.text=attentionText;
    
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
    _personInfoLab.frame=CGRectMake(KEDGE_DISTANCE, _attentionLab.bottom+5, _attentionLab.width, 15);
    _personInfoLab.text=personInfo1;

    
    if (_isMineView) {
        return;
    }
    //他发起，他参与，他推荐
    
    UIView *clickView=[[UIView alloc]initWithFrame:CGRectMake(0, _infoView.bottom, self.width, 45)];
    clickView.backgroundColor=[UIColor whiteColor];
    [self addSubview:clickView ];
    [clickView addSubview:[UIView lineViewWithFrame:CGRectMake(0, clickView.height-1, self.width, 1) andColor:nil]];
    
    CGFloat buttonWidth=70;
    CGFloat edg=(self.width-buttonWidth*3)/4;
    for (int i=0; i<3; i++) {
        UIButton *button=[self createButtonWithFrame:CGRectMake(edg+(buttonWidth+edg)*i,0, buttonWidth,clickView.height) andTag:KPERSON_PRODUCT_TYPE+i andNeedBorder:NO andText:textArr.count==3?textArr[i]:nil andTextColor:[UIColor ZYZC_TextGrayColor]];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [clickView addSubview:button];
        if (i==0) {
            [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
            _preButton=button;
        }
    }
    _moveLineView=[UIView lineViewWithFrame:CGRectMake(_preButton.left,clickView.height-2 , buttonWidth, 2) andColor:[UIColor ZYZC_MainColor]];
    [clickView addSubview:_moveLineView];
    
    [self clickButton:_preButton];
    
    _userModel=userModel;
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

-(void)setFriendship:(BOOL )friendship
{
    _friendship=friendship;
    //加关注
    _addInterestBtn=[self createButtonWithFrame:CGRectMake(30, _infoView.bottom-KEDGE_DISTANCE-30, 100, 30) andTag:AddInterest andNeedBorder:YES  andText:_friendship?@"取消关注":@"＋  关注" andTextColor:[UIColor whiteColor]];
    [self addSubview:_addInterestBtn];
    //留言
    _chatBtn=[self createButtonWithFrame:CGRectMake(self.width-130, _addInterestBtn.top, 100, 30) andTag:ChatType andNeedBorder:YES  andText:@"私信" andTextColor:[UIColor whiteColor]];
    [self addSubview:_chatBtn];

}

#pragma mark ---创建button
-(UIButton *)createButtonWithFrame:(CGRect)frame andTag:(NSInteger )tag andNeedBorder:(BOOL )needborder  andText:(NSString *)text andTextColor:(UIColor *)textColor
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    button.tag=tag;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    if (needborder) {
        button.layer.cornerRadius=KCORNERRADIUS;
        button.layer.masksToBounds=YES;
        button.layer.borderWidth=1.5;
        button.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark --- 创建lable
-(UILabel *)createLabWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)textColor andFont:(UIFont *)font andTextAlignment:(NSTextAlignment )alignment
{
    UILabel *lab=[[UILabel alloc]init];
    lab.frame=frame;
    lab.text=text;
    lab.textColor=textColor;
    lab.font=font;
    lab.textAlignment=alignment;
    return lab;
}

#pragma mark --- button点击事件
-(void)clickButton:(UIButton *)button
{
    if (_preButton==button) {
        return;
    }
    //发布，参与，推荐
    if (button.tag>=PublishType&&button.tag<=RecommendType) {
        
        if (_changeProduct) {
            _changeProduct(button.tag);
        }

        if (_preButton&&_preButton!=button) {
            [_preButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
        __weak typeof (&*self)weakSelf=self;
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.moveLineView.left=button.left;
        }];
        _preButton=button;
        
    }
    //添加关注／取消关注
    if (button.tag==AddInterest) {
        
        [self addOrDeleteFollow];
    }
    //留言
    else if(button.tag==ChatType)
    {
//        NSLog(@"留言");
        [self chat];
    }
}

#pragma mark --- 留言

-(void)chat
{

    _RCManager=[ZYZCRCManager defaultManager];
    [_RCManager connectTarget:[NSString stringWithFormat:@"%@",_userModel.userId] andTitle:_userModel.realName?_userModel.realName:_userModel.userName  andSuperViewController:self.viewController];
}

#pragma mark --- 添加关注／取消关注
-(void)addOrDeleteFollow{
    
     NSDictionary *params=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":_userModel.userId};
//    NSLog(@"params:%@",params);
    if (_friendship) {
        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:UNFOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
        {
//            NSLog(@"%@",result);
            if (isSuccess) {
            [MBProgressHUD showSuccess:@"取消成功"];
            [_addInterestBtn setTitle:@"＋  关注" forState:UIControlStateNormal];
            
            _gzMeAll=[NSNumber numberWithInteger:([_gzMeAll integerValue]-1)];
            _attentionLab.text=FOLLIOW_AND_BEFOLLOW([_meGzAll integerValue], [_gzMeAll integerValue]);
            _friendship=!_friendship;
            }
            else
            {
                [MBProgressHUD showSuccess:@"取消失败"];
            }
        }
        andFailBlock:^(id failResult) {
            [MBProgressHUD showSuccess:@"取消失败"];
        }];
        
    }
        //添加关注
    else
    {
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:FOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
//            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"关注成功"];
                [_addInterestBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            
            _gzMeAll=[NSNumber numberWithInteger:([_gzMeAll integerValue]+1)];
            _attentionLab.text=FOLLIOW_AND_BEFOLLOW([_meGzAll integerValue], [_gzMeAll integerValue]);
             _friendship=!_friendship;
            }
            else
            {
                [MBProgressHUD showSuccess:@"关注失败"];
            }
            
        } andFailBlock:^(id failResult) {
            [MBProgressHUD showSuccess:@"关注成功"];
            
        }];
    }
}

#pragma mark --- 控件随tableView的contentOffSet而改变
-(void)setTableOffSetY:(CGFloat)tableOffSetY
{
    _tableOffSetY=tableOffSetY;
    
    if (_isMineView) {
        
        if (tableOffSetY>=0) {
            CGFloat rate01=MIN(1, tableOffSetY/(_baseInfoView.top-64));
            _baseInfoView.alpha=1-rate01;
            CGFloat rate02=MIN(1, tableOffSetY/_faceImgView.top);
            _faceImgView.alpha=1-rate02;
        }
        return;
    }
    if (tableOffSetY>=-(HEAD_VIEW_HEIGHT)&&tableOffSetY<=64-HEAD_VIEW_HEIGHT) {
        CGFloat rate=MIN(1, (tableOffSetY+HEAD_VIEW_HEIGHT)/64);
        
        _faceImgView.alpha=1-rate;
    }
    
    if (tableOffSetY>=-(HEAD_VIEW_HEIGHT)&&tableOffSetY<=_faceImgView.height+KEDGE_DISTANCE-HEAD_VIEW_HEIGHT) {
        CGFloat rate=MIN(1, (tableOffSetY+HEAD_VIEW_HEIGHT)/(_faceImgView.height+KEDGE_DISTANCE));
        
        _baseInfoView.alpha=1-rate;
    }
}

#pragma mark --- 清除数据
-(void)cleanUI
{
    _infoView.image=[UIImage imageNamed:@"icon_placeholder"];
    [self addFXBlurView];
    _faceImgView.image=[UIImage imageNamed:@"icon_placeholder"];
    _nameLab.text=@"";
    _sexImg.image=nil;
    _attentionLab.text=@"";
    _personInfoLab.text=@"";
    
    if (!_loginButton) {
        _loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame=CGRectMake(0, _faceImgView.bottom+20, 120, 40) ;
        _loginButton.centerX=self.centerX;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius=KCORNERRADIUS;
        _loginButton.layer.masksToBounds=YES;
        _loginButton.backgroundColor=[UIColor whiteColor];
        [self addSubview:_loginButton];
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    _loginButton.hidden=NO;
}

#pragma mark --- 登录
-(void)login
{
    [LoginJudgeTool judgeLogin];
}

-(void)setHiddenLoginBtn:(BOOL)hiddenLoginBtn
{
    _hiddenLoginBtn=hiddenLoginBtn;
    _loginButton.hidden=hiddenLoginBtn;
}

@end
