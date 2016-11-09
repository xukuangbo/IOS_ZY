//
//  ZYZCOneProductCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCOneProductCell.h"
#import "NSDate+RMCalendarLogic.h"
#import "WalletMingXiVC.h"
#define KRAISE_MONEY(money)  [NSString stringWithFormat:@"预筹¥%.2f",money]
#define KSTART_TIME(time)     [NSString stringWithFormat:@"%@出发",time]

@interface ZYZCOneProductCell ()
@property (nonatomic, strong) UIImageView  *bgImg;
@property (nonatomic, strong) UILabel      *titleLab;
@property (nonatomic, strong) UILabel      *recommendLab;
@property (nonatomic, strong) UIImageView  *headImage;
@property (nonatomic, strong) UIImageView  *planeImg;
@property (nonatomic, strong) UILabel      *destLab;
@property (nonatomic, strong) UIScrollView *destScroll;
@property (nonatomic, strong) UIImageView  *destLayerImg;
@property (nonatomic, strong) UIView       *iconBgView;
@property (nonatomic, strong) ZCDetailCustomButton  *iconImage;
@property (nonatomic, strong) UILabel      *nameLab;
@property (nonatomic, strong) UIImageView  *sexImg;
@property (nonatomic, strong) UIImageView  *vipImg;
@property (nonatomic, strong) UILabel      *startDestLab;
@property (nonatomic, strong) UILabel      *destenceLab;
@property (nonatomic, strong) UILabel      *jobLab;
@property (nonatomic, strong) UILabel      *infoLab;
@property (nonatomic, strong) UILabel      *moneyLab;
@property (nonatomic, strong) UILabel      *startLab;
@property (nonatomic, strong) UIImageView  *emptyProgress;
@property (nonatomic, strong) UIImageView  *fillProgress;
@property (nonatomic, weak  ) ZCInfoView   *zcInfoView;
@property (nonatomic, strong) UIScrollView *interstView;
@property (nonatomic, strong) UIView       *lineView;

@property (nonatomic, strong) ZYZCEditProductView *editProductView;

@end

@implementation ZYZCOneProductCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}


#pragma mark ---创建UI
-(void)configUI
{
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, PRODUCT_CELL_HEIGHT)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    _bgImg.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImg];
    
    //添加标题
    _titleLab=[self createLabWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, _bgImg.width, 25) andFont:[UIFont systemFontOfSize:20] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _titleLab.text=@"走近神秘的高棉";
    [_bgImg addSubview:_titleLab];
    
    //添加推荐
    _recommendLab=[self createLabWithFrame:CGRectMake(_bgImg.width-100-KEDGE_DISTANCE, KEDGE_DISTANCE+5, 100, 20) andFont:[UIFont systemFontOfSize:14] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _recommendLab.textAlignment=NSTextAlignmentRight;
    _recommendLab.text=@"0人推荐";
    [_bgImg addSubview:_recommendLab];
    
    //添加风景图
    _headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, _titleLab.bottom+5, _bgImg.width, 135*KCOFFICIEMNT)];
    _headImage.image=[UIImage imageNamed:@"image_placeholder"];
    _headImage.contentMode=UIViewContentModeScaleAspectFill;
    _headImage.layer.masksToBounds=YES;
    [_bgImg addSubview:_headImage];
    
    //添加旅行目的地
    //添加底部视图
    _destLayerImg=[[UIImageView alloc]initWithFrame:CGRectMake(-KEDGE_DISTANCE+2, _headImage.top+7, 50, 30)];
    _destLayerImg.image=KPULLIMG(@"xjj_fuc", 0, 10, 0, 10);
    _destLayerImg.alpha=0.7;
    [_bgImg  addSubview:_destLayerImg];
    //添加✈️
    _planeImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,_headImage.top+15, 18, 17)];
    _planeImg.image=[UIImage imageNamed:@"btn_p"];
    [_bgImg addSubview:_planeImg];
    
    //给目的地添加滑动
    _destScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(20, _headImage.top+9, 0, 29)];
//    _destScroll.backgroundColor=[UIColor orangeColor];
    _destScroll.showsHorizontalScrollIndicator=NO;
    [_bgImg addSubview:_destScroll];
    
    //添加目的地
    _destLab=[self createLabWithFrame:CGRectMake(0, 0, 0, 29) andFont:[UIFont boldSystemFontOfSize:20] andTitleColor:[UIColor whiteColor]];
    [_destScroll addSubview:_destLab];
    
    //添加头像
    _iconBgView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _headImage.bottom-15, 82, 82)];
    _iconBgView.layer.cornerRadius=KCORNERRADIUS;
    _iconBgView.layer.masksToBounds=YES;
    _iconBgView.backgroundColor=[UIColor colorWithRed:170/255 green:170/255 blue:170/255 alpha:0.2];
    
    [_bgImg addSubview:_iconBgView];
    
    _iconImage=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(4, 4, 74, 74)];
    _iconImage.layer.cornerRadius=3;
    _iconImage.layer.masksToBounds=YES;
//    _iconImage.contentMode=UIViewContentModeScaleToFill;
//    _iconImage.userInteractionEnabled=NO;
    [_iconBgView addSubview:_iconImage];
    
    //添加姓名
    _nameLab=[self createLabWithFrame:CGRectMake(_iconBgView.right+ KEDGE_DISTANCE-4, _headImage.bottom+KEDGE_DISTANCE, 50, 20)  andFont:[UIFont systemFontOfSize:17] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _nameLab.text=@"杨大";
    [_bgImg addSubview:_nameLab];
    
    //添加性别
    _sexImg=[[UIImageView alloc]initWithFrame:CGRectMake(_nameLab.right+3, _nameLab.top, 20, 20)];
    //    _sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    [_bgImg addSubview:_sexImg];
    
    //添加vip
    _vipImg=[[UIImageView alloc]initWithFrame:CGRectMake(_sexImg.right+3, _nameLab.top+2, 16, 16)];
    _vipImg.image=[UIImage imageNamed:@"icon_id"];
    [_bgImg addSubview:_vipImg];
    _vipImg.hidden=YES;
    
    //添加出发地
    _startDestLab=[self createLabWithFrame:CGRectMake(_vipImg.right+KEDGE_DISTANCE, _nameLab.top, 0, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor whiteColor]];
    _startDestLab.layer.cornerRadius=3;
    _startDestLab.layer.masksToBounds=YES;
    _startDestLab.backgroundColor=[UIColor ZYZC_BgGrayColor02];
    _startDestLab.textAlignment=NSTextAlignmentCenter;
    [_bgImg addSubview:_startDestLab];
    
    //添加距离
    _destenceLab=[self createLabWithFrame:CGRectMake(_bgImg.width-80-KEDGE_DISTANCE, _nameLab.top, 80, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _destenceLab.textAlignment=NSTextAlignmentRight;
    _destenceLab.text=@"距离1.2km";
    [_bgImg addSubview:_destenceLab];
    _destenceLab.hidden=YES;
    
    //添加职业
    _jobLab=[self createLabWithFrame:CGRectMake(_nameLab.left, _nameLab.bottom+3, _bgImg.width-_nameLab.left-KEDGE_DISTANCE, 15) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _jobLab.text=@"建筑师";
    [_bgImg addSubview:_jobLab];
    
    //添加个人基础信息
    _infoLab=[self createLabWithFrame:CGRectMake(_nameLab.left, _jobLab.bottom+3, _bgImg.width-_nameLab.left-KEDGE_DISTANCE, 15) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _infoLab.text=@"30岁  处女座  45kg  172cm  单身";
    [_bgImg addSubview:_infoLab];
    
    //添加预筹资金
    _moneyLab=[self createLabWithFrame:CGRectMake(KEDGE_DISTANCE, _iconBgView.bottom+KEDGE_DISTANCE-4, _bgImg.width/2-KEDGE_DISTANCE, 15) andFont:[UIFont boldSystemFontOfSize:14] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _moneyLab.text=@"预筹¥5000";
    [_bgImg addSubview:_moneyLab];
    
    //添加出发时间
    _startLab=[self createLabWithFrame:CGRectMake(_moneyLab.right, _moneyLab.top, _bgImg.width/2-KEDGE_DISTANCE, 15) andFont:[UIFont boldSystemFontOfSize:14] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _startLab.textAlignment=NSTextAlignmentRight;
    _startLab.text=@"";
    [_bgImg addSubview:_startLab];
    
    //添加进度条
    _emptyProgress=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _moneyLab.bottom+5, _bgImg.width-2*KEDGE_DISTANCE, 5)];
    _emptyProgress.image=[UIImage imageNamed:@"bg_jdt"];
    [_bgImg addSubview:_emptyProgress];
    
    _fillProgress=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 5)];
    _fillProgress.image=KPULLIMG(@"jdt_up", 0, 2, 0, 2);
    [_emptyProgress addSubview:_fillProgress];
    
    //添加众筹进度相关数据
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZCInfoView" owner:nil options:nil];
    _zcInfoView=[nibView objectAtIndex:0];
    _zcInfoView.frame=CGRectMake(1, _emptyProgress.bottom+5, _bgImg.width-2, 40);
    [_bgImg addSubview:_zcInfoView];
    
    UIView *detailMoneyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _zcInfoView.width/3, 40)];
//    detailMoneyView.backgroundColor=[UIColor orangeColor];
    [_zcInfoView addSubview:detailMoneyView];
    [detailMoneyView addTarget:self action:@selector(enterDetailMoney)];
    
    //添加兴趣展示视图
    _interstView=[[UIScrollView alloc]initWithFrame:CGRectMake(_nameLab.left, _infoLab.bottom+3,  _infoLab.width, 22)];
    _interstView.contentSize=CGSizeMake( _infoLab.width, 0);
    _interstView.showsHorizontalScrollIndicator=NO;
    _interstView.bounces=NO;
    [_bgImg addSubview:_interstView];
    
    //添加项目编辑按钮
    _editProductView=[[ZYZCEditProductView alloc]initWithFrame:CGRectMake(0,_emptyProgress.bottom+50, _bgImg.width, 0)];
    _editProductView.hidden=YES;
    [_bgImg addSubview:_editProductView];
   
}

#pragma mark --- 更新UI和数据
-(void)setOneModel:(ZCOneModel *)oneModel
{
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    _oneModel=oneModel;
    _editProductView.userModel=oneModel.user;
    self.productType=oneModel.productType;
    _zcInfoView.height=40;
    NSDate *nowDate=[NSDate date];
    //标题
    _titleLab.text=oneModel.product.productName;
    //推荐人数
    _recommendLab.text=[NSString stringWithFormat:@"%@人推荐",oneModel.product.friendsCount?oneModel.product.friendsCount:@0];

    //风景图
    if (!_headImage.hidden) {
        if (oneModel.product.headImage.length) {
            [_headImage sd_setImageWithURL:[NSURL URLWithString:oneModel.product.headImage]  placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        }
    }
    NSString *startDest=nil;//出发地
    if (oneModel.product.productDest) {
        //计算目的地的文字长度
        NSMutableString *place=[NSMutableString string];
         //目的地为json数组，需要转换成数组再做字符串拼接
        NSArray *dest=[ZYZCTool turnJsonStrToArray:oneModel.product.productDest];
        startDest=[dest firstObject];
        NSInteger destNumber=dest.count;
        for (NSInteger i=1; i<destNumber;i++) {
            if (i==1) {
                [place appendString:dest[i]];
            }
            else
            {
                [place appendString:[NSString stringWithFormat:@"—%@",dest[i]]];
            }
        }
        //目的地文字长度
        CGFloat placeStrWidth=[ZYZCTool calculateStrLengthByText:place andFont:_destLab.font andMaxWidth:CGFLOAT_MAX].width;
        CGFloat placeBgWidth=placeStrWidth;
        placeBgWidth=MIN(placeBgWidth, self.bgImg.width-40);

        //推荐文字长度
        CGFloat recoWidth=[ZYZCTool calculateStrLengthByText:_recommendLab.text andFont:_recommendLab.font andMaxWidth:KSCREEN_W].width;
        
          if (oneModel.productType==ZCDetailProduct) {
              placeBgWidth=MIN(placeBgWidth, _bgImg.width-_destScroll.left-2*KEDGE_DISTANCE-recoWidth);
          }
          else
          {
              //标题文字长度
              CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:_titleLab.text andFont:_titleLab.font andMaxWidth:self.width].width;
              _titleLab.width=MIN(titleWidth, _bgImg.width-3*KEDGE_DISTANCE-recoWidth);
            }
        
        //改变目的地展示标签的长度
        _destLab.width=placeStrWidth;
        //改变目的地滑动条
        _destScroll.width=placeBgWidth;
        _destScroll.contentSize=CGSizeMake(placeStrWidth, 0);
        _destLab.text=place;
//        _destLab.backgroundColor=[UIColor purpleColor];
        //改变目的地背景条长度
        _destLayerImg.width=placeBgWidth+40;
    }
    //用户图像
    [_iconImage sd_setBackgroundImageWithURL:[NSURL URLWithString:oneModel.user.faceImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_placeholder"] options:options];
    _iconImage.userId=oneModel.user.userId;
    
    //出发地
    CGFloat destWidth=0.0;
    if (startDest.length>0) {
        _startDestLab.text=[NSString stringWithFormat:@"%@出发",startDest];
        destWidth=[ZYZCTool calculateStrLengthByText:_startDestLab.text andFont:_startDestLab.font andMaxWidth:self.width].width+10;
        destWidth=MIN(destWidth, 100);
        _startDestLab.left=_bgImg.width-KEDGE_DISTANCE-destWidth;
        _startDestLab.width=destWidth;
    }
    
    //计算名字的文字长度
    NSString *name=oneModel.user.realName?oneModel.user.realName:oneModel.user.userName;
    CGFloat nameStrWidth=[ZYZCTool calculateStrLengthByText:name andFont:_nameLab.font andMaxWidth:self.bgImg.width].width;
    nameStrWidth=MIN(nameStrWidth, self.bgImg.width-destWidth-140);
     _nameLab.text=name;
    //改变名字标签长
    _nameLab.width=nameStrWidth;
    //改变性别图标位置
    _sexImg.left=_nameLab.right;
    //获取性别图标（1.男，2.女）
    if ([oneModel.user.sex isEqualToString:@"1"]) {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
    }
    else if ([oneModel.user.sex isEqualToString:@"2"])
    {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    }
    
    //改变VIP图标位置
    _vipImg.left=_sexImg.right+3;
    
    //职位
    NSString *jobStr=nil;
    if ([oneModel.user.company isEqualToString:@"无"]||[oneModel.user.title isEqualToString:@"无"]) {
        jobStr= oneModel.user.school?[NSString stringWithFormat:@"%@  %@",oneModel.user.school,oneModel.user.department]:oneModel.user.department;
    }
    else
    {
        jobStr=oneModel.user.company?[NSString stringWithFormat:@"%@  %@",oneModel.user.company,oneModel.user.title]:oneModel.user.title;
    }
    
    _jobLab.text=jobStr;
    
    //个人信息
    NSMutableString *userInfo=[NSMutableString string];
    //添加年龄
    NSInteger age=0;
    if (oneModel.user.birthday.length) {
         age=[NSDate getAgeFromBirthday:oneModel.user.birthday];
        age>0?[userInfo appendString:[NSString stringWithFormat:@"%ld岁  ",age]]:nil;
    }
    //添加星座
    oneModel.user.constellation?[userInfo appendString:[NSString stringWithFormat:@"%@  ",oneModel.user.constellation]]:nil;
    
    //添加体重
    oneModel.user.weight?[userInfo appendString:[NSString stringWithFormat:@"%@kg  ",oneModel.user.weight]]:nil;
    
    //添加身高
    oneModel.user.height?[userInfo appendString:[NSString stringWithFormat:@"%@cm  ",oneModel.user.height]]:
         nil;
    //添加婚姻状态
    if (oneModel.user.maritalStatus) {
        NSArray *maritals=@[ZYLocalizedString(@"maritalStatus_0"),ZYLocalizedString(@"maritalStatus_1"),ZYLocalizedString(@"maritalStatus_2")];
        int state=[oneModel.user.maritalStatus intValue];
        [userInfo appendString:[NSString stringWithFormat:@"%@",maritals[state]]];
    }
    _infoLab.text=userInfo;
    
    //预筹资金
    CGFloat raiseMoney=0.0;
    if (oneModel.product.productPrice) {
        raiseMoney=[oneModel.product.productPrice floatValue]/100.0;
    }
    if (KRAISE_MONEY(raiseMoney).length>3) {
        _moneyLab.attributedText=[self changeTextFontAndColorByString:KRAISE_MONEY(raiseMoney) andChangeRange:NSMakeRange(0, 2)];
    }
    
    //出发日期
    if (oneModel.product.travelstartTime.length>8) {
        NSString *startStr=KSTART_TIME(oneModel.product.travelstartTime);
        if (startStr.length>2) {
            _startLab.attributedText=[self changeTextFontAndColorByString:startStr andChangeRange:NSMakeRange(startStr.length-2, 2)];
        }
    }
    //已筹资金
    CGFloat spellRealBuyPrice=0.0;
    if (oneModel.spellbuyproduct.realzjeNew) {
        spellRealBuyPrice=[oneModel.spellbuyproduct.realzjeNew floatValue]/100.0;
    }
    _zcInfoView.moneyLab.text=[NSString stringWithFormat:@"¥%.2f",spellRealBuyPrice];
    //众筹进度
    CGFloat rate=0;
    if (raiseMoney>0) {
        rate=spellRealBuyPrice/raiseMoney;
    }
    
    _zcInfoView.rateLab.text=[NSString stringWithFormat:@"%.f％", rate*100];
    //进度条更新
    _fillProgress.width=_emptyProgress.width*MIN(1, rate);
    //剩余天数
    int leftDays=0;
    if (oneModel.product.productEndTime.length>8) {
        NSString *productEndStr=[NSDate changStrToDateStr:oneModel.product.productEndTime];
        NSDate *productEndDate=[NSDate dateFromString:productEndStr];
        leftDays=[NSDate getDayNumbertoDay:nowDate beforDay:productEndDate]+1;
        if (leftDays<0) {
            leftDays=0;
        }
        _zcInfoView.leftDayLab.text=[NSString stringWithFormat:@"%d",leftDays];
    }
    else
    {
        _zcInfoView.leftDayLab.text=@"0";
    }
    
    //众筹项目成功，项目截止时间为0
    if ([oneModel.product.status isEqual:@3]&&leftDays==0) {
        _editProductView.successBeforeTravel=YES;
    }
    
    //判断我参加的行程是否结束
    if ([[NSDate dateFromString:oneModel.product.travelendTime] compare:[NSDate date]]==-1) {
        _editProductView.myJionProductEnd=YES;
    }
    
    _editProductView.productState           =oneModel.product.status;
    _editProductView.joinProductState       =oneModel.product.myStatus;
    _editProductView.returnProductState     =oneModel.product.myStatus;
    _editProductView.hasReturn              =oneModel.product.hasHb;
    _editProductView.commentStatus          =oneModel.product.myPjStatus;
    _editProductView.endstatus              =oneModel.product.endstatus;
    _editProductView.myEndstatus            =oneModel.product.myEndstatus;
    _editProductView.godelaystatus          =oneModel.product.godelaystatus;
    _editProductView.myGodelaystatus        =oneModel.product.myGodelaystatus;
    _editProductView.txstatus               =oneModel.product.txstatus;
    _editProductView.myPaybackstatus        =oneModel.product.myPaybackstatus;
    _editProductView.myTsStatus             =oneModel.product.myTsStatus;
//    _editProductView.productState=@3;
//    _editProductView.joinProductState=@3;
//    _editProductView.returnProductState=@2;
//    _editProductView.commentStatus=@0;
//    _editProductView.hasReturn=@1;
    _editProductView.productType=oneModel.productType;
    _editProductView.productId  =oneModel.product.productId;
    
    //项目失败，进度条为灰
    if ([oneModel.product.status isEqual:@2]||[oneModel.product.myStatus isEqual:@2]) {
         _fillProgress.image=KPULLIMG(@"failPoint", 0, 2, 0, 2);
    }
    else
    {
         _fillProgress.image=KPULLIMG(@"jdt_up", 0, 2, 0, 2);
    }
}

#pragma mark --- 确定项目是哪类
-(void)setProductType:(ProductType)productType
{
    if (productType==ZCDetailProduct)
    {
        if (_productType) {
            return;
        }
        [self getDetailProductView];
    }
    else if (productType==ZCListProduct) {
        _bgImg.height=PRODUCT_CELL_HEIGHT;
    }
    else if(productType==MyPublishProduct)
    {
        _bgImg.height=MY_ZC_CELL_HEIGHT;
    }
    else if(productType==MyJionProduct)
    {
        _bgImg.height=MY_ZC_CELL_HEIGHT;
    }
    else if (productType==MyReturnProduct)
    {
         _bgImg.height=MY_ZC_CELL_HEIGHT;
    }
    else if (productType==MyDraftProduct)
    {
        _bgImg.height=MY_ZC_CELL_HEIGHT;
        
    }
     _productType=productType;
}

#pragma mark --- 众筹详情项目基本信息
-(void)getDetailProductView
{
    _iconImage.userInteractionEnabled=YES;
    _bgImg.height=PRODUCT_DETAIL_CELL_HEIGHT;
    _lineView=[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, _titleLab.bottom, _bgImg.width-2*KEDGE_DISTANCE, 1) andColor:nil];
    [_bgImg addSubview:_lineView];
    _destLayerImg.hidden=YES;
    _headImage.hidden=YES;
    _titleLab.hidden=YES;
    _planeImg.image=[UIImage imageNamed:@"btn_p_green"];
    _planeImg.top=KEDGE_DISTANCE+5;
    _planeImg.left=KEDGE_DISTANCE;
    _destScroll.top=KEDGE_DISTANCE;
    _destScroll.left=_planeImg.right+5;
    _destLab.textColor=[UIColor ZYZC_TextBlackColor];
    _destLab.font=[UIFont systemFontOfSize:18];
    _iconBgView.top=_lineView.bottom+KEDGE_DISTANCE;
    _nameLab.top=_lineView.bottom+KEDGE_DISTANCE;
    _sexImg.top=_nameLab.top;
    _vipImg.top=_nameLab.top;
    _startDestLab.top=_nameLab.top;
    _destenceLab.top=_nameLab.top;
    _jobLab.top=_nameLab.bottom+3;
    _infoLab.top=_jobLab.bottom+3;
    _moneyLab.top=_iconBgView.bottom+KEDGE_DISTANCE-4;
    _startLab.top=_moneyLab.top;
    _emptyProgress.top=_moneyLab.bottom+5;
    _zcInfoView.top=_emptyProgress.bottom+5;
    _zcInfoView.height=40;
    _interstView.top=_infoLab.bottom+3;
    
    //添加特长
//    NSArray *intersts=@[@"旅游",@"唱歌",@"跳舞",@"自驾",@"文艺"];
    NSString *tags=_oneModel.user.tags;
    if (tags) {
        NSArray *tagArr=[tags componentsSeparatedByString:@","];
        NSArray *subViews=[_interstView subviews];
        for (UIView *obj in subViews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                [obj removeFromSuperview];
            }
        }
        CGFloat edg=5*KCOFFICIEMNT;
        CGFloat frameY=0.0;
        NSInteger tagNumber=MIN(5, tagArr.count);
        for (NSInteger i=0; i<tagNumber; i++) {
            CGFloat width=[ZYZCTool calculateStrLengthByText:tagArr[i] andFont:[UIFont systemFontOfSize:13] andMaxWidth:KSCREEN_W].width+5*KCOFFICIEMNT;
            if (frameY+width+(i>0?edg:0)>_interstView.width) {
                break;
            }
            UILabel *lab=[self createTextLab];
            lab.frame=CGRectMake(frameY+(i>0?edg:0), 4, width, 16) ;
            lab.text=tagArr[i];
            frameY=lab.right;
            [_interstView addSubview:lab];
        }
    }
}

#pragma mark  --- 进入众筹金额明细页
-(void)enterDetailMoney
{
    if(_productType==MyPublishProduct||_oneModel.mySelf)
    {
        WalletMingXiVC *mxVC = [[WalletMingXiVC alloc] initWIthProductId:_oneModel.product.productId];
        [self.viewController.navigationController pushViewController:mxVC animated:YES];
    }
}

#pragma mark --- 创建lab
-(UILabel *)createLabWithFrame:(CGRect )frame andFont:(UIFont *)font andTitleColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=font;
    lab.textColor=color;
    return lab;
}

-(UILabel *)createTextLab
{
    UILabel *lab=[[UILabel alloc]init];
    lab.textColor=[UIColor ZYZC_TextGrayColor];
    lab.font=[UIFont systemFontOfSize:13];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.layer.borderWidth=1;
    lab.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
    return lab;
}


#pragma mark --- 创建btn
-(UIButton *)createBtnWithFrame:(CGRect )frame andBorderColor:(UIColor *)color
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    btn.layer.cornerRadius=KCORNERRADIUS;
    btn.layer.masksToBounds=YES;
    btn.layer.borderWidth=2;
    [btn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    btn.layer.borderColor=color.CGColor;
    btn.titleLabel.textColor=[UIColor ZYZC_TextBlackColor];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    btn.hidden=YES;
    return btn;
}



#pragma mark --- 字符串的字体更改
-(NSMutableAttributedString *)changeTextFontAndColorByString:(NSString *)str andChangeRange:(NSRange )range
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    if (str.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_TextGrayColor] range:range];
    }
    return  attrStr;
}


@end
