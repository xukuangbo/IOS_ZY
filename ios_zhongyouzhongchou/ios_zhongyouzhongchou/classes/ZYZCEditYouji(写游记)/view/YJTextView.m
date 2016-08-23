//
//  YJTextView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "YJTextView.h"

@implementation YJTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.height=DEAFULT_HEIGHT;
    }
    return self;
}

- (CGFloat)textViewHeight
{
//    CGFloat height=[ZYZCTool calculateStrLengthByText:<#(NSString *)#> andFont:<#(UIFont *)#> andMaxWidth:<#(CGFloat)#>];
    
    return 0;
}

@end
