//
//  ZYZCAVPlayer.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYZCAVPlayer : NSObject

+ (void)playInView:(UIView *)view url:(NSURL *)url;

+ (void)playInNewController:(UINavigationController *)navi url:(NSURL *)url;

@end
