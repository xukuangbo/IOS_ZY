//
//  WSMBaseView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WSMBaseView.h"

@implementation WSMBaseView

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
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=KCORNERRADIUS;
        self.layer.masksToBounds=YES;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    
}


@end
