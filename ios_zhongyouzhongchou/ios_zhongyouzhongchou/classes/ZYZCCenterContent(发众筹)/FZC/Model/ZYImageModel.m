//
//  ZYImageModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYImageModel.h"

@implementation ZYImageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _markHidden=YES;
    }
    return self;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end


@implementation ListImgModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"ZYImageModel"};
}

@end

