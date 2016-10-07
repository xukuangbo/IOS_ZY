//
//  QPPlayerManager.h
//  DevQPSDKCore
//
//  Created by Worthy on 16/8/31.
//  Copyright © 2016年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPPlayerManager : NSObject
- (void)playVideoWithUrl:(NSURL *)url atView:(UIView *)view;
- (void)stop;
@end
