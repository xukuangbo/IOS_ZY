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
    _bgImage.image=KPULLIMG(@"background-1", 5, 0, 5, 0);
    [self.contentView addSubview:_bgImage];
    
    //日期
    _timeLab = [ZYZCTool createLabWithFrame:CGRectMake(20, KEDGE_DISTANCE, _bgImage.width-30, 20) andFont:[UIFont systemFontOfSize:20] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _timeLab.text=@"现在";
    [_bgImage addSubview:_timeLab];
    
    //开始发布键
    UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame=CGRectMake(35, _timeLab.bottom+KEDGE_DISTANCE, START_BTN_HEIGHT, START_BTN_HEIGHT);
    [startBtn setBackgroundImage:[UIImage imageNamed:@"footprint-start"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startPublish) forControlEvents:UIControlEventTouchUpInside];
    [_bgImage addSubview:startBtn];
    
    //提示文字
    UILabel *alertLab=[ZYZCTool createLabWithFrame:CGRectMake(startBtn.right+40, 0, KSCREEN_W-startBtn.right-40-10, 20) andFont:[UIFont systemFontOfSize:20] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    alertLab.text=ALERT_TEXT;
    alertLab.centerY=startBtn.centerY;
    [_bgImage addSubview:alertLab];
                  
    
}

#pragma mark --- 开始发布行程
-(void)startPublish
{
    
}

@end
