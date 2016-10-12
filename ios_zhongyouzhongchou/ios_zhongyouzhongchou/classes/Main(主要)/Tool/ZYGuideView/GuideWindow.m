//
//  ZYNewGuiView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "GuideWindow.h"

@implementation GuideWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert+1.0f;
        self.hidden = YES;
     
        [self makeKeyAndVisible];
    }
    return self;
}

#pragma mark -显示

- (void)show
{
    self.hidden = NO;
}

#pragma mark -消失

- (void)dismiss
{
    self.hidden = YES;
}


@end
