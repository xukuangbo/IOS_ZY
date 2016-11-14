//
//  ZCDetailIntroFourthCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define title_text            @"和我一起去  旅费AA制"
#define button_text           @"报名一起去"
#define subTitle_text(money)  [NSString stringWithFormat:@"支持%.2f元旅费,就有机会和我一起去旅行哦!",money]

#import "ZCDetailIntroFourthCell.h"
#import "ZCDetailCustomButton.h"
#import "NSDate+RMCalendarLogic.h"
#import "UIView+GetSuperTableView.h"
#import "WXApiManager.h"
#import "ZCWSMView.h"
@interface ZCDetailIntroFourthCell ()
@property (nonatomic, strong) UILabel   *moneyLab;       //金额
@property (nonatomic, strong) UILabel   *rateLab;       //支持比例
@property (nonatomic, strong) ZCWSMView *wsmView;
@property (nonatomic, strong) UILabel  *limitLab;      //限额标签
@property (nonatomic, strong) UILabel  *supportLab;    //支持的人
@property (nonatomic, strong) UIView   *separateView;  //分割线
@property (nonatomic, strong) UIView   *supportUsersView; //支持的人
@property (nonatomic, strong) UIButton *supportBtn;       //支持按钮

@property (nonatomic, strong) NSArray     *users;
@property (nonatomic, strong) ReportModel *togtherModel;
@property (nonatomic, assign) BOOL        canChoose;
@property (nonatomic, assign) BOOL        isMySelf;
@property (nonatomic, assign) BOOL        hasSupport;
@property (nonatomic, assign) BOOL        productEnd;

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
    _canChoose=YES;
    _isMySelf=NO;
    _hasSupport=NO;
    _productEnd=NO;
    [self.topLineView removeFromSuperview];
    [self.vertical removeFromSuperview];
    self.titleLab.left=KEDGE_DISTANCE;
    self.titleLab.text=title_text;
    self.titleLab.textColor=[UIColor ZYZC_RedTextColor];
    self.titleLab.font=[UIFont boldSystemFontOfSize:17.f];
    
    //金额
    _moneyLab=[ZYZCTool createLabWithFrame:CGRectMake(0, self.titleLab.top, self.bgImg.width-KEDGE_DISTANCE, self.titleLab.height) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor blackColor]];
    _moneyLab.textAlignment=NSTextAlignmentRight;
    [self.bgImg addSubview:_moneyLab];
    [_moneyLab addTarget:self action:@selector(support)];
    
    //金额比例
    _rateLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, self.titleLab.bottom+KEDGE_DISTANCE, self.bgImg.width-2*KEDGE_DISTANCE, 20) andFont:[UIFont systemFontOfSize:12.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [self.bgImg addSubview:_rateLab];
    
    //回报内容
    _wsmView = [[ZCWSMView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _rateLab.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 0.1)];
    [self.bgImg addSubview:_wsmView];
    
    //限额人数
    _limitLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, _rateLab.bottom+KEDGE_DISTANCE, 0, 20) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [self.bgImg addSubview:_limitLab];
    
    //参与人数
    _supportLab = [ZYZCTool createLabWithFrame:CGRectMake(0, _rateLab.bottom+KEDGE_DISTANCE, 0, 20) andFont:_limitLab.font andTitleColor:_limitLab.textColor];
    [self.bgImg addSubview:_supportLab];
    
    _separateView = [UIView lineViewWithFrame:CGRectMake(0,_limitLab.top+2.5, 1.0, 15) andColor:nil];
    [self.bgImg addSubview:_separateView];
    _separateView.hidden=YES;

    _supportUsersView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _limitLab.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 0.1)];
    [self.bgImg addSubview:_supportUsersView];
    
    _supportBtn=[ZYZCTool createBtnWithFrame:CGRectMake(KEDGE_DISTANCE, _supportUsersView.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 40) andNormalTitle:button_text andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(support)];
    _supportBtn.backgroundColor = [UIColor ZYZC_MainColor];
    _supportBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _supportBtn.layer.cornerRadius = KCORNERRADIUS;
    _supportBtn.layer.masksToBounds = YES;
    [self.bgImg addSubview:_supportBtn];
    
//    //支付结果的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayResult:) name:@"getPayResult" object:nil];
//    //支持零元一起游后的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(supportStyle4ZeroYuanSuccess:) name:@"Support_Style4_ZeroYuan_Success" object:nil];
}

- (void) setDetailModel:(ZCDetailProductModel *)detailModel
{
    _detailModel=detailModel;
    ReportModel *togtherModel = nil;
    for (NSInteger i=0; i< detailModel.report.count; i++) {
        ReportModel *report = detailModel.report[i];
        if ([report.style isEqual:@4]) {
            togtherModel=report;
            break;
        }
    }
    self.togtherModel=togtherModel;
    
    detailModel.introFourthCellHeight=self.bgImg.height;
    
    //判断项目是否是浏览或草稿
    if ((_detailProductType==SkimDetailProduct)||
        (_detailProductType==DraftDetailProduct)) {
        _canChoose=NO;
    }
    //判断项目是否是自己的
    if ([detailModel.mySelf isEqual:@1]) {
        _isMySelf=YES;
    }
    
    //判断项目是否过期
    int leftDays=0;
    if (detailModel.spell_end_time.length>8) {
        NSString *productEndStr=[NSDate changStrToDateStr:detailModel.spell_end_time];
        NSDate *productEndDate=[NSDate dateFromString:productEndStr];
        leftDays=[NSDate getDayNumbertoDay:[NSDate date] beforDay:productEndDate]+1;
        if (leftDays<0) {
            leftDays=0;
        }
    }
    
    if (leftDays==0) {
        _productEnd=YES;
    }
    
    //判断是否已支持
    for (NSInteger i=0; i<togtherModel.users.count; i++) {
        UserModel *user=togtherModel.users[i];
        if ([user.userId integerValue] == [[ZYZCAccountTool getUserId] integerValue]) {
            _hasSupport=YES;
            break;
        }
    }


    if (!_canChoose||_isMySelf||_productEnd||_hasSupport) {
        _supportBtn.backgroundColor=[UIColor ZYZC_TabBarGrayColor];
        [_supportBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        _supportBtn.backgroundColor=[UIColor ZYZC_MainColor];
        [_supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (void) setTogtherModel:(ReportModel *)togtherModel
{
    _togtherModel = togtherModel;
    //金额
    _moneyLab.attributedText = [self customMoneyByString:[NSString stringWithFormat:@"¥ %.2f",[togtherModel.price floatValue]/100.0]];
    
    //金额比例
    CGFloat money_rate=0.0;
    if ([_detailModel.spell_buy_price floatValue]>0) {
        money_rate = [togtherModel.price floatValue] / [_detailModel.spell_buy_price floatValue]*100.0;
    }
    _rateLab.text = subTitle_text([togtherModel.price floatValue]/100.0);
    
    [_wsmView reloadDataByVideoImgUrl:togtherModel.spellVideoImg andPlayUrl:togtherModel.spellVideo andVoiceUrl:togtherModel.spellVoice andVoiceLen:togtherModel.spellVoiceLen andFaceImg:_detailModel.user.faceImg andDesc:togtherModel.desc andImgUrlStr:togtherModel.descImgs];
    
    //限额
    _limitLab.attributedText = [self customStringByString: [NSString stringWithFormat:@"限额:%@位",togtherModel.people]];
    
    //已支持
    _supportLab.attributedText = [self customStringByString:[NSString stringWithFormat:@"已报名:%ld位",togtherModel.users.count]];
    
    CGFloat limit_width01=[ZYZCTool calculateStrLengthByText:@"限额:位" andFont:_limitLab.font andMaxWidth:self.width].width;
    CGFloat limit_width02=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%@",togtherModel.people] andFont:[UIFont boldSystemFontOfSize:15.f] andMaxWidth:self.width].width;
    
    _limitLab.width=MIN(limit_width01+limit_width02, 120.f);
    _separateView.hidden=NO;
    _separateView.left=_limitLab.right+20.f;
    _supportLab.left=_separateView.right+20.f;
    
    CGFloat support_width01=[ZYZCTool calculateStrLengthByText:@"已报名:位" andFont: _supportLab.font andMaxWidth:self.width].width;
    CGFloat support_width02=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%ld",togtherModel.users.count] andFont:[UIFont boldSystemFontOfSize:15.f] andMaxWidth:self.width].width;
    _supportLab.width=MIN(support_width01+support_width02, 120.f);
    
    
    _limitLab.top=_wsmView.bottom+(_wsmView.height>10)*KEDGE_DISTANCE;
    _supportLab.top=_limitLab.top;
    _separateView.top=_limitLab.top;
    _supportUsersView.top=_limitLab.bottom+KEDGE_DISTANCE;

    //支持的人
    self.users = togtherModel.users;

    //一起游
    _supportBtn.top=_supportUsersView.bottom+KEDGE_DISTANCE;
    
    self.bgImg.height=_supportBtn.bottom+KEDGE_DISTANCE;
    
}

-(void) support
{
    _supportBtn.enabled=NO;
    if (!_canChoose||_isMySelf||_hasSupport) {
       
    }
    else
    {
        if(_productEnd)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        //可进行支持操作
        else
        {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithFloat:[_togtherModel.price floatValue]/100.0] forKey:@"style4"];
            [dic setObject:_detailModel.productId forKey:@"productId"];
            WXApiManager *wxManager=[WXApiManager sharedManager];
            [wxManager payForWeChat:dic payUrl:[[ZYZCAPIGenerate sharedInstance] API:@"weixinpay_generateAppOrder"] payType:1 withSuccessBolck:nil andFailBlock:nil];
        }
    }
    _supportBtn.enabled=YES;
}

#pragma mark --- 支持的人
-(void)setUsers:(NSArray *)users
{
    _users=users;
    if (users.count>0) {
        NSArray *views=[_supportUsersView subviews];
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
        CGFloat btn_width=40*KCOFFICIEMNT;
        CGFloat btn_edg=(self.bgImg.width-20-btn_width*6)/5;
        CGFloat last_btn_bottom=0.1;
        NSInteger number=users.count;
        for (int i=0; i<number; i++) {
            UserModel *user=users[i];
            ZCDetailCustomButton *iconBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake((btn_width+btn_edg)*(i%6), (btn_width+btn_edg)*(i/6), btn_width, btn_width)];
            iconBtn.userId=user.userId;
            [iconBtn sd_setImageWithURL:[NSURL URLWithString:user.img?user.img:user.faceImg] forState:UIControlStateNormal];
            last_btn_bottom=iconBtn.bottom;
            [_supportUsersView addSubview:iconBtn];
        }
        _supportUsersView.height=last_btn_bottom;
    }
}

//-(void) getPayResult:(NSNotification *)notify
//{
//    [self.getSuperTableView reloadData];
//}
//
//-(void) supportStyle4ZeroYuanSuccess:(NSNotification *)notify
//{
//    [self.getSuperTableView reloadData];
//}

#pragma mark --- 改变文字样式
-(NSAttributedString *)customStringByString:(NSString *)str
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[str rangeOfString:@":"];
    
    NSRange range2=[str rangeOfString:@"位"];
    
    if (str.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.f] range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
    }
    return  attrStr;
}

-(NSAttributedString *)customMoneyByString:(NSString *)str
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[str rangeOfString:@"¥ "];
    
    NSRange range2=[str rangeOfString:@"."];
    
    if (str.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.f] range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
    }
    return  attrStr;
}



@end
