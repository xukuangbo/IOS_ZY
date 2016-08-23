//
//  ZYZCViewSpotModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class oneSpotModel;

@interface ZYZCViewSpotModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end

@interface OneSpotModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, strong) NSNumber *viewType;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *pinyin;
@end

