//
//  ZYEffectFilterMVManager.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYEffectFilterMVManager.h"

@interface ZYEffectFilterMVManager ()
@property (nonatomic, strong) NSMutableArray *customFilterMVs;
@property (nonatomic, strong) NSMutableArray *bundleFilterMVs;
@property (nonatomic, strong) NSMutableArray *localFilterMVs;
@end

@implementation ZYEffectFilterMVManager

#pragma mark - load

- (NSMutableArray *)loadEffectFilterMVs {
    _filter_mvs = [NSMutableArray arrayWithCapacity:4];
    _customFilterMVs = [NSMutableArray arrayWithCapacity:4];
    _bundleFilterMVs = [NSMutableArray arrayWithCapacity:4];
    _localFilterMVs = [NSMutableArray arrayWithCapacity:4];
    {
        QPEffectMV *effect = [[QPEffectMV alloc] init];
        effect.name = @"更多";
        effect.eid = INT_MAX;
        effect.icon = [[QPBundle mainBundle] pathForResource:@"edit_ico_more@2x" ofType:@"png"];
        [_customFilterMVs addObject:effect];
    }
    {
        QPEffectMV *effect = [[QPEffectMV alloc] init];
        effect.name = @"原片";
        effect.eid = 0;
        effect.icon = [[QPBundle mainBundle] pathForResource:@"mv_sample_b@2x" ofType:@"png"];
        [_customFilterMVs addObject:effect];
        
    }
    [_filter_mvs addObjectsFromArray:_customFilterMVs];
    
    [_bundleFilterMVs addObjectsFromArray:[self loadBundleEffectFilterMVs]];
    if (_bundleFilterMVs.count) {
        [_filter_mvs addObjectsFromArray:_bundleFilterMVs];
    }
    
    [_localFilterMVs addObjectsFromArray:[self loadLocalEffectFilterMVs]];
    if (_localFilterMVs.count) {
        [_filter_mvs addObjectsFromArray:_localFilterMVs];
    }
    return _filter_mvs;
}

- (NSArray *)loadBundleEffectFilterMVs {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:16];
    NSString *configPath = [[QPBundle mainBundle] pathForResource:@"mv" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"filter"];
    NSString *baseDir = [[QPBundle mainBundle] bundlePath];
    for (NSDictionary *item in items) {
        QPEffectMV *effect = [[QPEffectMV alloc] init];
        effect.resourceLocalUrl = [baseDir stringByAppendingPathComponent:item[@"resourceUrl"]];
        effect.name = item[@"name"];
        effect.icon = [effect resourceLocalIconPath];
        effect.eid = [item[@"id"] integerValue];
        if ([item[@"tag"] isEqualToString:@"zhongyou_filter"]) {
            [array addObject:effect];
        }
    }
    return array;
}

- (NSArray *)loadLocalEffectFilterMVs {
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *mvDir = [QPEffect storageDirectoryWithEffectType:QPEffectTypeMV];
    NSString *mvPath = [basePath stringByAppendingPathComponent:mvDir];
    if([[NSFileManager defaultManager] fileExistsAtPath:mvPath]){
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:16];
        NSError *error = nil;
        NSArray *subPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mvPath error:&error];
        if (error) return nil;
        for (NSString *subPath in subPaths) {
            NSArray *components = [subPath componentsSeparatedByString:@"-"];
            if (components.count != 3) continue;
            QPEffectMV *effect = [[QPEffectMV alloc] init];
            effect.resourceLocalUrl = [mvPath stringByAppendingPathComponent:subPath];
            effect.name = components[1];
            effect.tag = components[2];
            effect.icon = [effect resourceLocalIconPath];
            effect.eid = [components[0] integerValue];
            if ([effect.tag isEqualToString:@"zhongyou_filter"]) {
                [array addObject:effect];
            }
        }
        return array;
    }
    return nil;
}

#pragma mark - getter

-(NSMutableArray *)localEffectFilterMVs {
    return _localFilterMVs;
}

-(NSMutableArray *)bundleEffectFilterMVs {
    return _bundleFilterMVs;
}

#pragma mark - manage

- (void)refresh {
    [_filter_mvs removeAllObjects];
    [_filter_mvs addObjectsFromArray:_customFilterMVs];
    [_filter_mvs addObjectsFromArray:_bundleFilterMVs];
    _localFilterMVs = [NSMutableArray arrayWithArray:[self loadLocalEffectFilterMVs]];
    [_filter_mvs addObjectsFromArray:_localFilterMVs];
}

-(void)deleteEffectFilterMVByID:(NSUInteger)eid {
    for (QPEffectMV *mv in _localFilterMVs) {
        if (mv.eid == eid) {
            [self deleteEffectFilterMV:mv];
            break;
        }
    }
}

- (void)deleteEffectFilterMV:(QPEffectMV *)mv {
    NSString *localPath = mv.resourceLocalUrl;
    if([[NSFileManager defaultManager] fileExistsAtPath:localPath]){
        [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
    }
    [self refresh];
}

@end
