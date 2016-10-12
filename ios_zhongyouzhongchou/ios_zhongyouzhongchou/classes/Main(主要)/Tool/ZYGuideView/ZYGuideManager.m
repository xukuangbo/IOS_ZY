//
//  FZGuideManager.m
//  Pods
//
//  Created by patty on 15/12/17.
//
//

#import "ZYGuideManager.h"

//学生端显示微课程引导
static NSString *const kUserInfoStudentShowFlashLessonGuide = @"kUserInfoStudentShowFlashLessonGuide";
static NSString *const KUserInfoStudentMicroCourseGuide = @"KUserInfoStudentMicroCourseGuide";
static NSString *const kUserInfoTeacherGoOnlineGuide = @"kUserInfoTeacherGoOnlineGuide";
static NSString *const kUserInfoTeacherGoOfflineGuide = @"kUserInfoTeacherGoOfflineGuide";
static NSString *const kUserInfoTeacherShowMicroCourseGuide = @"kUserInfoTeacherShowMicroCourseGuide";
static NSString *const kUserInfoTeacherShowLessonGuide = @"kUserInfoTeacherShowLessonGuide";
static NSString *const kUserInfoTeacherShowOpenFlashGuide = @"kUserInfoTeacherShowOpenFlashGuide";
static NSString *const kUserInfoTeacherShowForgien = @"kUserInfoTeacherShowForgien";
static NSString *const kUserInfoTeacherShowState = @"kUserInfoTeacherShowState";
static NSString *const kUserInfoMyPurese = @"kUserInfoMyPurese";
static NSString *const kUserInfoMyVideoTalk = @"kUserInfoMyVideoTalk";
static NSString *const kUserInfoMyWordChat = @"kUserInfoMyWordChat";
static NSString *const kUserInfoMyMicroCourseChooseTeacher = @"KUserInfoStudentMicroCourseChooseTeacher";
static NSString *const kUserInfoMyRecord = @"kUserInfoMyRecord";

static NSString *currentAppUserID = nil;



@implementation ZYGuideManager

//// 设置当前App用户ID (切换账号使用)
//+ (void)setCurrentAppUserID:(NSString *)userID {
//    if ([userID isKindOfClass:[NSNumber class]]) {
//        userID = [NSString stringWithFormat:@"%zd", [userID integerValue]];
//    }
//    currentAppUserID = userID;
//    [self checkCache];
//}
//
//
//// 更新数据模型
//+ (void)checkCache {
//    if (!currentAppUserID || currentAppUserID.length == 0) {
//        return;
//    }
//  //获得当前用户，是否引导页出现的信息
//    
//  NSDictionary *dict;
//  [self guideTeacherGoOffline:[dict objectForKey:kUserInfoTeacherGoOfflineGuide]];
//  [self guideTeacherGoOnline:[dict objectForKey:kUserInfoTeacherGoOnlineGuide]];
//}
//
//+ (NSArray *)guideInfoArray
//{
//     NSMutableArray *array = [NSMutableArray array];
//    
//     return array.count > 0 ? array : nil;
//}

/**
 *  学生端微课引导
 *
 *
 */
+ (void)guideStudentMicroCourse:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:KUserInfoStudentMicroCourseGuide];
}

+ (BOOL)getGuideStudentMicroCourse
{
    return [self integerFromUserDefaultsKey:KUserInfoStudentMicroCourseGuide];
}

/**
 *  学生端微课选择外教
 *
 *
 */
+ (void)guideStudentMicroCourseChooseTeacher:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoMyMicroCourseChooseTeacher];
}

+ (BOOL)getGuideStudentMicroCourseChooseTeacher
{
    return [self integerFromUserDefaultsKey:kUserInfoMyMicroCourseChooseTeacher];
}


/**
 *  学生端显示微课程引导
 *
 *
 */
+ (void)guideStudentFlashLesson:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoStudentShowFlashLessonGuide];
}

+ (BOOL)getGuideStudentFlashLesson
{
    return [self integerFromUserDefaultsKey:kUserInfoStudentShowFlashLessonGuide];
}


+ (void)guideStudentTeacherState:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherShowState];
}

+ (BOOL)getGuideTeacherState
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherShowState];
}

/**
 *  学生端显示外教引导
 *
 *
 */
+ (void)guideStudentForeign:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherShowForgien];
}

+ (BOOL)getGuideStudentForeign
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherShowForgien];
}

/**
 *  学生端显示我的钱包
 *
 *
 */
+ (void)guideStudentMyPurse:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoMyPurese];
}

+ (BOOL)getGuideStudentMyPurse
{
    return [self integerFromUserDefaultsKey:kUserInfoMyPurese];
}

/**
 *  学生端显示与外教视频聊天
 *
 *
 */
+ (void)guideStudentMyVideoTalk:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoMyVideoTalk];
}

+ (BOOL)getGuideStudentMyVideoTalk
{
    return [self integerFromUserDefaultsKey:kUserInfoMyVideoTalk];
}

/**
 *  学生端显示与外教文字聊天
 *
 *
 */
+ (void)guideStudentMyWordChat:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoMyWordChat];
}

+ (BOOL)getGuideStudentMyWordChat
{
    return [self integerFromUserDefaultsKey:kUserInfoMyWordChat];
}

/**
 *  学生端显示上传录音
 *
 *
 */
+ (void)guideStudentMyRecord:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoMyRecord];
}

+ (BOOL)getGuideStudentMyRecord
{
    return [self integerFromUserDefaultsKey:kUserInfoMyRecord];
}




/**
 *  老师上下线引导
 *
 *  @param show
 */
+ (void)guideTeacherGoOnline:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherGoOnlineGuide];
    
    //保存数据到本地
}

+ (BOOL)getGuideTeacherGoOnline
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherGoOnlineGuide];
}

+ (void)guideTeacherGoOffline:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherGoOfflineGuide];
    
    //保存数据到本地
}

+ (BOOL)getGuideTeacherGoOffline
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherGoOfflineGuide];
}

/**
 *  老师显示微课页面引导
 *
 *  @return bool YES:显示过
 */
+ (BOOL)getGuideMicroCourseShow
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherShowMicroCourseGuide];
}

+ (void)guideTeacherShowMicroCourse:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherShowMicroCourseGuide];
}

/**
 *  老师显示课程页引导
 *
 *  @return bool YES:显示过
 */
+ (BOOL)getGuideLessonShow
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherShowLessonGuide];
}

+ (void)guideTeacherShowLesson:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherShowLessonGuide];
}

/**
 *  老师显示打开微课引导
 *
 *  @return bool YES:显示过
 */
+ (BOOL)getGuideOpenFlashShow
{
    return [self integerFromUserDefaultsKey:kUserInfoTeacherShowOpenFlashGuide];
}

+ (void)guideTeacherShowOpenFlash:(BOOL)show
{
    [self saveToUserDefaultsInteger:show forKey:kUserInfoTeacherShowOpenFlashGuide];
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
