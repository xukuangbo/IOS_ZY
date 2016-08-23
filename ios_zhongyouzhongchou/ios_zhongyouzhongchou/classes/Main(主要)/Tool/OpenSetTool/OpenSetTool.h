//
//  OpenSetTool.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenSetTool : NSObject

/**
 *  是否弹出过设置的alert窗口
 */
+ (void)judgeOpenSet;

/**
 *  打开系统定位设置服务
 */
+ (void)openSet_LOCATION_SERVICES;
@end
