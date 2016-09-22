//
//  ZYCommentListModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCommentListModel.h"

@implementation ZYCommentListModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"ZYOneCommentModel"};
}

@end

@implementation ZYOneCommentModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellHeight=1.0;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}

@end
