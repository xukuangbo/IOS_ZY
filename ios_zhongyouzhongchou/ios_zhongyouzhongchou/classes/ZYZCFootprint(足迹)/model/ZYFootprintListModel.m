//
//  ZYFootprintListModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintListModel.h"

@implementation ZYFootprintDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"ZYFootprintListModel"};
}

@end


@implementation ZYFootprintListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellHeight=1.0;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id",@"footprintType":@"type"};
}

@end


