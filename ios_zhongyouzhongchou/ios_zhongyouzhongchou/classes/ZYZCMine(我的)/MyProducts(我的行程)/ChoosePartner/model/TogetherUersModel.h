//
//  TogetherUersModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface TogetherUersModel : NSObject
@property (nonatomic, strong) NSNumber *people;//报名人数
@property (nonatomic, strong) NSNumber *price; //单价
@property (nonatomic, strong) NSNumber *reportId;
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSNumber *sumPeople;//总人数
@property (nonatomic, strong) NSNumber *sumPrice; //总金额
@property (nonatomic, strong) NSArray  *users;
@end
