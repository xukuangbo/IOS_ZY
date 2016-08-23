//
//  ZCCommentModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCCommentModel.h"

@implementation ZCCommentList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listCommentHeight=70;
    }
    return self;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentList":@"data"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"commentList":@"ZCCommentModel"};
}

@end

@implementation ZCCommentModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellHeight=70;
    }
    return self;
}

@end

@implementation ZCCommentInfoModel

@end
