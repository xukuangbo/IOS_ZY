//
//  PartnerTableCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "PartnerTableCell.h"
#import "ZCDetailCustomButton.h"
@interface PartnerTableCell ()
@property (nonatomic, strong) UIImageView           *bgImg;
@property (nonatomic, strong) ZCDetailCustomButton  *iconImg;
@property (nonatomic, strong) UILabel               *nameLab;
@property (nonatomic, strong) UIImageView           *sexImg;
@property (nonatomic, strong) UILabel               *jobLab;
@property (nonatomic, strong) ParterStatusBtn       *statusBtn;
@end

@implementation PartnerTableCell

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
        
        UIView *deleteView=[[UIView alloc]initWithFrame:CGRectMake(KSCREEN_W, 0, KSCREEN_W, PARTYNER_CELL_HEIGHT)];
        deleteView.backgroundColor=[UIColor ZYZC_BgGrayColor];
        [self.contentView addSubview:deleteView];
        
        UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame =CGRectMake(0, 0, 60, PARTYNER_CELL_HEIGHT) ;
        deleteBtn.backgroundColor=[UIColor redColor];
        deleteBtn.layer.cornerRadius=KCORNERRADIUS;
        deleteBtn.layer.masksToBounds=YES;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteView addSubview:deleteBtn];
        
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, PARTYNER_CELL_HEIGHT)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    _bgImg.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImg];
    
    CGFloat iconImgWidth=60;
    _iconImg =[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, iconImgWidth, iconImgWidth)];
    _iconImg.layer.cornerRadius=KCORNERRADIUS;
    _iconImg.layer.masksToBounds=YES;
    _iconImg.layer.borderWidth=1;
    _iconImg.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
    [_bgImg addSubview:_iconImg];
    
    _nameLab =[[UILabel alloc] initWithFrame:CGRectMake(_iconImg.right+10, 15, 0, 20)];
    _nameLab.textColor=[UIColor ZYZC_TextBlackColor];
    _nameLab.font=[UIFont systemFontOfSize:15];
    [_bgImg addSubview:_nameLab];
    
    _sexImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, _nameLab.top, 20, 20)];
    [_bgImg addSubview:_sexImg];
    
    _jobLab=[[UILabel alloc]initWithFrame:CGRectMake(_iconImg.right+20, _nameLab.bottom+KEDGE_DISTANCE, _bgImg.width-_iconImg.width-40, 20)];
    _jobLab.textColor=[UIColor ZYZC_TextGrayColor];
    _jobLab.font=[UIFont systemFontOfSize:16];
    [_bgImg addSubview:_jobLab];
    
    CGFloat btnWidth=80;
    CGFloat btnHeigth=25;
    _statusBtn= [[ParterStatusBtn alloc]initWithFrame:CGRectMake(_bgImg.width-KEDGE_DISTANCE-btnWidth,KEDGE_DISTANCE, btnWidth, btnHeigth)];
    [_bgImg addSubview:_statusBtn];
    
}

-(void)setPartnerModel:(UserModel *)partnerModel
{
    _partnerModel=partnerModel;
    //加载头像
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:partnerModel.faceImg] forState:UIControlStateNormal];
    _iconImg.userId=partnerModel.userId;
    
    //名字
    _nameLab.text=partnerModel.realName?partnerModel.realName:partnerModel.userName;
    CGFloat nameWidth=[ZYZCTool calculateStrLengthByText:_nameLab.text andFont:_nameLab.font andMaxWidth:KSCREEN_W].width;
    if (nameWidth>_bgImg.width-200) {
        nameWidth=_bgImg.width-200;
    }
    _nameLab.width=nameWidth;
    
    //性别
    if ([partnerModel.sex isEqualToString:@"1"]) {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
    }
    else if ([partnerModel.sex isEqualToString:@"2"])
    {
        _sexImg.image= [UIImage imageNamed:@"btn_sex_fem"];
    }
    _sexImg.left=_nameLab.right;
    
    //职业
    NSString *jobStr=nil;
    if ([partnerModel.company isEqualToString:@"无"]||[partnerModel.title isEqualToString:@"无"]) {
        jobStr= partnerModel.school?[NSString stringWithFormat:@"%@  %@",partnerModel.school,partnerModel.department]:partnerModel.department;
    }
    else
    {
        jobStr=partnerModel.company?[NSString stringWithFormat:@"%@  %@",partnerModel.company,partnerModel.title]:partnerModel.title;
    }
    _jobLab.text=jobStr;
    
    _statusBtn.userModel=partnerModel;
    
    _statusBtn.hasComplain=partnerModel.hasTs;
}

#pragma mark --- 一起游的人／回报的人的状态
-(void)setMyPartnerType:(MyPartnerType)myPartnerType
{
    _myPartnerType=myPartnerType;
    _statusBtn.myPartnerType=myPartnerType;
    if (_myPartnerType==TogtherPartner) {
        //一起游的人状态
        _statusBtn.status=_partnerModel.product_owner_status;
        
    }
    else if (_myPartnerType==ReturnPartner)
    {
        //回报的人状态
        _statusBtn.returnState=_partnerModel.product_owner_status;
    }
}

#pragma mark --- 评价类型（评价一起游／评价回报者）
-(void)setCommentType:(CommentType)commentType
{
    _commentType=commentType;
    
    _statusBtn.commentType=commentType;
    _statusBtn.comentStatus=_partnerModel.hasPj;
}

#pragma mark --- 如果是从回报进入，则btn不可操作
-(void)setFromMyReturn:(BOOL)fromMyReturn
{
    _fromMyReturn=fromMyReturn;
    if (_fromMyReturn&&_myPartnerType==TogtherPartner) {
        _statusBtn.enabled=NO;
    }
    else {
        _statusBtn.enabled=YES;
    }
}


-(void)setProductId:(NSNumber *)productId
{
    _productId=productId;
    _statusBtn.productId=_productId;
}

@end
