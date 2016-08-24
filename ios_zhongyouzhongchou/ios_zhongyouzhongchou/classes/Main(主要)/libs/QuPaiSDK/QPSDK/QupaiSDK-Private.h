//
//  QupaiSDK-Private.h
//  QupaiSDK
//
//  Created by yly on 15/6/29.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

@class QPVideo;

@interface QupaiSDK()

@property (nonatomic, assign) CGFloat  maxDuration;     /* 允许拍摄的最大时长 */
@property (nonatomic, assign) CGFloat  minDurtaion;     /* 允许拍摄的最小时长 */
@property (nonatomic, assign) CGFloat  bitRate;         /* 视频码率， bits per second */
@property (nonatomic, weak) QPVideo    *recordVideo;

//@property (nonatomic, copy) NSString *appKey;
//@property (nonatomic, copy) NSString *appSecret;
//@property (nonatomic, copy) NSString *space;
//
//@property (nonatomic, copy) NSString *accessToken;
//@property (nonatomic, assign) NSInteger expire;
//@property (nonatomic, strong) NSDictionary *errorInfo;
//@property (nonatomic, assign) BOOL  registerSended;     // 鉴权接口调用

- (void)compelete:(NSString *)path thumbnailPath:(NSString *)thumbnailPath;

- (NSString *)appName;

@end
