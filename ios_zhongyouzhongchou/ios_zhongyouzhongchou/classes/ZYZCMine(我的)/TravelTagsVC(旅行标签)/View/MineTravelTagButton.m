
//
//  MineTravelTagButton.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MineTravelTagButton.h"
@interface MineTravelTagButton ()

@end
@implementation MineTravelTagButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = MineTravelTagBtnFont;
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.layer.cornerRadius = frame.size.height * 0.5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        
        
        [self addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTextString:(NSString *)textString
{
    _textString = textString;
    
    [self setTitle:textString forState:UIControlStateNormal];
}

- (void)buttonClickAction:(UIButton *)button
{
    self.buttonClickBlock();
}
@end
