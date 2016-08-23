//
//  TacticModel.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticModel.h"
#import "MJExtension.h"
#import "TacticVideoModel.h"
#import "TacticSingleModel.h"
#import "TacticIndexImgModel.h"
@implementation TacticModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"videos" : [TacticVideoModel class],
             @"mgViews" : [TacticSingleModel class],
             @"indexImg" : [TacticIndexImgModel class],
             @"countryViews" : [TacticSingleModel class]
             };
}

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}
@end
