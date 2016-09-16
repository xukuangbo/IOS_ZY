//
//  ZYLocationManager.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/15.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  获取当前位置的回调
 *
 *  @param isSuccess      获取成功
 *  @param currentCity    当前的城市名
 *  @param currentAddress 当前的地址
 */
typedef void (^GetCurrentLocationResult)(BOOL isSuccess,NSString *currentCity,NSString *currentAddress);

@interface ZYLocationManager : NSObject

- (void)getCurrentLacation;

@property (nonatomic, copy  ) GetCurrentLocationResult getCurrentLocationResult;

@end
