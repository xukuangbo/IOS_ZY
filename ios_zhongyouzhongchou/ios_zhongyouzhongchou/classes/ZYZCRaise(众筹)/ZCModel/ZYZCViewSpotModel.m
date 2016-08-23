//
//  ZYZCViewSpotModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCViewSpotModel.h"

@implementation ZYZCViewSpotModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"OneSpotModel"};
}

@end


@implementation OneSpotModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


@end