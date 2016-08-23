//
//  ChooseStarView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define FIRST_STAR_TAG    30

#import "ChooseStarView.h"
@interface ChooseStarView ()
@property (nonatomic, strong) NSMutableArray   *starArr;
@end
@implementation ChooseStarView

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    
    _starArr=[NSMutableArray array];
    
    //评价星星
    CGFloat starWidth=30.0;
    CGFloat edg=5.0;
    self.width=(starWidth+edg)*4+starWidth;
    
    for (int i=0; i<5; i++) {
        UIButton *star=[UIButton buttonWithType:UIButtonTypeCustom];
        star.frame=CGRectMake((starWidth+edg)*i,0, starWidth, starWidth) ;
        star.tag=FIRST_STAR_TAG+i;
        [star setImage:[UIImage imageNamed:@"star-gray"] forState:UIControlStateNormal];
        [star addTarget:self action:@selector(chooseStar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:star];
        [_starArr addObject:star];
    }
}

#pragma mark --- 选择星级
-(void)chooseStar:(UIButton *)button
{
    for (UIButton *star in _starArr) {
        if (star.tag<=button.tag) {
            [star setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        }
        else
        {
            [star setImage:[UIImage imageNamed:@"star-gray"] forState:UIControlStateNormal];
        }
    }
    _star=[NSNumber numberWithInteger:button.tag-FIRST_STAR_TAG+1];
    
    if (_clickBlock) {
        _clickBlock(button.tag-FIRST_STAR_TAG+1);
    }
}

@end
