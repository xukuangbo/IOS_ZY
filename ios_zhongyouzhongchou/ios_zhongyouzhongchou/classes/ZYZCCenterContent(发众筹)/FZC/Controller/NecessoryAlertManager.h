//
//  NecessoryAlertManager.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NecessoryAlertManager : NSObject
/**
 *  如果必要数据未填写，展示提示界面
 *  返回值目前暂时用1，2，3，4代替
 *  返回值：1.目的地未填完整
 *         2.筹旅费未填完整
 *         3.行程未填完整
 *         4.回报未填完整
 */
+ (NSInteger)showNecessoryAlertViewForView:(UIView *)view;
+ (NSInteger)showNecessoryAlertView01ForView:(UIView *)view;
+ (NSInteger)showNecessoryAlertView02ForView:(UIView *)view;
+ (NSInteger)showNecessoryAlertView03ForView:(UIView *)view;
+ (NSInteger)showNecessoryAlertView04ForView:(UIView *)view;

@end
