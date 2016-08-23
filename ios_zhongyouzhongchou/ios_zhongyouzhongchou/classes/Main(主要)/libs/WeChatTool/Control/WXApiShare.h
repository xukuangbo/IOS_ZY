//
//  WXApiShare.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"
@interface WXApiShare : NSObject

/**
 *  app下载地址分享
 *  @param zoneScene   分享到朋友圈or分享到好友
 */
+(void)shareScene:(BOOL )zoneScene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(NSString *)thumbImage andWebUrl:(NSString *)webUrl;
@end
