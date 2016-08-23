//
//  TogetherUersModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TogetherUersModel.h"
@implementation TogetherUersModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"users":@"user"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"users":@"UserModel"};
}

@end
