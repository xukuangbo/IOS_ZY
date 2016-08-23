//
//  ZCDetailModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailModel.h"

@implementation ZCDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"detailProductModel":@"data"};
}
@end

@implementation ZCDetailProductModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _introFirstCellHeight=1.0;
        _returnFirtCellHeight=1.0;
    }
    return self;
}


+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Friend":@"friend"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"report":@"ReportModel"};
}

@end

@implementation ReportModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"users":@"UserModel"};
}

@end
