//
//  ZYimageView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYimageView.h"

@interface ZYimageView ()
@property (nonatomic, strong) UIImageView *markImg;
@property (nonatomic, strong) UIView      *coverView;

@end

@implementation ZYimageView

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
        CGFloat mark_width=30;
        _markImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-mark_width-KEDGE_DISTANCE, self.height-mark_width-KEDGE_DISTANCE, mark_width, mark_width)];
        _markImg.image=[UIImage imageNamed:@"选中"];
        _markImg.hidden=YES;
        [self addSubview:_markImg];
        
        _coverView=[[UIView alloc]initWithFrame:self.bounds];
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.15;
        _coverView.hidden=YES;
        [self addSubview:_coverView];
    }
    return self;
}

-(void)setHiddenMark:(BOOL)hiddenMark
{
    _hiddenMark=hiddenMark;
    _markImg.hidden=hiddenMark;
    _coverView.hidden=hiddenMark;
    
    if (!hiddenMark) {

    }
}

@end







