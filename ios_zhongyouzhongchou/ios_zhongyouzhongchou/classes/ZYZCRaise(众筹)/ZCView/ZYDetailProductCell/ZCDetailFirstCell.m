//
//  ZCDetailFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailFirstCell.h"

@implementation ZCDetailFirstCell

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
    self.bgImg.height=ZCDETAIL_FIRSTCELL_HEIGHT;
    self.titleLab.text=@"联合发起人";
    self.titleLab.font=[UIFont boldSystemFontOfSize:15];
    self.titleLab.textColor=[UIColor ZYZC_TextBlackColor];
}

@end
