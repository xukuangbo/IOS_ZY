//
//  QPDeviceManager.h
//  ALBBQuPai
//
//  Created by zhangwx on 16/2/29.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QPDeviceManager : NSObject
+ (NSString *)deviceName;
+ (NSString *)deviceIPAddress;
+ (NSString *)deviceCarrier;
+ (NSString *)deviceNetwrok;
+ (NSString *)deviceSyetemVersion;
@end
