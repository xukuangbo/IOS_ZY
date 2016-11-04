//
//  SupportStyleModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "SupportStateModel.h"

@implementation SupportStateModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isMyself  = NO;
        _productEnd= NO;
        _canChoose = YES;
        _isChoose  = NO;
        _isOpenMoreDec= NO;
        _isGetMax  =NO;
    }
    return self;
}
@end
