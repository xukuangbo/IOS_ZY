//
//  TacticGeneralModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TacticGeneralModel : NSObject
////"name": "越南",
@property (nonatomic, copy) NSString *name;
////"id": 12
@property (nonatomic, assign) NSInteger viewid;
//        "viewType": 3
@property (nonatomic, assign) NSInteger viewType;

@property (nonatomic, copy) NSString *viewText;
// "pics": "1461046312210.jpg,1461046315094.jpg",
@property (nonatomic, copy) NSArray *pics;
//"name": "test12",
@property (nonatomic, copy) NSString *viewImg;

@property (nonatomic, copy) NSString *countryImg;

@property (nonatomic, copy) NSString *country;

@end
