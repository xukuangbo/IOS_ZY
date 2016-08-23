//
//  MsgListModel.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MsgListModel.h"

@implementation MsgDataModel
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"MsgListModel"};
    
}
@end

@implementation MsgListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
