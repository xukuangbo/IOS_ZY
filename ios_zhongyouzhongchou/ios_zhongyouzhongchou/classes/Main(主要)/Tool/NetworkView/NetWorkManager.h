//
//  NetWorkManager.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetFailView.h"

@interface NetWorkManager : NSObject

/**
 *  加载网络请求失败的视图
 *
 *  @param view         父视图
 *  @param reFrashBlock 点击重新刷新的操作
 */
//+ (void)getFailViewForView:(UIView *)view andReFrashBlock:(ReFrashBlock)reFrashBlock;

+ (void)getFailViewForView:(UIView *)view andFailResult:(id)failResult andReFrashBlock:(ReFrashBlock)reFrashBlock;

/**
 *  移除加载失败的视图
 *
 *  @param view 父视图
 */
+ (void)hideFailViewForView:(UIView *)view;

/**
 *  网络错误，只展示mb提示
 *
 *  @param failResult 网络获取失败的内容
 */
+ (void) showMBWithFailResult:(id)failResult;


+ (void)netFailWithMB;


@end
