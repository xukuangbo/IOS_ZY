//
//  FZGuideManager.m
//  Pods
//
//  Created by patty on 15/12/17.
//
//

#import "ZYGuideManager.h"

//显示引导
static NSString *const kUserInfoStartZhongchouGuide = @"kUserInfoStartZhongchouGuide";
static NSString *const KUserInfoPreviewGuide = @"KUserInfoPreviewGuide";
static NSString *const kUserInfoChangeVoiceGuide = @"kUserInfoChangeVoiceGuide";
static NSString *const kUserInfoSkipGuide = @"kUserInfoSkipGuide";
static NSString *const kUserInfoStartLiveGuide = @"kUserInfoStartLiveGuide";

@implementation ZYGuideManager

/**
 *  发起众筹引导
 *
 *
 */
+ (void)guideStartZhongchou:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoStartZhongchouGuide];
}

+ (BOOL)getGuideStartZhongchou
{
    return [self integerFromUserDefaultsKey:kUserInfoStartZhongchouGuide];
}

/**
 *  预览众筹引导
 *
 *
 */
+ (void)guidePreview:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:KUserInfoPreviewGuide];
}

+ (BOOL)getGuidePreview
{
    return [self integerFromUserDefaultsKey:KUserInfoPreviewGuide];
}
/**
 *  切换音视频引导
 *
 *
 */
+ (void)guideChangeVoice:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoChangeVoiceGuide];
}

+ (BOOL)getGuideChangeVoice
{
    return [self integerFromUserDefaultsKey:kUserInfoChangeVoiceGuide];
}
/**
 *  跳过引导
 *
 *
 */
+ (void)guideSkip:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoSkipGuide];
}

+ (BOOL)getGuideSkip
{
    return [self integerFromUserDefaultsKey:kUserInfoSkipGuide];
}

/**
 *  发起直播
 *
 *
 */
+ (void)guideStartLive:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoStartLiveGuide];
}

+ (BOOL)getGuideStartLive
{
    return [self integerFromUserDefaultsKey:kUserInfoStartLiveGuide];
}


#pragma mark - Common Method

+ (id)objectFromUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveToUserDefaultsObject:(id)object forKey:(NSString *)key {
    if (object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSInteger)integerFromUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)saveToUserDefaultsInteger:(NSInteger)intValue forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:intValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveToKeyChainObject:(id)object forKey:(NSString *)key {
    
    if (object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectFromKeyChainKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
