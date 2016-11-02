//
//  ZCDetailIntroFifthCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailIntroFifthCell.h"
#import "ZCDetailCustomButton.h"
#import "ZCWSMView.h"
@interface ZCDetailIntroFifthCell ()
@property (nonatomic, strong) UILabel    *moneyLab;
@property (nonatomic, strong) UILabel    *subMoneyLab;
@property (nonatomic, strong) ZCWSMView  *wsmView;
@property (nonatomic, strong) UILabel    *limitLab;         //限额标签
@property (nonatomic, strong) UILabel    *supportLab;       //支持的人
@property (nonatomic, strong) UIView     *separateView;     //分割线
@property (nonatomic, strong) UIView     *supportUsersView; //支持的人
@property (nonatomic, strong) UIButton   *supportBtn;       //支持按钮

@property (nonatomic, strong) NSArray  *users;
@property (nonatomic, strong) ReportModel *returnModel;

@end

@implementation ZCDetailIntroFifthCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) configUI
{
    [super configUI];
    [self.topLineView removeFromSuperview];
    [self.vertical removeFromSuperview];
    self.titleLab.left=KEDGE_DISTANCE;
    self.titleLab.text=@"回报支持";
    self.titleLab.textColor=[UIColor ZYZC_RedTextColor];
    self.titleLab.font=[UIFont boldSystemFontOfSize:17.f];
    
    //金额
    _moneyLab=[ZYZCTool createLabWithFrame:CGRectMake(0, self.titleLab.top, self.bgImg.width-KEDGE_DISTANCE, self.titleLab.height) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor blackColor]];
    _moneyLab.textAlignment=NSTextAlignmentRight;
    [self.bgImg addSubview:_moneyLab];
    
    //子金额
    _subMoneyLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, self.titleLab.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 20) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [self.bgImg addSubview:_subMoneyLab];
    
    //回报内容
    _wsmView = [[ZCWSMView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _subMoneyLab.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 0.1)];
    [self.bgImg addSubview:_wsmView];
    
    //限额人数
    _limitLab=[ZYZCTool createLabWithFrame:CGRectMake(KEDGE_DISTANCE, _wsmView.bottom+KEDGE_DISTANCE, 0, 20) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [self.bgImg addSubview:_limitLab];
    
    //剩余人数
    _supportLab = [ZYZCTool createLabWithFrame:CGRectMake(0, _limitLab.top, 0, 20) andFont:_limitLab.font andTitleColor:_limitLab.textColor];
    [self.bgImg addSubview:_supportLab];
    
    //分割线
    _separateView = [UIView lineViewWithFrame:CGRectMake(0,_limitLab.top+2.5, 1.0, 15) andColor:nil];
    [self.bgImg addSubview:_separateView];
    _separateView.hidden=YES;
    
    _supportUsersView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _limitLab.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 0.1)];
    [self.bgImg addSubview:_supportUsersView];
    
    _supportBtn=[ZYZCTool createBtnWithFrame:CGRectMake(KEDGE_DISTANCE, _supportUsersView.bottom+KEDGE_DISTANCE, self.bgImg.width-20, 40) andNormalTitle:@"我想要回报" andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(support:)];
    _supportBtn.backgroundColor = [UIColor ZYZC_MainColor];
    _supportBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _supportBtn.layer.cornerRadius = KCORNERRADIUS;
    _supportBtn.layer.masksToBounds = YES;
    [self.bgImg addSubview:_supportBtn];
}

- (void) setDetailModel:(ZCDetailProductModel *)detailModel
{
    _detailModel=detailModel;
    ReportModel *returnModel = nil;
    for (NSInteger i=0; i< detailModel.report.count; i++) {
        ReportModel *report = detailModel.report[i];
        if ([report.style isEqual:@3]) {
            returnModel=report;
            break;
        }
    }
    self.returnModel=returnModel;
    detailModel.introFifthCellHeight=self.bgImg.height;
}

-(void) setReturnModel:(ReportModel *)returnModel
{
    _returnModel = returnModel;
    //金额
    CGFloat money = [returnModel.price floatValue]/100.0;
    _moneyLab.attributedText = [self customMoneyByString:[NSString stringWithFormat:@"¥ %.2f",money]];
                                
    //子金额
    _subMoneyLab.text = [NSString stringWithFormat:@"支持%.2f元",money];
    
    [_wsmView reloadDataByVideoImgUrl:returnModel.spellVideoImg andPlayUrl:returnModel.spellVideo andVoiceUrl:returnModel.spellVoice andVoiceLen:returnModel.spellVoiceLen andFaceImg:_detailModel.user.faceImg andDesc:returnModel.desc andImgUrlStr:returnModel.descImgs];
    
    //限额
    _limitLab.attributedText = [self customStringByString: [NSString stringWithFormat:@"限额:%@位",returnModel.people]];
    
    //剩余
    NSInteger leftNum =MAX([returnModel.people integerValue] - returnModel.users.count, 0) ;
    _supportLab.attributedText = [self customStringByString:[NSString stringWithFormat:@"剩余:%ld位",leftNum]];
    
    CGFloat limit_width01=[ZYZCTool calculateStrLengthByText:@"限额:位" andFont:_limitLab.font andMaxWidth:self.width].width;
    CGFloat limit_width02=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%@",returnModel.people] andFont:[UIFont boldSystemFontOfSize:15.f] andMaxWidth:self.width].width;
    _limitLab.width=MIN(limit_width01+limit_width02, 120.f);
    _separateView.hidden=NO;
    _separateView.left=_limitLab.right+20.f;
    _supportLab.left=_separateView.right+20.f;
    
    CGFloat support_width01=[ZYZCTool calculateStrLengthByText:@"剩余:位" andFont: _supportLab.font andMaxWidth:self.width].width;
    CGFloat support_width02=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%ld",leftNum] andFont:[UIFont boldSystemFontOfSize:15.f] andMaxWidth:self.width].width;
    _supportLab.width=MIN(support_width01+support_width02, 120.f);
    
    _limitLab.top=_wsmView.bottom+KEDGE_DISTANCE;
    _supportLab.top=_limitLab.top;
    _separateView.top=_limitLab.top;
    _supportUsersView.top=_limitLab.bottom+KEDGE_DISTANCE;
    
    //支持的人
    self.users = returnModel.users;
    
    //一起游
    _supportBtn.top=_supportUsersView.bottom+KEDGE_DISTANCE;
    
    self.bgImg.height=_supportBtn.bottom+KEDGE_DISTANCE;

}

-(void) support:(UIButton *)button
{
    
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
        CGFloat btn_edg=(self.width-btn_width*6)/5;
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
