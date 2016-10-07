//
//  MusicMoreDownProgressView.m
//  qupai
//
//  Created by yly on 14/11/26.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import "QPMusicMoreDownProgressView.h"

@implementation QPMusicMoreDownProgressView
{
    UIColor *_color;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (_progressThick == 0) {
        _progressThick = 2.0;
    }
    if (_edge == 0) {
        _edge = 3.0;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat y =  CGRectGetHeight(self.bounds) / 2.0;
    CGFloat r = x;
    
    CGContextSetFillColorWithColor(context,RGB(2, 212, 225).CGColor);
    CGContextAddArc(context, x, y, r, 0, M_PI*2, 0);
    CGContextFillPath(context);
    
    CGContextSetLineWidth(context, _progressThick);
    CGContextSetStrokeColorWithColor(context,  [UIColor whiteColor].CGColor);
    CGFloat sa =  - ((float)M_PI / 2);
    CGFloat ea = M_PI * 2 * _progress + sa;
    CGContextAddArc(context, x, y, r - _edge - _progressThick, sa, ea, 0);
    CGContextStrokePath(context);
}

@end
