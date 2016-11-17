//
//  CertificationInputVIew.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CertificationInputVIew.h"

@implementation CertificationInputVIew

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 256.0 green:arc4random_uniform(256) / 256.0 blue:arc4random_uniform(256) / 256.0 alpha:1];
    }
    return self;
}

@end
