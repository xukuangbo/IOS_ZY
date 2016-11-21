//
//  ZYDetailIUserInfoCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYDetailIUserInfoCell.h"
#import "ZYDetailUserInfoView.h"
#import "NSDate+RMCalendarLogic.h"
#import "ZYUserZoneController.h"
#import "ZYZCAccountTool.h"
#define KRAISE_MONEY(money)  [NSString stringWithFormat:@"预筹¥%.2f",money]
#define KSTART_TIME(time)     [NSString stringWithFormat:@"%@出发",time]

@interface ZYDetailIUserInfoCell ()

@property (nonatomic, strong) UIImageView  *bgImg;
@property (nonatomic, weak  ) ZYDetailUserInfoView *infoView;
@property (nonatomic, strong) UILabel      *destLab;

@end

@implementation ZYDetailIUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, USER_INFO_CELL_HEIGHT)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    _bgImg.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImg];
    
    _infoView= [[[NSBundle mainBundle] loadNibNamed:@"ZYDetailUserInfoView" owner:nil options:nil] objectAtIndex:0];
    [_bgImg addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImg).offset(0);
        make.left.equalTo(_bgImg).offset(0);
        make.right.equalTo(_bgImg).offset(0);
        make.height.mas_equalTo(210);
    }];
    
    //添加目的地
    _destLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 29) ];
    _destLab.textColor=[UIColor ZYZC_TextBlackColor];
    _destLab.font=[UIFont systemFontOfSize:18];
    [_infoView.destScroll addSubview:_destLab];
    _infoView.faceBottomView.layer.cornerRadius=5;
    _infoView.faceBottomView.layer.masksToBounds=YES;
    _infoView.faceImg.layer.cornerRadius=3;
    _infoView.faceImg.layer.masksToBounds=YES;
    _infoView.startDest.layer.cornerRadius=3;
    _infoView.startDest.layer.masksToBounds=YES;
    _infoView.startDest.hidden=YES;
    
    _infoView.hidden=YES;
}

-(void)setDetailProductModel:(ZCDetailProductModel *)detailProductModel
{
    _detailProductModel=detailProductModel;
    if (detailProductModel) {
        _infoView.hidden=NO;
    }
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    //推荐人数
    _infoView.recommendLab.text=[NSString stringWithFormat:@"%@人推荐",detailProductModel.friendsCount?detailProductModel.friendsCount:@0];
    
    NSString *startDest=nil;
    if (detailProductModel.dest.length) {
        //计算目的地的文字长度
        NSMutableString *place=[NSMutableString string];
        //目的地为json数组，需要转换成数组再做字符串拼接
        NSArray *dest=[ZYZCTool turnJsonStrToArray:detailProductModel.dest];
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
        _destLab.width=placeStrWidth;
        _destLab.text=place;
        if (_infoView.destScroll.width<placeStrWidth) {
            _infoView.destScroll.contentSize=CGSizeMake(placeStrWidth, 0) ;
            _infoView.destScroll.showsHorizontalScrollIndicator=NO;
        }
    }
    
    //用户图像
    [_infoView.faceImg sd_setImageWithURL:[NSURL URLWithString:[ZYZCTool getSmailIcon:detailProductModel.user.faceImg]]
    placeholderImage:[UIImage imageNamed:@"icon_placeholder"] options:options];
    [_infoView.faceImg addTarget:self action:@selector(tapFaceImg)];
    
    //出发地
    CGFloat destWidth=0.0;
    if (startDest.length>0) {
        _infoView.startDest.hidden=NO;
        _infoView.startDest.text=[NSString stringWithFormat:@"%@出发",startDest];
        destWidth=[ZYZCTool calculateStrLengthByText:_infoView.startDest.text andFont:_infoView.startDest.font andMaxWidth:self.width].width+10;
        destWidth=MIN(destWidth, 100);
        _infoView.startDest.width=destWidth;
        _infoView.startDest.right=_infoView.right-10;
    }
    //计算名字的文字长度
    NSString *name=detailProductModel.user.realName?detailProductModel.user.realName:detailProductModel.user.userName;
    CGFloat nameStrWidth=[ZYZCTool calculateStrLengthByText:name andFont:_infoView.name.font andMaxWidth:self.bgImg.width].width;
    nameStrWidth=MIN(nameStrWidth, self.bgImg.width-destWidth-140);
    _infoView.name.text=name;
    _infoView.name.width=nameStrWidth;
    
    _infoView.sexImg.left=_infoView.name.right;
    //获取性别图标（1.男，2.女）
    if ([detailProductModel.user.sex isEqualToString:@"1"]) {
        _infoView.sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
    }
    else if ([detailProductModel.user.sex isEqualToString:@"2"])
    {
        _infoView.sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    }
    
    
    //职位
    NSString *jobStr=nil;
    if ([detailProductModel.user.company isEqualToString:@"无"]||[detailProductModel.user.title isEqualToString:@"无"]) {
        jobStr= detailProductModel.user.school?[NSString stringWithFormat:@"%@  %@",detailProductModel.user.school,detailProductModel.user.department]:detailProductModel.user.department;
    }
    else
    {
        jobStr=detailProductModel.user.company?[NSString stringWithFormat:@"%@  %@",detailProductModel.user.company,detailProductModel.user.title]:detailProductModel.user.title;
    }
    _infoView.jobLab.text=jobStr;
    
    //个人信息
    NSMutableString *userInfo=[NSMutableString string];
    //添加年龄
    NSInteger age=0;
    if (detailProductModel.user.birthday.length) {
        age=[NSDate getAgeFromBirthday:detailProductModel.user.birthday];
        age>0?[userInfo appendString:[NSString stringWithFormat:@"%ld岁  ",age]]:nil;
    }
    //添加星座
    detailProductModel.user.constellation?[userInfo appendString:[NSString stringWithFormat:@"%@  ",detailProductModel.user.constellation]]:nil;
    
    //添加体重
    detailProductModel.user.weight?[userInfo appendString:[NSString stringWithFormat:@"%@kg  ",detailProductModel.user.weight]]:nil;
    
    //添加身高
    detailProductModel.user.height?[userInfo appendString:[NSString stringWithFormat:@"%@cm  ",detailProductModel.user.height]]:
    nil;
    //添加婚姻状态
    if (detailProductModel.user.maritalStatus) {
        NSArray *maritals=@[ZYLocalizedString(@"maritalStatus_0"),ZYLocalizedString(@"maritalStatus_1"),ZYLocalizedString(@"maritalStatus_2")];
        int state=[detailProductModel.user.maritalStatus intValue];
        [userInfo appendString:[NSString stringWithFormat:@"%@",maritals[state]]];
    }
    _infoView.baseInfoLab.text=userInfo;
    
    //预筹资金
    CGFloat raiseMoney=0.0;
    if (detailProductModel.spell_buy_price) {
        raiseMoney=[detailProductModel.spell_buy_price floatValue]/100.0;
    }
    if (KRAISE_MONEY(raiseMoney).length>3) {
        _infoView.totalMoneyLab.attributedText=[self changeTextFontAndColorByString:KRAISE_MONEY(raiseMoney) andChangeRange:NSMakeRange(0, 2)];
    }
    //出发日期
    if (detailProductModel.start_time.length>8) {
        NSString *startStr=KSTART_TIME(detailProductModel.start_time);
        if (startStr.length>2) {
            _infoView.startDateLab.attributedText=[self changeTextFontAndColorByString:startStr andChangeRange:NSMakeRange(startStr.length-2, 2)];
        }
    }
    //已筹资金
    ReportModel *report=[detailProductModel.report firstObject];
    CGFloat spellRealBuyPrice=report.realzjeNew/100.0;
    _infoView.moneyLab.text=[NSString stringWithFormat:@"¥%.2f",spellRealBuyPrice];
    //众筹进度
    CGFloat rate=0;
    if (raiseMoney>0) {
        rate=spellRealBuyPrice/raiseMoney;
    }
    
    _infoView.rateLab.text=[NSString stringWithFormat:@"%.f％", rate*100];
    //进度条更新
    _infoView.progressImg.width=(_infoView.width-20)*MIN(1, rate);
    //剩余天数
    int leftDays=0;
    if (detailProductModel.spell_end_time.length>8) {
        NSString *productEndStr=[NSDate changStrToDateStr:detailProductModel.spell_end_time];
        NSDate *productEndDate=[NSDate dateFromString:productEndStr];
        leftDays=[NSDate getDayNumbertoDay:[NSDate date] beforDay:productEndDate]+1;
        if (leftDays<0) {
            leftDays=0;
        }
        _infoView.leftDayLab.text=[NSString stringWithFormat:@"%d",leftDays];
    }
    else
    {
        _infoView.leftDayLab.text=@"0";
    }
    
    //兴趣标签
    NSString *tags=detailProductModel.user.tags;
    if (tags) {
        NSArray *tagArr=[tags componentsSeparatedByString:@","];
        NSArray *subViews=[_infoView.interestView subviews];
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
            if (frameY+width+(i>0?edg:0)>_infoView.interestView.width) {
                break;
            }
            UILabel *lab=[self createTextLab];
            lab.frame=CGRectMake(frameY+(i>0?edg:0), 4, width, 16) ;
            lab.text=tagArr[i];
            frameY=lab.right;
            [_infoView.interestView addSubview:lab];
        }
    }

    
}

#pragma mark --- 点击进入个人空间
-(void)tapFaceImg
{
    //判断是否是自己的
    if ([[ZYZCAccountTool getUserId] isEqual:[_detailProductModel.user.userId stringValue]]) {
        return;
    }
    
    ZYUserZoneController *userZoneController=[[ZYUserZoneController alloc]init];
    userZoneController.hidesBottomBarWhenPushed=YES;
    userZoneController.friendID=_detailProductModel.user.userId;
    [self.viewController.navigationController pushViewController:userZoneController animated:YES];

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

-(UILabel *)createTextLab
{
    UILabel *lab=[[UILabel alloc]init];
    lab.textColor=[UIColor ZYZC_TextGrayColor];
    lab.font=[UIFont systemFontOfSize:12];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.layer.borderWidth=1;
    lab.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
    return lab;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
