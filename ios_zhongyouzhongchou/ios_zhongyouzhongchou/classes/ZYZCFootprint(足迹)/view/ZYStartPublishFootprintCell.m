//
//  ZYStartPublishFootprintCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define START_BTN_HEIGHT   80
#define ALERT_TEXT         @"点击添加新的足迹"
#import "ZYStartPublishFootprintCell.h"
#import "ZYStartFootprintBtn.h"
@interface ZYStartPublishFootprintCell ()

@property (nonatomic, strong) UIImageView        *bgImage;
@property (nonatomic, strong) UILabel            *timeLab;
@property (nonatomic, strong) UIView             *lineView;
@property (nonatomic, strong) UIImageView        *dotImageView;

@end

@implementation ZYStartPublishFootprintCell

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

- (void) configUI
{
    //背景卡片
    _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, START_CELL_HEIGHT)];
    _bgImage.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImage];
    
    //日期
    _timeLab = [ZYZCTool createLabWithFrame:CGRectMake(20, KEDGE_DISTANCE, _bgImage.width-30, 20) andFont:[UIFont systemFontOfSize:20] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _timeLab.text=@"现在";
    [_bgImage addSubview:_timeLab];
    
    //开始发布键
    ZYStartFootprintBtn *startBtn=[[ZYStartFootprintBtn alloc]initWithFrame:CGRectMake(35, _timeLab.bottom+KEDGE_DISTANCE, START_BTN_HEIGHT, START_BTN_HEIGHT)];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"footprint-start"] forState:UIControlStateNormal];
    [_bgImage addSubview:startBtn];
    
    //提示文字
    UILabel *alertLab=[ZYZCTool createLabWithFrame:CGRectMake(startBtn.right+30, 0, KSCREEN_W-startBtn.right-40-10, 20) andFont:[UIFont systemFontOfSize:17] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    alertLab.text=ALERT_TEXT;
    alertLab.centerY=startBtn.centerY;
    [_bgImage addSubview:alertLab];
    
    //轴线
    _lineView=[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, _timeLab.top, 0.5, START_CELL_HEIGHT-20) andColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0]];
    [_bgImage addSubview:_lineView];
    
    //节点
    _dotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE-5, 0, 10, 10)];
    _dotImageView.image=[UIImage imageNamed:@"footprint-point"];
    _dotImageView.centerY=_timeLab.centerY;
    [_bgImage addSubview:_dotImageView];
                  
}

-(void)setFootprintCellType:(FootprintCellType)footprintCellType
{
    _footprintCellType=footprintCellType;
    if (footprintCellType ==HeadCell) {
        _bgImage.image=KPULLIMG(@"background-1", 5, 0, 5, 0);
        _lineView.height=START_CELL_HEIGHT;
    }
    else
    {
        _bgImage.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        _lineView.height=START_CELL_HEIGHT-20;
    }
    
    
}

@end
