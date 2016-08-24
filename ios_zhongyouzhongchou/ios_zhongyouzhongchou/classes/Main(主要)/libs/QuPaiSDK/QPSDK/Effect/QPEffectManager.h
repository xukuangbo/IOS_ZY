//
//  QPEffectManager.h
//  QupaiSDK
//
//  Created by yly on 15/6/18.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPEffectFilter.h"
#import "QPEffectMusic.h"

@interface QPEffectManager : NSObject

- (void)needUpdateMusicData;

- (NSUInteger)effectCountByType:(QPEffectType)type;
- (QPEffect *)effectAtIndex:(NSUInteger)index type:(QPEffectType)type;
- (QPEffect *)effectByID:(NSUInteger)eid type:(QPEffectType)type;
- (NSUInteger)effectIndexByID:(NSUInteger)eid type:(QPEffectType)type;

@end
