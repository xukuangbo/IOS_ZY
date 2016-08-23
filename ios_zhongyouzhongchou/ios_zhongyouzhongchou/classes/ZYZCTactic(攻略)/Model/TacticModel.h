//
//  TacticModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TacticModel : NSObject
//id 7
@property (nonatomic, copy) NSString *ID;
//"pics": [
//         "1462261928476.jpg",
//         "1462261932195.jpg"
//         ],
@property (nonatomic, strong) NSArray *pics;

//"videos": [
@property (nonatomic, strong) NSArray *videos;

/**
 *  热门目的地模型
 */
@property (nonatomic, strong) NSArray *mgViews;
/**
 *  热门国家模型
 */
@property (nonatomic, strong) NSArray *countryViews;


@property (nonatomic, strong) NSArray *indexImg;

@end
