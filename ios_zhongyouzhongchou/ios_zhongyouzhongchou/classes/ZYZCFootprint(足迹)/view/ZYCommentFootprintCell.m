//
//  ZYCommentFootprintCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define ICON_WIDTH    35
#define ICON_EDG      8

#import "ZYCommentFootprintCell.h"
#import "ZYOneFootprintView.h"
#import "ZCDetailCustomButton.h"
@interface ZYCommentFootprintCell ()
@property (nonatomic, strong) ZYOneFootprintView *oneFootprintView;
@property (nonatomic, strong) UIImageView        *bgImgView;
@property (nonatomic, strong) UIView             *lineView;
@end

@implementation ZYCommentFootprintCell

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
    _oneFootprintView=[[ZYOneFootprintView alloc]initWithFrame:CGRectMake(20, 0, KSCREEN_W-35, 0.1)];
    _oneFootprintView.commentEnterType=enterCommentEdit;
    _oneFootprintView.canOpenText=NO;
    [self.contentView addSubview:_oneFootprintView];
    
    _bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, _oneFootprintView.bottom+KEDGE_DISTANCE, KSCREEN_W-20, 0.1)];
    _bgImgView.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImgView];
    
    _lineView=[UIView lineViewWithFrame:CGRectMake(0, 0, _bgImgView.width, 0.5) andColor:[UIColor lightGrayColor]];
    [_bgImgView addSubview:_lineView];

}

-(void)setFootprintModel:(ZYFootprintListModel *)footprintModel
{
    _footprintModel=footprintModel;
    _oneFootprintView.footprintModel=footprintModel;
    _bgImgView.top=_oneFootprintView.bottom+KEDGE_DISTANCE;
}

-(void)setSupportListModel:(ZYSupportListModel *)supportListModel
{
    _supportListModel=supportListModel;
    
    NSArray *views=[_bgImgView subviews];
    for (NSInteger i=views.count-1; i>=0; i-- ) {
        if ([views[i] isKindOfClass:[ZCDetailCustomButton class]]||[views[i] isKindOfClass:[UIImageView class]]) {
            [views[i] removeFromSuperview];
        }
    }
    _bgImgView.height=0.1;
    
    if (supportListModel.data.count) {
        UIImageView *supportImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 20, 20, 17)];
        supportImg.image=[UIImage imageNamed:@"footprint-like"];
        [_bgImgView addSubview:supportImg];
        
        CGFloat  lastBottom = 0.0;
        CGFloat  icon_left  = 40.0;
        CGFloat  icon_top   = 20.0;
        for (NSInteger i=0; i<supportListModel.data.count; i++) {
            ZYOneSupportModel *userModel=supportListModel.data[i];
            
            if (icon_left+ICON_WIDTH+KEDGE_DISTANCE>_bgImgView.width) {
                icon_left = 40.0;
                icon_top+=ICON_EDG+ICON_WIDTH;
            }
            
            ZCDetailCustomButton *userBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(icon_left, icon_top, ICON_WIDTH, ICON_WIDTH)];
            userBtn.userId=userModel.userId;
            [userBtn sd_setImageWithURL:[NSURL URLWithString:userModel.faceImg64?userModel.faceImg64:userModel.faceImg132?userModel.faceImg132:userModel.faceImg640?userModel.faceImg640:userModel.faceImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
            
            icon_left+=ICON_EDG+ICON_WIDTH;
            lastBottom=userBtn.bottom;
            [_bgImgView addSubview:userBtn];
        }
        _bgImgView.height=lastBottom+KEDGE_DISTANCE;
        _bgImgView.image=KPULLIMG(@"comment-background", 15, 0, 5, 0);
    }
    
    _lineView.top=_bgImgView.height-0.5;
    supportListModel.cellHeight=_bgImgView.bottom;
}

@end
