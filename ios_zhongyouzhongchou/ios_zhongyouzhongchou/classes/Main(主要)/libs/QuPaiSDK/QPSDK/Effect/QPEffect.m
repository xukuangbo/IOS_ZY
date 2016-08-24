//
//  QPEffect.m
//  QupaiSDK
//
//  Created by yly on 15/6/18.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "QPEffect.h"

@implementation QPEffect


- (BOOL)isMore
{
    return _eid == INT_MAX;
}

- (BOOL)isEmpty
{
    return _eid == 0;
}


@end
