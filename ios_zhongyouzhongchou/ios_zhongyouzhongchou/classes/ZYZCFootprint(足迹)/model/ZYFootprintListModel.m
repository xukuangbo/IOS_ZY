//
//  ZYFootprintListModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintListModel.h"

@implementation ZYFootprintDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ZYFootprintListModel":@"data"};
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

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"ID":@"id"};
}

@end


