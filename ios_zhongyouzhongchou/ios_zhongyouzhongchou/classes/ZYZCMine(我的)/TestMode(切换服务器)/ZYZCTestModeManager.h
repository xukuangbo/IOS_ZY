//
//  ZYZCTestModeManager.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYZCTestModeManager : NSObject
+ (void)setServerStatus:(NSInteger)serverStatus;
+ (NSInteger)getServerStatus;
@end
