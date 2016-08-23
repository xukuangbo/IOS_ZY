//
//  TacticMainImageView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainImageView.h"

@implementation TacticMainImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //添加圆角
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        //给button提那家一个底部的透明图
        CGFloat greenBGViewW = frame.size.width;
        CGFloat greenBGViewH = 20;
        CGFloat greenBGViewX = 0;
        CGFloat greenBGViewY = frame.size.height - greenBGViewH;
        UIView *greenBGView = [[UIView alloc] initWithFrame:CGRectMake(greenBGViewX, greenBGViewY, greenBGViewW, greenBGViewH)];
        greenBGView.backgroundColor = [UIColor ZYZC_MainColor];
        greenBGView.alpha = 0.7;
        [self addSubview:greenBGView];
        
        //给button添加一个底部的label
        CGFloat labelW = frame.size.width;
        CGFloat labelH = 20;
        CGFloat labelX = 0;
        CGFloat labelY = frame.size.height - labelH;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        
    }
    return self;
}

@end
