//
//  FZCGContextView.h
//  Pods
//
//  Created by patty on 15/12/15.
//
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    circleType,//圆
    rectTangleType,//矩形
} CGContextType;


@interface ZYCGContextView : UIView

@property (assign, nonatomic) NSInteger guideType;

- (void)drawRectInWay:(CGRect)rect withdrawType:(CGContextType)type;

@end
