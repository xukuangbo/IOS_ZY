//
//  HotCommentCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "HotCommentCell.h"
#import "ZCDetailCustomButton.h"
@interface HotCommentCell ()
@property (nonatomic, strong) ZCDetailCustomButton *iconBtn;
@property (nonatomic, strong) UILabel  *nameLab;
@property (nonatomic, strong) UIImageView *sexImg;
@property (nonatomic, strong) UIImageView *vipImg;
@property (nonatomic, strong) UILabel  *timeLab;
@property (nonatomic, strong) UILabel  *contentLab;
@end

@implementation HotCommentCell

- (void)awakeFromNib {
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
    _iconBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(0, KEDGE_DISTANCE, 60, 60)];
    [self.contentView addSubview:_iconBtn];
    
    _nameLab=[self createLabWithFrame:CGRectMake(_iconBtn.right+KEDGE_DISTANCE, KEDGE_DISTANCE, 1, 20) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [self.contentView addSubview:_nameLab];
    
    _sexImg=[[UIImageView alloc]initWithFrame:CGRectMake(_nameLab.right+3, KEDGE_DISTANCE, 20, 20)];
    _sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    [self.contentView addSubview:_sexImg];
    
    _vipImg=[[UIImageView alloc]initWithFrame:CGRectMake(_sexImg.right+3, KEDGE_DISTANCE+2, 16, 16)];
    _vipImg.image=[UIImage imageNamed:@"icon_id"];
    [self.contentView addSubview:_vipImg];
    _vipImg.hidden=YES;
    
    _timeLab=[self createLabWithFrame:CGRectMake(KSCREEN_W-4*KEDGE_DISTANCE-130, KEDGE_DISTANCE, 130, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _timeLab.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_timeLab];
    
    _contentLab= [self createLabWithFrame:CGRectMake(_iconBtn.right+KEDGE_DISTANCE, _nameLab.bottom+KEDGE_DISTANCE, KSCREEN_W-_iconBtn.right-5*KEDGE_DISTANCE, 20) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _contentLab.numberOfLines=0;
    [self.contentView addSubview:_contentLab];
    
    _lineView=[UIView lineViewWithFrame:CGRectMake(0, _iconBtn.bottom+KEDGE_DISTANCE-1, KSCREEN_W-4*KEDGE_DISTANCE, 1) andColor:nil];
    [self.contentView addSubview:_lineView];
    
}


-(void)setCommentModel:(ZCCommentModel *)commentModel
{
    _commentModel=commentModel;
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:commentModel.user.faceImg] forState:UIControlStateNormal];
    _iconBtn.userId=commentModel.user.userId;
    //计算名字的文字长度
     NSString *name=commentModel.user.realName?commentModel.user.realName:commentModel.user.userName;
    CGFloat nameStrWidth=[ZYZCTool calculateStrLengthByText:name andFont:_nameLab.font andMaxWidth:KSCREEN_W].width;
    CGFloat width=KSCREEN_W-250;
    CGFloat edgToName=nameStrWidth;
    if (nameStrWidth>=width) {
        nameStrWidth=width;
        edgToName=width-12;
    }
    _nameLab.text=name;
    //改变名字标签长
    _nameLab.width=nameStrWidth;
    //改变性别图标位置
    _sexImg.left=_nameLab.right;
    //获取性别图标
    if ([commentModel.user.sex isEqualToString:@"1"]) {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
    }
    else if ([commentModel.user.sex isEqualToString:@"2"])
    {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_fem"];
    }
    
    //改变VIP图标位置
    _vipImg.left=_sexImg.right+3;
    
    _timeLab.text=[ZYZCTool turnTimeStampToDate:commentModel.comment.timestamp];
    
    //计算content内容
    NSString *content= commentModel.comment.content;
    CGSize contentSize=[ZYZCTool calculateStrLengthByText:content andFont:_contentLab.font andMaxWidth:_contentLab.width];
    _contentLab.height=contentSize.height;
    _contentLab.text=content;
    
    CGFloat height01=_iconBtn.bottom +KEDGE_DISTANCE;
    CGFloat height02=_contentLab.bottom+KEDGE_DISTANCE;
    
    commentModel.cellHeight=height01>height02?height01:height02;
    
    _lineView.top=commentModel.cellHeight-1;
}

-(UILabel *)createLabWithFrame:(CGRect )frame andFont:(UIFont *)font andTitleColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=font;
    lab.textColor=color;
    return lab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
