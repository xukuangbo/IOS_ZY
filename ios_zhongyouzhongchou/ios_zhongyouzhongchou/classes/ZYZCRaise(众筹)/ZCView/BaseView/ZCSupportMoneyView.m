//
//  ZCSupportMoneyView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define Togther_Support(rate,money) [NSString stringWithFormat:@"一起去:支持%.f％旅费(%.2f)元",rate,money]
#define Return_support(money) [NSString stringWithFormat:@"回报支持:%.2f元",money]
#define OneYuan_Support       @"支持五元"
#define AnyYuan_support       @"支持任意金额："
#define LIMIT_MONEY           1000000.00

#import "ZCSupportMoneyView.h"
#import "ZYZCCustomTextField.h"
#import "ZCWSMView.h"
#import "ZCTotalPeopleView.h"
#import "ZCDetailCustomButton.h"
#import "ZCTotalPeopleView.h"
#import "UserModel.h"

@interface ZCSupportMoneyView ()<ZYZCCustomTextFieldDelegate>
//UI
@property (nonatomic, strong) UIView   *topLineView; //分隔线
@property (nonatomic, strong) UILabel  *titleLab;    //标题
@property (nonatomic, strong) ZYZCCustomTextField *textField;
@property (nonatomic, strong) UILabel  *yuanLab;
@property (nonatomic, strong) UILabel  *descLab;     //玩法描述
@property (nonatomic, strong) UIButton *supportBtn;  //支持按钮
@property (nonatomic, strong) UIButton *moreTextBtn; //展开更多按钮
@property (nonatomic, strong) UIView   *otherViews;
@property (nonatomic, strong) ZCWSMView *wsmView;     //描述内容
@property (nonatomic, strong) UILabel  *supportLab;   //已支持
@property (nonatomic, strong) UILabel  *limitLab;     //限额
@property (nonatomic, strong) UIView   *separateView; //分割线
@property (nonatomic, strong) UIView   *supportUserView;//支持的人
@property (nonatomic, strong) UIButton *morePeopleBtn;//更多支持的人按钮

//数据
@property (nonatomic, strong) ZCDetailProductModel     *productDetailModel;

@property (nonatomic, assign) CGFloat  normalHeight;
@property (nonatomic, assign) CGFloat  openHeight;

@end

@implementation ZCSupportMoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark --- 初始化（新）

- (instancetype)initWithFrame:(CGRect)frame andProductDetailModel:(ZCDetailProductModel *)productDetailModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _productDetailModel = productDetailModel;
        [self configUI];
        //支付结果的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayResult:) name:@"getPayResult" object:nil];
        //支持零元一起游后的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(supportStyle4ZeroYuanSuccess:) name:@"Support_Style4_ZeroYuan_Success" object:nil];
    }
    return self;
}

- (void)configUI
{
    //创建分割线
    _lineView=[UIView lineViewWithFrame:CGRectMake(0, 0, self.width, 1) andColor:nil];
    [self addSubview:_lineView];
    
    //标题
    _titleLab=[ZYZCTool createLabWithFrame:CGRectMake(0, 15, self.width, 20) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_RedTextColor]];
    [self addSubview:_titleLab];
    
    //编辑任意金额
    _textField=[[ZYZCCustomTextField alloc]initWithFrame:CGRectMake(_titleLab.right, _titleLab.top-2, 80, _titleLab.height+4)];
    _textField.customTextFieldDelegate=self;
    _textField.placeholder=@"¥";
    _textField.backgroundColor= [UIColor ZYZC_TabBarGrayColor];
    _textField.font=[UIFont systemFontOfSize:14];
    _textField.showTextInAccess=YES;
    _textField.keyboardType=UIKeyboardTypeDecimalPad;
    [self addSubview:_textField];
    _textField.hidden = YES;
    WEAKSELF
    _textField.tapBgViewBlock=^()
    {
        [weakSelf keyboardHidden];
    };
    
    UILabel *lab=[ZYZCTool createLabWithFrame:CGRectMake(0, _titleLab.top, 20, _titleLab.height) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    lab.text=@"元";
    [self addSubview:lab];
    _yuanLab=lab;
    _yuanLab.hidden=YES;

    //支持按钮
    _supportBtn=[ZYZCTool createBtnWithFrame:CGRectMake(self.width-30, 5, 40, 40) andNormalTitle:nil andNormalTitleColor:nil andTarget:self andAction:@selector(supportMoney:)];
       [self addSubview:_supportBtn];
    
    //介绍文字
    _descLab=[ZYZCTool createLabWithFrame:CGRectMake(0, _titleLab.bottom+KEDGE_DISTANCE, self.width-30, 0.1) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [self addSubview:_descLab];
    
    //添加更多按钮
    _moreTextBtn=[ZYZCTool createBtnWithFrame:CGRectMake(self.width-30, 105, 15, 10) andNormalTitle:@"..." andNormalTitleColor:[UIColor ZYZC_TextBlackColor] andTarget:self andAction:@selector(openMoreText)];
    [self addSubview:_moreTextBtn];
    _moreTextBtn.hidden=YES;
    
    //其他UI
    _otherViews=[[UIView alloc]initWithFrame:CGRectMake(0, _descLab.bottom+KEDGE_DISTANCE, self.width, 20)];
    [self addSubview:self.otherViews];
    
    //描述内容
    _wsmView=[[ZCWSMView alloc]initWithFrame:CGRectMake(0, 0, _otherViews.width, 0.1)];
    [_otherViews addSubview:_wsmView];
    _wsmView.hidden=YES;
    
    //已支持
    _supportLab=[ZYZCTool createLabWithFrame:CGRectMake(0, 0, _otherViews.width, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [_otherViews addSubview:_supportLab];
    
    //限额
    _limitLab =[ZYZCTool createLabWithFrame:CGRectMake(0, 0, _otherViews.width, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [_otherViews addSubview:_limitLab];
    _limitLab.hidden=YES;
    
    //分割线
    _separateView = [UIView lineViewWithFrame:CGRectMake(0, 2.5, 1.0, 15) andColor:nil];
    [_otherViews addSubview:_separateView];
    _separateView.hidden=YES;
    
    //展示已支持的人
    _supportUserView=[[UIView alloc]initWithFrame:CGRectMake(0, _supportLab.bottom+KEDGE_DISTANCE, _otherViews.width, 0)];
    [_otherViews addSubview:_supportUserView];
    
    //更多按钮
    _morePeopleBtn=[ZYZCTool createBtnWithFrame:CGRectMake(self.width-80, _supportLab.top, 80, 20) andNormalTitle:nil andNormalTitleColor:nil andTarget:self andAction:@selector(morePeople)];
    [_otherViews addSubview:_morePeopleBtn];
    _morePeopleBtn.hidden=YES;
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn=[ZYZCTool getCustomBtnByTilte:@"更多" andImageName:@"btn_xxd" andtitleFont:[UIFont systemFontOfSize:15] andTextColor:nil andSpacing:2];
    [btn addTarget:self action:@selector(morePeople) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(30, 0, 50 ,20);
    [_morePeopleBtn addSubview:btn];
}

#pragma mark --- 加载数据
-(void)setReportModel:(ReportModel *)reportModel
{
    _reportModel=reportModel;
    NSString *title = nil;
    NSString *desc  = nil;
    NSString *supportText  =nil;
    NSInteger supportOrLeftNum=0;
    BOOL     showMoneyField=NO;
    BOOL     showWSMView   =NO;
    BOOL     hasLimitNum   =NO;
    if(reportModel.style)
    {
        if ([reportModel.style isEqual:@1]) {
            title = OneYuan_Support;
            desc  = ZYLocalizedString(@"skim_support_one_yuan");
            supportText=@"已支持:";
            supportOrLeftNum=reportModel.users.count;
        }
        else if ([reportModel.style isEqual:@2])
        {
            title = AnyYuan_support;
            desc  = ZYLocalizedString(@"skim_supoort_any_yuan");
            showMoneyField=YES;
            supportText=@"已支持:";
            supportOrLeftNum=reportModel.users.count;
        }
        else if ([reportModel.style isEqual:@3])
        {
            title = Return_support([reportModel.price floatValue]/100.0);
            desc  = ZYLocalizedString(@"skim_support_return");
            showWSMView=YES;
            hasLimitNum=YES;
            supportText=@"剩余:";
            supportOrLeftNum=[reportModel.people integerValue]-reportModel.users.count;
        }
        else if ([reportModel.style isEqual:@4])
        {
            CGFloat rate=0.0;
            if (_productDetailModel.spell_buy_price>0) {
                rate=[reportModel.price floatValue]/[_productDetailModel.spell_buy_price floatValue]*100.0;
            }
            title = Togther_Support(rate, [reportModel.price floatValue]/100.0);
            desc  = ZYLocalizedString(@"skim_support_together");
            showWSMView=YES;
            hasLimitNum=YES;
            supportText=@"已报名:";
            supportOrLeftNum=reportModel.users.count;
        }
        else
        {
            title = Return_support([reportModel.price floatValue]/100.0);
            desc  = ZYLocalizedString(@"skim_support_return");
            showWSMView=YES;
            hasLimitNum=YES;
            supportText=@"剩余:";
            supportOrLeftNum=[reportModel.people integerValue]-reportModel.users.count;
        }
    }
    
    //标题
    _titleLab.text=title;
    CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:title andFont:_titleLab.font andMaxWidth:self.width].width;
    _titleLab.width=titleWidth;
    
    //任意金额输入框
    if (showMoneyField) {
        _textField.hidden=NO;
        _textField.left=_titleLab.right;
        _yuanLab.hidden=NO;
        _yuanLab.left=_textField.right;
    }
    
    //介绍文字
    CGFloat descHeight=[ZYZCTool calculateStrByLineSpace:10.0 andString:desc andFont:_descLab.font andMaxWidth:_descLab.width].height;
    DDLog(@"descHeight:%.2f",descHeight);
    if (descHeight>75) {
        [_descLab addTarget:self action:@selector(openMoreText)];
        if (_supportStateModel.isOpenMoreDec) {
            _moreTextBtn.hidden=YES;
            _descLab.numberOfLines=0;
            _descLab.height=descHeight;
        }
        else
        {
            _moreTextBtn.hidden=NO;
            _descLab.numberOfLines=3;
            _descLab.height=75;
        }
    }
    else
    {
        _moreTextBtn.hidden=YES;
        _descLab.numberOfLines=0;
        _descLab.height=descHeight;
    }
    _descLab.attributedText=[ZYZCTool setLineDistenceInText:desc];
    
    _otherViews.top=_descLab.bottom+KEDGE_DISTANCE;
    //描述内容
    if (showWSMView) {
        _wsmView.hidden=NO;
         [_wsmView reloadDataByVideoImgUrl:reportModel.spellVideoImg andPlayUrl:reportModel.spellVideo andVoiceUrl:reportModel.spellVoice andVoiceLen:reportModel.spellVoiceLen andFaceImg:_productDetailModel.user.faceImg andDesc:reportModel.desc andImgUrlStr:reportModel.descImgs];
    }
    //限额
    if (hasLimitNum) {
        NSString *limitText=@"限额:";
        _limitLab.hidden=NO;
        //限额
        _limitLab.attributedText = [self customStringByString: [NSString stringWithFormat:@"%@%@位",limitText,reportModel.people]];
        
        CGFloat limit_width01=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%@位",limitText] andFont:_limitLab.font andMaxWidth:self.width].width;
        CGFloat limit_width02=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%@",reportModel.people] andFont:[UIFont boldSystemFontOfSize:15.f] andMaxWidth:self.width].width;
        _limitLab.width=MIN(limit_width01+limit_width02, 120.f);
        _separateView.hidden=NO;
        _separateView.left=_limitLab.right+20.f;
        _supportLab.left=_separateView.right+20.f;
        _limitLab.top=_wsmView.bottom+(_wsmView.height>10)*KEDGE_DISTANCE;
        _separateView.top=_limitLab.top+2.5;
    }
    
    //已支持
    _supportLab.attributedText = [self customStringByString:[NSString stringWithFormat:@"%@%ld位",supportText,supportOrLeftNum]];
    
    CGFloat support_width01=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%@位",supportText] andFont: _supportLab.font andMaxWidth:self.width].width;
    CGFloat support_width02=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%ld",supportOrLeftNum] andFont:[UIFont boldSystemFontOfSize:15.f] andMaxWidth:self.width].width;
    _supportLab.width=MIN(support_width01+support_width02, 120.f);
    _supportLab.top=_wsmView.bottom+(_wsmView.height>10)*KEDGE_DISTANCE;
    
    //支持的人
    NSInteger number=reportModel.users.count;
    NSArray *views=[_supportUserView subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    _supportUserView.top=_supportLab.bottom+KEDGE_DISTANCE;
    if (number==0) {
        _supportUserView.height=0.1;
        _otherViews.height=_supportUserView.bottom;
        self.height=_otherViews.bottom;
    }
    else
    {
        if (number>6) {
            number=6;
            _morePeopleBtn.top=_supportLab.top;
            _morePeopleBtn.hidden=NO;
        }
        CGFloat btn_width=40*KCOFFICIEMNT;
        CGFloat btn_edg=(self.width-btn_width*6)/5;
        for (int i=0; i<number; i++) {
            UserModel *user=reportModel.users[i];
            ZCDetailCustomButton *iconBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake((btn_width+btn_edg)*i, 0, btn_width, btn_width)];
            iconBtn.userId=user.userId;
            [iconBtn sd_setImageWithURL:[NSURL URLWithString:user.img?user.img:user.faceImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_hh"]];
            [_supportUserView addSubview:iconBtn];
        }
        _supportUserView.height=btn_width;
        _otherViews.height=_supportUserView.bottom;
        self.height=_otherViews.bottom+KEDGE_DISTANCE;
    }
    
}

#pragma mark --- 加载UI状态
- (void) setSupportStateModel:(SupportStateModel *)supportStateModel
{
    _supportStateModel = supportStateModel;
    
    //支持按钮状态
    if (!supportStateModel.canChoose) {
        [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support"] forState:UIControlStateNormal];
    }
    else
    {
        if (supportStateModel.productEnd||supportStateModel.isGetMax) {
            [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support"] forState:UIControlStateNormal];
        }
        else
        {
            if (supportStateModel.isChoose) {
                [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support_pre"] forState:UIControlStateNormal];
            }
            else
            {
                [_supportBtn setImage:[UIImage imageNamed:@"Butttn_support-1"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark --- 任意金额开始输入
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_supportStateModel.productEnd) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark --- 任意金额点击确定
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text floatValue]>LIMIT_MONEY) {
        textField.text=nil;
        [textField resignFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitAlertShow) name:UIKeyboardDidHideNotification object:nil];
    }
    else
    {
        [self keyboardHidden];
    }
    
    return YES;
}

-(void)limitAlertShow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"支持金额不能超过一百万!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark --- 任意金额输入后键盘消失操作
-(void)keyboardHidden
{
    if ([_textField.text floatValue]>0) {
        _supportStateModel.isChoose=NO;
    }
    else
    {
        _supportStateModel.isChoose=YES;
    }
    [self supportMoney:_supportBtn];
}


#pragma mark --- 展开描述
- (void) openMoreText
{
    _supportStateModel.isOpenMoreDec=!_supportStateModel.isOpenMoreDec;
    [self.getSuperTableView reloadData];
}

#pragma mark --- 展示更多支持的人
- (void) morePeople
{
    ZCTotalPeopleView *totalView=[[ZCTotalPeopleView alloc]init];
    [self.viewController.view addSubview:totalView];
    totalView.users=_reportModel.users;
}

#pragma mark --- 支持／取消支持
-(void)supportMoney:(UIButton *)button
{
    //不可选
    if (!_supportStateModel.canChoose) {
        return;
    }
    
    //众筹过期
    if (_supportStateModel.productEnd) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //达到最大限制
        if (_supportStateModel.isGetMax) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_limit") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            _supportStateModel.isChoose= !_supportStateModel.isChoose;
            [button setImage:[UIImage imageNamed:_supportStateModel.isChoose?@"Butttn_support_pre":@"Butttn_support-1"] forState:UIControlStateNormal];
        }
    }
    
    //发出支持状态的通知
    //取消选择，金额设置为－1
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSNumber *money = nil;
    if (!_supportStateModel.isChoose) {
        money = @(-1);
    }
    else
    {
        if ([_reportModel.style isEqual:@2]) {
            if (!_textField.text.length) {
                money=@0;
            }
            else
            {
                CGFloat anyMoney=[_textField.text floatValue];
                money=[NSNumber numberWithFloat:anyMoney];
            }
        }
        else
        {
            money=[NSNumber numberWithFloat:[_reportModel.price floatValue]/100.0];
        }
    }
    [dic setObject:money forKey:[NSString stringWithFormat:@"style%@",_reportModel.style]];
    [[NSNotificationCenter defaultCenter] postNotificationName:KCAN_SUPPORT_MONEY object:dic];
}

-(void) getPayResult:(NSNotification *)notify
{
    if (_supportStateModel.isChoose) {
       [self supportMoney:_supportBtn];
    }
}

-(void)supportStyle4ZeroYuanSuccess:(NSNotification *)notify
{
    if ([_reportModel.style isEqual:@4]&&_supportStateModel.isChoose) {
        [self supportMoney:_supportBtn];
    }
}

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

- (void)dealloc
{
//    DDLog(@"dealloc:%@",[self class]);
    [ZYNSNotificationCenter removeObserver:self];
}


@end
