//
//  ZYLiveHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveHeadView.h"
#import "UIView+ZYLayer.h"

@implementation ZYLiveHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    self.iconView.layerCornerRadius = self.iconView.height * 0.5;
    self.layerCornerRadius = self.height * 0.5;
}
@end
