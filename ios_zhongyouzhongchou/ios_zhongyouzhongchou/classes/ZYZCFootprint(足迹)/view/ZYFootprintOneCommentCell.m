//
//  ZYFootprintOneCommentCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintOneCommentCell.h"
#import "ZCDetailCustomButton.h"
#import "LoginJudgeTool.h"
#import "ZYZCPersonalController.h"
@interface ZYFootprintOneCommentCell()
@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIImageView *commentImg;
@property (nonatomic, strong) ZCDetailCustomButton *iconBtn;
@property (nonatomic, strong) ZCDetailCustomButton *nameBtn;
@property (nonatomic, strong) UILabel     *timeLab;
@property (nonatomic, strong) UILabel     *contentlab;
@property (nonatomic, strong) UIButton    *replayBtn;
@property (nonatomic, strong) UIView      *lineView;

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
    _bgView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:240.0/255.0 blue:242.0/255.0 alpha:1.0];
    [self.contentView addSubview:_bgView];
    
    _commentImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 20, 20, 15)];
    _commentImg.image=[UIImage imageNamed:@"footprint-comment"];
    [_bgView addSubview:_commentImg];
    
    _iconBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(40, 10, 35, 35)];
    [_bgView addSubview:_iconBtn];
    
    _nameBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(_iconBtn.right+KEDGE_DISTANCE, _iconBtn.top, 120, 20)];
    [_nameBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    _nameBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [_bgView addSubview:_nameBtn];
    
    _timeLab=[ZYZCTool createLabWithFrame:CGRectMake(_bgView.width-130, _iconBtn.top, 120, 20) andFont:[UIFont systemFontOfSize:11] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    _timeLab.textAlignment = NSTextAlignmentRight;
//    _timeLab.backgroundColor=[UIColor orangeColor];
    [_bgView addSubview:_timeLab];
    
    _contentlab=[ZYZCTool createLabWithFrame:CGRectMake(_iconBtn.right+KEDGE_DISTANCE, _nameBtn.bottom+KEDGE_DISTANCE, _bgView.width-2*KEDGE_DISTANCE-_iconBtn.right, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _contentlab.numberOfLines=0;
    [_bgView addSubview:_contentlab];
    
    _lineView=[UIView lineViewWithFrame:CGRectMake(_iconBtn.left, 0, _bgView.width-10-_iconBtn.left, 0.5) andColor:[UIColor lightGrayColor]];
    [_bgView addSubview:_lineView];
    
}

-(void)setOneCommentModel:(ZYOneCommentModel *)oneCommentModel
{
    _oneCommentModel=oneCommentModel;
    //头像
    _iconBtn.userId=oneCommentModel.userId;
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:oneCommentModel.faceImg64?oneCommentModel.faceImg64:oneCommentModel.faceImg132?oneCommentModel.faceImg132:oneCommentModel.faceImg640?oneCommentModel.faceImg640:oneCommentModel.faceImg]  forState:UIControlStateNormal placeholderImage:[UIImage  imageNamed:@"icon_placeholder"]];
    
    //名字
    NSString *name=oneCommentModel.realName?oneCommentModel.realName:oneCommentModel.userName;
    CGFloat name_width=[ZYZCTool calculateStrLengthByText:name andFont:_nameBtn.titleLabel.font andMaxWidth:KSCREEN_W].width;
    _nameBtn.width=MIN(name_width, 120);
    [_nameBtn setTitle:name forState:UIControlStateNormal];
    _nameBtn.userId=oneCommentModel.userId;
    
    //时间
    _timeLab.text=[ZYZCTool showCusDateByTimestamp:oneCommentModel.creattime];
    
    //内容
    NSString *content=oneCommentModel.content;
    _contentlab.text=oneCommentModel.content;
    if(oneCommentModel.replyUserName)
    {
        _contentlab.backgroundColor=[UIColor orangeColor];
        _contentlab.userInteractionEnabled=YES;
        content =[NSString stringWithFormat:@"回复%@:%@",oneCommentModel.replyUserName,oneCommentModel.content];
        NSRange replyUserName_range=[content rangeOfString:oneCommentModel.replyUserName];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:content];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_MainColor] range:replyUserName_range];
        
        _contentlab.attributedText=attrStr;
//        WEAKSELF;
//        [_contentlab yb_addAttributeTapActionWithStrings:@[content] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//            
//            [weakSelf enterUserZone:oneCommentModel.replyUserId];
//            
//        }];
    }
    
    CGFloat content_height=[ZYZCTool calculateStrLengthByText:content andFont:_contentlab.font andMaxWidth:_contentlab.width].height;
    _contentlab.height=content_height;
    
    _bgView.height=_contentlab.bottom+KEDGE_DISTANCE;
    _lineView.top=_bgView.height-0.5;
    _lineView.hidden=!_showLine;
    _commentImg.hidden=!_showCommentImg;
    
     oneCommentModel.cellHeight=_bgView.bottom;
}


-(void)enterUserZone:(NSNumber *)userId
{
    BOOL loginResult=[LoginJudgeTool judgeLogin];
    if (!loginResult) {
        return;
    }
    //进入他人空间
    ZYZCPersonalController *personalController=[[ZYZCPersonalController alloc]init];
    personalController.hidesBottomBarWhenPushed=YES;
    personalController.userId=userId;

    [self.viewController.navigationController pushViewController:personalController animated:YES];
}





@end
