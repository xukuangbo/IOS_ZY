//
//  QPEffectManager.m
//  QupaiSDK
//
//  Created by yly on 15/6/18.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import "QPEffectManager.h"

@implementation QPEffectManager
{
    NSArray *_arrayMusic;
    NSArray *_arrayFilter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrayFilter = [self createFilter];
        _arrayMusic  = [self createMusic];
        return self;
    }
    return nil;
}

- (void)needUpdateMusicData
{
    _arrayMusic  = [self createMusic];
}

- (NSArray *)createFilter
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:16];
    QPEffectFilter *effect;
    
    effect = [[QPEffectFilter alloc] init];// clientID:0 name:@"原片" imageName:@"mv_sample_b.png"];
    effect.name = @"原片";
    effect.eid = 0;
    effect.icon = [[QPBundle mainBundle] pathForResource:@"mv_sample_b@2x" ofType:@"png"];
    [array addObject:effect];
    
    NSString *configPath = [[QPBundle mainBundle] pathForResource:@"filter" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"filter"];
    NSString *baseDir = [[QPBundle mainBundle] bundlePath];
    for (NSDictionary *item in items) {
        effect = [[QPEffectFilter alloc] init];
        effect.mvPath = item[@"resourceUrl"];
        effect.name   = item[@"name"];
        effect.icon = [[baseDir stringByAppendingPathComponent:item[@"resourceUrl"]] stringByAppendingPathComponent:@"icon.png"];
        effect.eid = [item[@"id"] integerValue];
        [array addObject:effect];
    }
    return array;
}

- (NSArray *)createMusic
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    
    if(QupaiSDK.shared.enableMoreMusic){
        QPEffectMusic *effect = [[QPEffectMusic alloc] init];
        effect.name = @"更多音乐";
        effect.eid = INT_MAX;
        effect.icon = [[QPBundle mainBundle] pathForResource:@"edit_ico_more@2x" ofType:@"png"];
        effect.musicName = nil;
        [array addObject:effect];
    }
    {
        QPEffectMusic *effect = [[QPEffectMusic alloc] init];
        effect.name = @"原音";
        effect.eid = 0;
        effect.icon = [[QPBundle mainBundle] pathForResource:@"music_0@2x" ofType:@"png"];
        effect.musicName = nil;
        [array addObject:effect];
    }
    
    if ([QupaiSDK.shared.delegte respondsToSelector:@selector(qupaiSDKMusics:)]) {
        NSArray *more = [QupaiSDK.shared.delegte qupaiSDKMusics:QupaiSDK.shared];
        [array addObjectsFromArray:more];
    }
    return array;
}


- (NSArray *)arrayByType:(QPEffectType)type
{
    if (type == QPEffectTypeFilter) {
        return _arrayFilter;
    }else if(type == QPEffectTypeMusic){
        return _arrayMusic;
    }
    return nil;
}

- (NSUInteger)effectCountByType:(QPEffectType)type
{
    NSArray *array = [self arrayByType:type];
    return array.count;
}

- (QPEffect *)effectAtIndex:(NSUInteger)index type:(QPEffectType)type
{
    NSArray *array = [self arrayByType:type];
    if (index > array.count - 1) {
        return nil;
    }
    return array[index];
}

- (QPEffect *)effectByID:(NSUInteger)eid type:(QPEffectType)type
{
    NSArray *array = [self arrayByType:type];
    for (QPEffect *e in array) {
        if (e.eid == eid) {
            return e;
        }
    }
    return nil;
}

- (NSUInteger)effectIndexByID:(NSUInteger)eid type:(QPEffectType)type
{
    NSArray *array = [self arrayByType:type];
    __block NSUInteger index = 0;
    [array enumerateObjectsUsingBlock:^(QPEffect *obj, NSUInteger idx, BOOL *stop) {
        if (obj.eid == eid) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
@end
