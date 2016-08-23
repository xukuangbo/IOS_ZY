//
//  NecessaryView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "NecessaryView.h"

@implementation NecessaryView

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
        self.size=CGSizeMake(10, 10)  ;
        self.image=[UIImage imageNamed:@"icn_self_infor_label"];
    }
    return self;
}

- (instancetype)initWithTop:(CGFloat )top
{
    self = [super init];
    if (self) {
        self.top=top;
        self.left=KSCREEN_W-30;
        self.size=CGSizeMake(10, 10)  ;
        self.image=[UIImage imageNamed:@"icn_self_infor_label"];
    }
    return self;
}


@end
