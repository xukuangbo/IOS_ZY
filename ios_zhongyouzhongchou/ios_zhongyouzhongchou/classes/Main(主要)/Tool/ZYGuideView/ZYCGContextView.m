//
//  FZCGContextView.m
//  Pods
//
//  Created by patty on 15/12/15.
//
//

#import "ZYCGContextView.h"

#define ALPHA 0.8

@implementation ZYCGContextView
{
    CGContextType _contextType;
    CGRect _contextRect;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRectInWay:(CGRect)rect withdrawType:(CGContextType)type
{
    _contextType = type;
    _contextRect = rect;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (_contextType) {
        case circleType:
        {
            CGContextBeginPath(context);
            CGContextAddArc(context, _contextRect.origin.x, _contextRect.origin.y, _contextRect.size.width, 0, M_PI * 2, 0);
            
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, self.bounds.size.height);
            CGContextAddLineToPoint(context, self.bounds.size.width , self.bounds.size.height);
            CGContextAddLineToPoint(context, self.bounds.size.width , 0);
            CGContextClosePath(context);
            
            CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:ALPHA] CGColor]);//偶数式填充颜色，填充第二个颜色
            CGContextEOFillPath(context);
            
            
            if(self.guideType == 6){//_contextRect.origin.y == 23){//老师端 关闭微课 填充
                CGContextBeginPath(context);
                CGContextAddArc(context, _contextRect.origin.x, _contextRect.origin.y, _contextRect.size.width, 0, M_PI * 2, 0);
                CGContextSetLineWidth(context, 1.0f);
                CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextStrokePath(context);
            }
        }
            break;
        case rectTangleType:
        {
//            BOOL equal = _contextRect.size.width == self.frame.size.width;
//            if(equal){
////                [[[UIColor blackColor] colorWithAlphaComponent:0.8] setFill];//设置要填充颜色
//               
//                CGContextFillRect(context, CGRectMake(0, 0, _contextRect.size.width, _contextRect.origin.y));
//                CGContextFillRect(context, CGRectMake(0, _contextRect.size.height+_contextRect.origin.y, _contextRect.size.width, self.frame.size.height-_contextRect.size.height-_contextRect.origin.y));
//                CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:ALPHA] CGColor]);
//                 CGContextEOFillPath(context);
//            }else{
//                
                CGContextBeginPath(context);
             
                CGContextMoveToPoint(context, _contextRect.origin.x, _contextRect.origin.y);
                CGContextAddLineToPoint(context, _contextRect.origin.x, _contextRect.origin.y+_contextRect.size.height);
                CGContextAddLineToPoint(context,  _contextRect.origin.x+ _contextRect.size.width ,  _contextRect.origin.y+ _contextRect.size.height);
                CGContextAddLineToPoint(context,  _contextRect.origin.x+ _contextRect.size.width , _contextRect.origin.y);
                CGContextClosePath(context);
                
                
                CGContextMoveToPoint(context, 0, 0);
                CGContextAddLineToPoint(context, 0, self.bounds.size.height);
                CGContextAddLineToPoint(context, self.bounds.size.width , self.bounds.size.height);
                CGContextAddLineToPoint(context, self.bounds.size.width , 0);
                CGContextClosePath(context);
                
                
                CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:ALPHA] CGColor]);
                CGContextEOFillPath(context);
                
            
        }
    }
    
}

//CGContextBeginPath(context);
//
//CGContextMoveToPoint(context, 0, 0);
//CGContextAddLineToPoint(context, 0, self.bounds.size.height);
//CGContextAddLineToPoint(context, _contextRect.size.width , self.bounds.size.height);
//CGContextAddLineToPoint(context, _contextRect.size.width , 0);
//
//CGContextMoveToPoint(context, self.bounds.size.width-_contextRect.size.width, 0);
//CGContextAddLineToPoint(context, self.bounds.size.width-_contextRect.size.width, self.bounds.size.height);
//CGContextAddLineToPoint(context, self.bounds.size.width , self.bounds.size.height);
//CGContextAddLineToPoint(context, self.bounds.size.width , 0);
//
//CGContextMoveToPoint(context, _contextRect.size.width, 0);
//CGContextAddLineToPoint(context, _contextRect.size.width, _contextRect.size.height);
//CGContextAddLineToPoint(context,  self.bounds.size.width-_contextRect.size.width-_contextRect.origin.x , _contextRect.size.height);
//CGContextAddLineToPoint(context, self.bounds.size.width-_contextRect.size.width-_contextRect.origin.x  , 0);
//
//CGContextMoveToPoint(context, _contextRect.origin.x,_contextRect.origin.y+_contextRect.size.height);
//CGContextAddLineToPoint(context, _contextRect.origin.x, self.bounds.size.height);
//CGContextAddLineToPoint(context, self.bounds.size.width-_contextRect.size.width-_contextRect.origin.x , self.bounds.size.height);
//CGContextAddLineToPoint(context, self.bounds.size.width-_contextRect.size.width-_contextRect.origin.x , _contextRect.origin.y+_contextRect.size.height);
//
//
//CGContextClosePath(context);
//CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:ALPHA] CGColor]);
//CGContextEOFillPath(context);

@end
