//
//  ZCDetailTableHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailTableHeadView.h"

#define BG_HEIGHT 33

@implementation ZCDetailTableHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    UIView *view=[[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self addSubview:view];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, (self.height-BG_HEIGHT)/2, self.width-2*KEDGE_DISTANCE, BG_HEIGHT)];
    bgView.backgroundColor=[UIColor ZYZC_BgGrayColor02];
    bgView.layer.cornerRadius=KCORNERRADIUS;
    bgView.layer.masksToBounds=YES;
    [view addSubview:bgView];
    
    NSArray *titleArr=@[@"介绍",@"行程",@"回报"];
    for (int i=0; i<3; i++) {
        [bgView addSubview:[self setButton:i withTitle:titleArr[i] withMoreFZCToolBarType:IntroType+i]];
    }
}

/**
 *
 *  创建3个点击的按钮
 */
- (UIButton *)setButton:(NSInteger)index withTitle:(NSString *)titleName withMoreFZCToolBarType:(ZCDetailContentType)contentType
{
    CGFloat edge    = 1.5;
    CGFloat buttonY = edge;
    CGFloat buttonW = (self.width-KEDGE_DISTANCE * 2 - edge * 4)/3;
    CGFloat buttonH = BG_HEIGHT-edge *2;
    CGFloat buttonX = edge+ index * (edge+buttonW);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    button.layer.cornerRadius=KCORNERRADIUS;
    button.layer.masksToBounds=YES;
    [button setTitle:titleName forState:UIControlStateNormal];
    button.tag = contentType;
    [button addTarget:self action:@selector(getContent:) forControlEvents:UIControlEventTouchUpInside];
    
    if (index==0) {
        _preClickBtn=button;
        [self getButtonHeightState:button];
    }
    else
    {
        [self getButtonNormalState:button];
    }
    return button;
}

#pragma mark --- button点击事件
-(void)getContent:(UIButton *)button
{
    [self getButtonHeightState:button];
    
    if (_preClickBtn!=button) {
        [self getButtonNormalState:_preClickBtn];
    }
    _preClickBtn=button;
    
    if (self.clickChangeContent) {
        self.clickChangeContent(button.tag);
    }
}


#pragma mark --- buttonNormalState
-(void)getButtonNormalState:(UIButton *)button
{
    [button setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor ZYZC_BgGrayColor02];
}

#pragma mark --- buttonHeightState
-(void)getButtonHeightState:(UIButton *)button
{
    [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor whiteColor];
}

-(void)dealloc{
    
}

@end












