//
//  ZYBaseLimitTextField.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYBaseLimitTextField.h"

@interface ZYBaseLimitTextField ()<UITextFieldDelegate>

@property (nonatomic, assign) NSInteger maxTextNum;//最大文字字数

@end


@implementation ZYBaseLimitTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andMaxTextNum:(NSInteger)maxNum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor=[UIColor ZYZC_MainColor];
        self.textColor=[UIColor ZYZC_TextBlackColor];
        _maxTextNum = maxNum;
        self.delegate=self;
    }
    return self;
}

- (instancetype)initWithMaxTextNum:(NSInteger)maxNum
{
    self = [super init];
    if (self) {
        self.tintColor=[UIColor ZYZC_MainColor];
        self.textColor=[UIColor ZYZC_TextBlackColor];
        _maxTextNum = maxNum;
        self.delegate=self;
    }
    return self;
}


@end
