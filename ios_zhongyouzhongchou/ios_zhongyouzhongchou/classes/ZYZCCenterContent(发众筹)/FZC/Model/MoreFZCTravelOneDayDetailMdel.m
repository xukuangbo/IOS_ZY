//
//  MoreFZCTravelOneDayDetailMdel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCTravelOneDayDetailMdel.h"

@implementation MoreFZCTravelOneDayDetailMdel

MJCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellHeight=100.0;
    }
    return self;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"siteDes"   :  @"spot",
             @"sites"     :  @"spots",
             @"trafficDes":  @"trans",
             @"liveDes"   :  @"live",
             @"foodDes"   :  @"food",
             @"wordDes"   :  @"desc",
             @"voiceUrl"  :  @"voice",
             @"movieUrl"  :  @"video",
             @"movieImg"  :  @"videoImg",
             @"imgUrlStr" :  @"descImgs"
             };
}


@end
