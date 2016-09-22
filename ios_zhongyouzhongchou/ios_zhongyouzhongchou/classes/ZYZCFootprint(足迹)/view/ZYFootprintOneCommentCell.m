//
//  ZYFootprintOneCommentCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintOneCommentCell.h"
#import "ZCDetailCustomButton.h"
@interface ZYFootprintOneCommentCell()
@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIImageView *commentImg;
@property (nonatomic, strong) ZCDetailCustomButton *iconBtn;
@property (nonatomic, strong) ZCDetailCustomButton *nameBtn;
@property (nonatomic, strong) UILabel     *timeLab;
@property (nonatomic, strong) UILabel     *contentlab;

@end

@implementation ZYFootprintOneCommentCell

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
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, 0.1)];
    _bgView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.contentView addSubview:_bgView];
    
    _commentImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 20, 20, 15)];
    _commentImg.image=[UIImage imageNamed:@"footprint-comment"];
    [_bgView addSubview:_commentImg];
    
    _iconBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(40, 10, 35, 35)];
    [_bgView addSubview:_iconBtn];
    
    _nameBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(_iconBtn.right+KEDGE_DISTANCE, _iconBtn.top, 120, 20)];
    _nameBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [_bgView addSubview:_nameBtn];
    
    _timeLab=[ZYZCTool createLabWithFrame:CGRectMake(_bgView.width-160, _iconBtn.top, 120, 20) andFont:[UIFont systemFontOfSize:11] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_timeLab];
    
    _contentlab=[ZYZCTool createLabWithFrame:CGRectMake(_iconBtn.right+KEDGE_DISTANCE, _nameBtn.bottom+KEDGE_DISTANCE, _bgView.width-2*KEDGE_DISTANCE-_iconBtn.right, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [_bgView addSubview:_contentlab];
    
}

-(void)setOneCommentModel:(ZYOneCommentModel *)oneCommentModel
{
    _oneCommentModel=oneCommentModel;
    
    _iconBtn.userId=oneCommentModel.userId;
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:oneCommentModel.faceImg64?oneCommentModel.faceImg64:oneCommentModel.faceImg132?oneCommentModel.faceImg132:oneCommentModel.faceImg640?oneCommentModel.faceImg640:oneCommentModel.faceImg]  forState:UIControlStateNormal placeholderImage:[UIImage  imageNamed:@"icon_placeholder"]];
    
    NSString *name=oneCommentModel.realName?oneCommentModel.realName:oneCommentModel.userName;
    CGFloat name_width=[ZYZCTool calculateStrLengthByText:name andFont:_nameBtn.titleLabel.font andMaxWidth:KSCREEN_W].width;
    _nameBtn.width=MIN(name_width, 120);
    _nameBtn.userId=oneCommentModel.userId;
    
    _timeLab.text=[ZYZCTool showCusDateByTimestamp:oneCommentModel.creattime];
    
    CGFloat content_height=[ZYZCTool calculateStrLengthByText:oneCommentModel.comment andFont:_timeLab.font andMaxWidth:_timeLab.width].height;
    _contentlab.height=content_height;
    _contentlab.text=oneCommentModel.comment;
    
    _bgView.height=_contentlab.bottom;
    _commentImg.hidden=!_showCommentImg;
  
}




@end
