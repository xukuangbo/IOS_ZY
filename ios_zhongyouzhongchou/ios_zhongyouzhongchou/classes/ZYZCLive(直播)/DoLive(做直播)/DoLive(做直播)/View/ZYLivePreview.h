//
//  ZYLivePreview.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYLivePreview : UIView

/** 直播房间地址  rtmp://192.168.0.104:1935/rtmplive/room */
@property (nonatomic, copy) NSString *LiveUrl;

- (instancetype)initWithLiveURL:(NSString *)LiveUrl;
@end
