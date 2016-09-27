//
//  UINavigationBar+Extension.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "UINavigationBar+Extension.h"
static char overlayKey;
@implementation UINavigationBar (Extension)
- (UIView *)overlay{
    
    return objc_getAssociatedObject(self, &overlayKey);
    
}

- (void)setOverlay:(UIView *)overlay{
    
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(void)ls_setBackgroundColor:(UIColor *)backgroundColor{
    
    if (!self.overlay) {
        
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        //去掉灰色的线。其实这个线也是image控制的。设为空即可
        
        self.shadowImage = [UIImage new];
        
        UIView *barBgView = self.subviews.firstObject;
        
        self.overlay = [[UIView alloc] initWithFrame:barBgView.bounds];
        
        self.overlay.userInteractionEnabled = NO;
        
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [barBgView addSubview:self.overlay];
        
    }
    
    self.overlay.backgroundColor = backgroundColor;
    
}
@end
