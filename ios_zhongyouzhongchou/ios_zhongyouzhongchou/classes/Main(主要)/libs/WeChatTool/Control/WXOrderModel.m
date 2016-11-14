//
//  WXOrderModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WXOrderModel.h"

@implementation WXOrderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _out_trade_no = nil;
        _payResult = NO;
        _orderType = 0;
    }
    return self;
}

-(void)initOrderState
{
    _out_trade_no = nil;
    _payResult = NO;
    _orderType = 0;
}

@end
