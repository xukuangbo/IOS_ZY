//
//  MineTravelTagsModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineTravelTagsModel : NSObject
//id = 7;
@property (nonatomic, assign) int id;
//px = 7;
@property (nonatomic, assign) int px;

//tag = 1;
@property (nonatomic, copy) NSString *tag;
//value = "\U540d\U6c14\U8003\U5bdf";
@property (nonatomic, copy) NSString *value;
@end
