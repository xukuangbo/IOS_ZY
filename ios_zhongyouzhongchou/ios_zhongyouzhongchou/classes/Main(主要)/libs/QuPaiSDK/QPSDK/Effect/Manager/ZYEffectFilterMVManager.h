//
//  ZYEffectFilterMVManager.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPEffectMV.h"

@interface ZYEffectFilterMVManager : NSObject

@property (nonatomic, strong) NSMutableArray *filter_mvs;

- (NSMutableArray *)loadEffectFilterMVs;

- (NSMutableArray *)bundleEffectFilterMVs;
- (NSMutableArray *)localEffectFilterMVs;

- (void)deleteEffectFilterMVByID:(NSUInteger)eid;


- (void)refresh;

@end
