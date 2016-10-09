//
//  ZCOutHttpView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCNoneDataView.h"

@implementation ZCNoneDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setMyZCType:(NSInteger) myZCType
{
    _myZCType=myZCType;
    
    NSArray *iconArr=@[@"icon_mxc_cy",@"icon_mxc_fq",@"icon_mxc_tj"];
    NSArray *title01Arr=@[ZYLocalizedString(@"none_my_publish_01"),
                          ZYLocalizedString(@"none_my_join_01"),
                          ZYLocalizedString(@"none_my_recommend_01")];
    NSArray *title02Arr=@[ZYLocalizedString(@"none_my_publish_02"),
                          ZYLocalizedString(@"none_my_join_02"),
                          ZYLocalizedString(@"none_my_recommend_02")];
    
    self.iconView.image=[UIImage imageNamed:iconArr[myZCType]];
    self.lab01.text=title01Arr[myZCType];
    self.lab02.text=title02Arr[myZCType];
}

@end
