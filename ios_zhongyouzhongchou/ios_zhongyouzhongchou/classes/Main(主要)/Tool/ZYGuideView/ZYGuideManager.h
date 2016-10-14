//
//  FZGuideManager.h
//  Pods
//
//  Created by patty on 15/12/17.
//
//

#import <Foundation/Foundation.h>

@interface ZYGuideManager : NSObject

+ (void)guideStartZhongchou:(BOOL)show;
+ (BOOL)getGuideStartZhongchou;

+ (void)guidePreview:(BOOL)show;
+ (BOOL)getGuidePreview;

+ (BOOL)getGuideChangeVoice;
+ (void)guideChangeVoice:(BOOL)show;

+ (BOOL)getGuideSkip;
+ (void)guideSkip:(BOOL)show;

+ (BOOL)getGuideStartLive;
+ (void)guideStartLive:(BOOL)show;
@end
