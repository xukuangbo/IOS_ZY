//
//  JudgeAuthorityTool.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JudgeAuthorityTool : NSObject
/**
 *  判断相册是否被禁用
 *
 */
+ (BOOL)judgeAlbumAuthority;

/**
 *  判断相机是否被禁用
 *
 */
+ (BOOL)judgeMediaAuthority;

/**
 *  判断是否可以录音
 *
 */
+ (BOOL)judgeRecordAuthority;

/**
 *  判断定位是否被禁用
 *
 */
+ (BOOL)judgeLocationAuthority;


@end
