//
//  ZYCustomSegmentView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCustomSegmentView.h"
#define TAG_NUMBETR   100
@interface ZYCustomSegmentView ()

@property (nonatomic, strong) UIButton *preBtn;

@end

@implementation ZYCustomSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:212.0/225.0 green:212.0/225.0 blue:212.0/225.0 alpha:1.0];
        self.layer.cornerRadius=KCORNERRADIUS;
        self.layer.masksToBounds=YES;
        [self configUIWithItems:items];
    }
    return self;
}

-(void)configUIWithItems:(NSArray *)items
{
    CGFloat btn_width=(self.width-items.count-1)/items.count;
    CGFloat btn_height=self.height-2;
    for (NSInteger i=0; i<items.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(1+(btn_width+1)*i, 1, btn_width, btn_height);
        [btn setTitle:items[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius=4;
        btn.layer.masksToBounds=YES;
        btn.tag=i+TAG_NUMBETR;
        btn.titleLabel.font=[UIFont systemFontOfSize:17];
        [self buttonNormalState:btn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(changeSegmented:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex=selectedIndex;
    
    if (_preBtn) {
        [self buttonNormalState:_preBtn];
    }
    UIView *subView=[self viewWithTag:selectedIndex+TAG_NUMBETR];
    if (subView&&[subView isKindOfClass:[UIButton class]]) {
        [self buttonSelectState:(UIButton *)subView];
        _preBtn=(UIButton *)subView ;
    }
}

#pragma mark --- 切换按钮
-(void)changeSegmented:(UIButton *)button
{
    if (_preBtn) {
        [self buttonNormalState:_preBtn];
    }
    [self buttonSelectState:button];
    _preBtn=button;
    
    if (_changeSelectIndex) {
        _changeSelectIndex(button.tag-TAG_NUMBETR);
    }
}

#pragma mark --- 选中状态的btn
-(void)buttonSelectState:(UIButton *)button
{
    button.backgroundColor=[UIColor ZYZC_MainColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark --- 正常状态的btn
-(void)buttonNormalState:(UIButton *)button
{
    button.backgroundColor=[UIColor colorWithRed:212.0/225.0 green:212.0/225.0 blue:212.0/225.0 alpha:1.0];
    [button setTitleColor:[UIColor colorWithRed:105.0/225.0 green:105.0/225.0 blue:105.0/225.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void)dealloc
{
    
}


@end
