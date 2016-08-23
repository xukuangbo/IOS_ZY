//
//  VersionTool.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionModel.h"

@interface VersionTool : NSObject

+ (void)version;

/**
 *  判断是否强制升级，可选择升级等等
 */
+ (void)versionWithDic:(NSDictionary *)dic;

/**
 *  刚进app的时候将版本号置为0
 */
+ (NSNumber *)judgeIfHaveVersion;

/**
 *  退出app的时候移除
 */
+ (void)removeHaveVersion;
@end
