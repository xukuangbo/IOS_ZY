//
//  QPReaderToWriter.h
//  QupaiSDK
//
//  Created by yly on 15/7/1.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QPReaderToWriter : NSObject

@property (nonatomic, assign) BOOL shouldOptimizeForNetworkUse;

/**
 *  视频转码
 *
 *  @param asset              视频
 *  @param toURL              输出URL的地址
 *  @param completionHandler  错误信息
 */
- (void)combineFromAsset:(AVAsset *)asset toURL:(NSURL *)toURL withCompletionHandler:(void (^)(NSError *error))completionHandler;
/**
 *  视频转码
 *
 *  @param asset              视频
 *  @param toURL              输出URL的地址
 *  @param bitRate            比特率
 *  @param completionHandler  错误信息
 */
- (void)combineFromAsset:(AVAsset *)asset toURL:(NSURL *)toURL withBitRate:(CGFloat)bitRate completionHandler:(void (^)(NSError *error))completionHandler;

/**
 *  视频转码
 *
 *  @param asset              视频
 *  @param toURL              输出URL的地址
 *  @param bitRate            比特率
 *  @param size               分辨率
 *  @param completionHandler  错误信息
 */
- (void)combineFromAsset:(AVAsset *)asset toURL:(NSURL *)toURL withBitRate:(CGFloat)bitRate size:(CGSize)size completionHandler:(void (^)(NSError *error))completionHandler;

@end
