//
//  ZCDetailIntroThirdCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//



#import "ZCDetailIntroThirdCell.h"
@implementation ZCDetailIntroThirdCell

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
    self.bgImg.height=ZCDETAILINTRO_THIRDCELL_HEIGHT;
    self.titleLab.text=@"视频攻略";
    self.titleLab.font=[UIFont boldSystemFontOfSize:17];
    [self.topLineView removeFromSuperview];
    
//    UIView *view01=[UIView lineViewWithFrame:CGRectMake(2*KEDGE_DISTANCE, KEDGE_DISTANCE+5, 2, 20) andColor:[UIColor ZYZC_MainColor]];
//    [self.contentView addSubview:view01];
//    self.titleLab.left=view01.right ;
    
    _subDesLab=[[UILabel alloc]initWithFrame:CGRectMake(3*KEDGE_DISTANCE, self.titleLab.bottom+KEDGE_DISTANCE, KSCREEN_W-4*KEDGE_DISTANCE, 20)];
    _subDesLab.textColor=[UIColor ZYZC_TextGrayColor04];
    _subDesLab.text=SUBDES_FORMOVIE(@"");
    [self.contentView addSubview:_subDesLab];
    
    _movieImg =[[ZYZCCusomMovieImage alloc]initWithFrame:CGRectMake(2*KEDGE_DISTANCE, _subDesLab.bottom+KEDGE_DISTANCE, KSCREEN_W-4*KEDGE_DISTANCE,(KSCREEN_W-4*KEDGE_DISTANCE)*5/8)];
    [self.contentView addSubview:_movieImg];
}

-(void)setSpotVideoModel:(ZCSpotVideoModel *)spotVideoModel
{
    _spotVideoModel=spotVideoModel;
    [_movieImg sd_setImageWithURL:[NSURL URLWithString:KWebImage(spotVideoModel.videoImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options: SDWebImageRetryFailed | SDWebImageLowPriority];
    _movieImg.playUrl=spotVideoModel.videoUrl;
    
}


@end
