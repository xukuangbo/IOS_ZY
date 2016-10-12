//
//  FZGuideManager.h
//  Pods
//
//  Created by patty on 15/12/17.
//
//

#import <Foundation/Foundation.h>

@interface ZYGuideManager : NSObject

+ (void)guideStudentMicroCourse:(BOOL)show;
+ (BOOL)getGuideStudentMicroCourse;
+ (BOOL)getGuideStudentFlashLesson;
+ (void)guideStudentFlashLesson:(BOOL)show;

+ (BOOL)getGuideStudentForeign;
+ (void)guideStudentForeign:(BOOL)show;

+ (BOOL)getGuideTeacherState;
+ (void)guideStudentTeacherState:(BOOL)show;

+ (void)guideStudentMyPurse:(BOOL)show;
+ (BOOL)getGuideStudentMyPurse;

+ (void)guideStudentMyVideoTalk:(BOOL)show;
+ (BOOL)getGuideStudentMyVideoTalk;

+ (void)guideStudentMyWordChat:(BOOL)show;
+ (BOOL)getGuideStudentMyWordChat;

+ (void)guideStudentMicroCourseChooseTeacher:(BOOL)show;
+ (BOOL)getGuideStudentMicroCourseChooseTeacher;

+ (void)guideStudentMyRecord:(BOOL)show;
+ (BOOL)getGuideStudentMyRecord;

+ (void)guideTeacherGoOnline:(BOOL)show;
+ (BOOL)getGuideTeacherGoOnline;
+ (void)guideTeacherGoOffline:(BOOL)show;
+ (BOOL)getGuideTeacherGoOffline;
+ (void)guideTeacherShowMicroCourse:(BOOL)show;
+ (BOOL)getGuideMicroCourseShow;
+ (void)guideTeacherShowLesson:(BOOL)show;
+ (BOOL)getGuideLessonShow;
+ (void)guideTeacherShowOpenFlash:(BOOL)show;
+ (BOOL)getGuideOpenFlashShow;
@end
