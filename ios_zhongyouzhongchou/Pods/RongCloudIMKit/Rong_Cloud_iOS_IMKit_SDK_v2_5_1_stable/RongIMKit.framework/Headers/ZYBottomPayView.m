//
//  ZYBottomPayView.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYBottomPayView.h"

@implementation ZYBottomPayView

+ (instancetype)loadCustumView {
    ZYBottomPayView * view = nil;
    NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"BottomPayView" owner:self options:nil];
    view = (ZYBottomPayView *)[nibs objectAtIndex:0];
    [view initMember];
    
    return view;
}


- (void)initMember {
    self.frame = CGRectMake(10,[UIScreen mainScreen].bounds.size.height/2 - self.frame.size.width/2, [UIScreen mainScreen].bounds.size.width-20, self.frame.size.height);
    for (UIView *tmpView in self.selectPayView.subviews)
    {
        if(tmpView.userInteractionEnabled && [tmpView isMemberOfClass:[UIButton class]])
        {
            [tmpView.layer setMasksToBounds:YES];
            [tmpView.layer setBorderWidth:1];
            [tmpView.layer setCornerRadius:4];
            [tmpView.layer setBorderColor:[[UIColor colorWithHexString:@"#d6d6d6"] CGColor]];
            
            UIButton *btn = (UIButton *)tmpView;
            [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"439cf4"] forState:UIControlStateSelected];
        }
    }
}

@end
