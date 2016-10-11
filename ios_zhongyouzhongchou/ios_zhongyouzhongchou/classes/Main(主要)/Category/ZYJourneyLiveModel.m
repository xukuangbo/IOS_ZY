//
//  ZYJourneyLiveModel.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/10/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYJourneyLiveModel.h"

@implementation ZYJourneyLiveModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"rewardMoney":@"style3Price",
             @"togetherGoMoney":@"style4Price",
             @"journeyTitle":@"title"};
}
@end
