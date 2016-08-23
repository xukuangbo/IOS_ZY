//
//  ZCSupportBaseView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportBaseView.h"
#import "UIView+GetSuperTableView.h"
#import "UserModel.h"
#import "ZCDetailCustomButton.h"
@interface ZCSupportBaseView ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
//确认支付或取消支付

@end
@implementation ZCSupportBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initSupportViewByTop:(CGFloat   )top
                            andTitle:(NSString *)title
                             andText:(NSString *)text
{
    
    self = [super init];
    if (self) {
        self.frame=CGRectMake(2*KEDGE_DISTANCE, top, KSCREEN_W-4*KEDGE_DISTANCE, 0);
        _title=title;
        _text=text;
        _chooseSupport=YES;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //创建分割线
    _lineView=[UIView lineViewWithFrame:CGRectMake(0, 0, self.width, 1) andColor:nil];
    [self addSubview:_lineView];
    
    //标题
    CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:_title andFont:[UIFont systemFontOfSize:15] andMaxWidth:self.width].width;
    titleWidth=MIN(titleWidth, self.width-50);
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleWidth, 20)];
    _titleLab.text=_title;
    _titleLab.font=[UIFont systemFontOfSize:15];
    _titleLab.textColor=[UIColor ZYZC_RedTextColor];
    [_titleLab sizeToFit];
    [self addSubview:_titleLab];
    
    //支持按钮
    _supportBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _supportBtn.frame=CGRectMake(self.width-40, 5, 40, 40);
    [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support-1"] forState:UIControlStateNormal];
    [_supportBtn addTarget:self action:@selector(supportMoney) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_supportBtn];
    
    //文字部分
    
    //内容介绍
    CGFloat textWidth =self.width-30;
    CGFloat textHeight=[ZYZCTool calculateStrByLineSpace:10.0 andString:_text andFont:[UIFont systemFontOfSize:15] andMaxWidth:textWidth].height;
    _textOpenHeight=textHeight;
    if (textHeight>75) {
        _textNormalHeight=75;
        textHeight=75;
        //添加更多按钮
        _moreTextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _moreTextBtn.frame=CGRectMake(self.width-30, 105, 15, 10);
        [_moreTextBtn setTitle:@"..." forState:UIControlStateNormal];
        [_moreTextBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
//        _moreTextBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 26, 0, 0);
        [_moreTextBtn addTarget:self action:@selector(openMoreText) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreTextBtn];
    }
    //添加内容标签
    _textLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _titleLab.bottom+KEDGE_DISTANCE, textWidth, textHeight)];
    _textLab.font=[UIFont systemFontOfSize:15];
    _textLab.numberOfLines=3;
    _textLab.attributedText=[ZYZCTool setLineDistenceInText:_text];
    _textLab.textColor=[UIColor ZYZC_TextBlackColor];
    [self addSubview:_textLab];
    
    if (textHeight>=75) {
        _textLab.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMoreText)];
        [_textLab addGestureRecognizer:tap];
    }
    _otherViews=[[UIView alloc]initWithFrame:CGRectMake(0, _textLab.bottom+KEDGE_DISTANCE, self.width, 20)];
    [self addSubview:self.otherViews];
    
    //添加已支持标签
    _hasSupportLab=[[UILabel alloc]init];
    _hasSupportLab.frame=CGRectMake(0, 0, _otherViews.width, 20);
    _hasSupportLab.font=[UIFont systemFontOfSize:13];
    _hasSupportLab.textColor=[UIColor ZYZC_TextBlackColor];
    _hasSupportLab.attributedText=[self customStringByString:HAS_SUPPORT_PEOPLE(0)];
    [_otherViews addSubview:_hasSupportLab];
    
    //添加限额标签
    _limitLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    _limitLab.font=[UIFont systemFontOfSize:13];
    _limitLab.textColor=[UIColor ZYZC_TextBlackColor];
    _limitLab.attributedText=[self customStringByString:LIMIT_SUPPORT_PEOPLE(0)];
    [self.otherViews addSubview:_limitLab];
    
    [_limitLab addSubview:[UIView lineViewWithFrame:CGRectMake(_limitLab.right-1, 2.5, 1, 15) andColor:nil]];
    
    //展示已支持的人
    _supportPeople=[[UIView alloc]init];
    [_otherViews addSubview:_supportPeople];
    
    //更多按钮
    _morePeopleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _morePeopleBtn.frame=CGRectMake(self.width-80, _hasSupportLab.top, 80, 40) ;
    [_morePeopleBtn addTarget:self action:@selector(morePeople) forControlEvents:UIControlEventTouchUpInside];
    _morePeopleBtn.hidden=YES;
    [_otherViews addSubview:_morePeopleBtn];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn=[ZYZCTool getCustomBtnByTilte:@"更多" andImageName:@"btn_xxd" andtitleFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(morePeople) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(30, 0, 50 ,30);
    [_morePeopleBtn addSubview:btn];

    self.height=_otherViews.bottom+KEDGE_DISTANCE;
    
//    [self addTarget:self action:@selector(changeSupportState)];
}

//-(void)changeSupportState
//{
//    if (_moreTextBtn) {
//        [self openMoreText];
//    }
//    else
//    {
//        self.sureSupport=!self.sureSupport;
//    }
//}

#pragma mark --- 展开更多文字
-(void)openMoreText
{
    if (!_isOpenText) {
        _textLab.numberOfLines=0;
        _textLab.height=_textOpenHeight;
        _moreTextBtn.hidden=YES;
    }
    else
    {
        _textLab.numberOfLines=3;
        _textLab.height=_textNormalHeight;
        _moreTextBtn.hidden=NO;
    }
    
    _otherViews.top=_textLab.bottom+KEDGE_DISTANCE;
    self.height=_otherViews.bottom+KEDGE_DISTANCE;
    _isOpenText=!_isOpenText;
    [self.getSuperTableView reloadData];
    
//    self.sureSupport=!self.sureSupport;
}

#pragma mark --- 限额人数
-(void)setLimitNumber:(int)limitNumber
{
    _limitLab.attributedText=[self customStringByString:LIMIT_SUPPORT_PEOPLE(limitNumber)];
}

#pragma mark --- 支持的人
-(void)setUsers:(NSArray *)users
{
    _users=users;
     self.hasSupportLab.attributedText=[self customStringByString:HAS_SUPPORT_PEOPLE((int)users.count)];
    if (users.count>0) {
        //_supportPeople frame赋值
        _supportPeople.frame=CGRectMake(0, _hasSupportLab.bottom+KEDGE_DISTANCE, self.width, 40*KCOFFICIEMNT);
        //某些frame发生变化
        _otherViews.height=_supportPeople.bottom;
        self.height=_otherViews.bottom+KEDGE_DISTANCE;
        
        //展示支持人头像，最多展示六个
        NSInteger number=users.count;
        
        NSArray *views=[_supportPeople subviews];
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
        
        if (number>6) {
            number=6;
            _morePeopleBtn.hidden=NO;
        }
        CGFloat btn_width=40*KCOFFICIEMNT;
        CGFloat btn_edg=(self.width-btn_width*6)/5;
        for (int i=0; i<number; i++) {
            UserModel *user=users[i];
            ZCDetailCustomButton *iconBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake((btn_width+btn_edg)*i, 0, btn_width, btn_width)];
            iconBtn.userId=user.userId;
            [iconBtn sd_setImageWithURL:[NSURL URLWithString:user.img?user.img:user.faceImg] forState:UIControlStateNormal];
            [_supportPeople addSubview:iconBtn];
        }
    }
}

#pragma mark --- 更多人展示
-(void)morePeople
{
    ZCTotalPeopleView *totalView=[[ZCTotalPeopleView alloc]init];
    [self.viewController.view addSubview:totalView];
    totalView.users=self.users;
}

#pragma mark --- 支持金额
-(void)supportMoney
{
    if(_productEndTime)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
     _sureSupport=!_sureSupport;
    if (_sureSupport) {
        [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support_pre"] forState:UIControlStateNormal];
    }
    else
    {
         [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support-1"] forState:UIControlStateNormal];
    }
    if (_supportBlock) {
        _supportBlock();
    }
}

-(void)setSureSupport:(BOOL)sureSupport
{
    _sureSupport=sureSupport;
    if (!_sureSupport) {
        [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support-1"] forState:UIControlStateNormal];
    }
    else
    {
        [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support_pre"] forState:UIControlStateNormal];
    }
    
    if (_supportBlock) {
        _supportBlock();
    }
}

#pragma mark --- 是否可支持
-(void)setChooseSupport:(BOOL)chooseSupport
{
    _chooseSupport=chooseSupport;
//    if (!_chooseSupport) {
//        _supportBtn.enabled=NO;
//    }
//    else
//    {
//        _supportBtn.enabled=YES;
//    }
}

#pragma mark --- 改变文字样式
-(NSAttributedString *)customStringByString:(NSString *)str
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[str rangeOfString:@":"];
    
    NSRange range2=[str rangeOfString:@"位"];
    
    if (str.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
    }
    return  attrStr;
}

@end
