//
//  ZYTravelTypeView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYTravelTypeView.h"

@interface ZYTravelTypeView()

@property (nonatomic, strong) UIButton        *preButton;
@property (nonatomic, strong) UIView          *moveLine;
@end

@implementation ZYTravelTypeView

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
        self.height=40;
        self.backgroundColor=[UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //ta发起，ta参与，ta推荐
    [self addSubview:[UIView lineViewWithFrame:CGRectMake(0, self.height-1, self.width, 1) andColor:nil]];
    
    _moveLine=[UIView lineViewWithFrame:CGRectMake(0,0, 0, 2) andColor:[UIColor ZYZC_MainColor]];
    [self addSubview:_moveLine];
}

-(void)setItems:(NSArray *)items
{
    _items=items;
    _preButton=nil;
    NSArray *views=[self subviews];
    for (NSInteger i=views.count-1; i>=0; i--) {
        if ([views[i] isKindOfClass:[UIButton class]]) {
            [views[i] removeFromSuperview];
        }
    }
    
    CGFloat buttonWidth=70;
    CGFloat edg=(self.width-buttonWidth*3)/4;
    for (int i=0; i<_items.count; i++) {
        UIButton *button=[ZYZCTool createBtnWithFrame:CGRectMake(edg+(buttonWidth+edg)*i,0, buttonWidth,self.height) andNormalTitle:_items[i] andNormalTitleColor:[UIColor ZYZC_TextGrayColor] andTarget:self andAction:@selector(changeTravelType:)];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.tag=Travel_PublishType+i;
        [self addSubview:button];
        if (i==0) {
            [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
            _preButton=button;
        }
    }
    
    _moveLine.frame=CGRectMake(_preButton.left,self.height-2 , buttonWidth, 2);
}

#pragma mark --- 行程切换
-(void)changeTravelType:(UIButton *)button
{
    if (_preButton==button) {
        return;
    }
    //发布，参与，推荐
    
    if (_preButton&&_preButton!=button) {
        [_preButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
        _preButton=button;
        
        if (_changeTravelType) {
            _changeTravelType(button.tag);
        }
    }
    WEAKSELF;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.moveLine.left=button.left;
    }];
}

@end








