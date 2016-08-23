//
//  ZCSupportOneYuanView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportOneYuanView.h"

@implementation ZCSupportOneYuanView

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
    [self.lineView removeFromSuperview];
    [self.limitLab removeFromSuperview];
}

-(void)supportMoney
{
    if (!self.chooseSupport) {
        [MBProgressHUD showError:@"此选项只能支持一次"];
        return;
    }
    
    [super supportMoney];
}


@end
