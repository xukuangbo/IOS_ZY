//
//  EffectTabArrowLine.m
//  qupai
//
//  Created by yly on 14/11/12.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import "QPEffectTabView.h"

@implementation QPEffectTabView


- (void)setFromX:(CGFloat)fromX
{
    _fromX = fromX;
}

- (void)setToX:(CGFloat)toX
{
    _toX = toX;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGPoint points[2] = {};
    points[0].x = _fromX;
    points[0].y = h - 1.5;
    points[1].x = _toX;
    points[1].y = h - 1.5;
    CGContextAddLines(context, points, sizeof(points)/sizeof(CGPoint));
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextStrokePath(context);
}


@end
