//
//  ZYZCAVPlayer.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ZYZCAVPlayer()
@end
@implementation ZYZCAVPlayer

static AVPlayerViewController *_avPlayerViewController;
+ (void)initialize
{
    if (self == [ZYZCAVPlayer class]) {
        if (_avPlayerViewController == nil) {
            _avPlayerViewController = [[AVPlayerViewController alloc] init];
        }
    }
}


+ (void)playInView:(UIView *)view url:(NSURL *)url
{
    _avPlayerViewController = nil;
    _avPlayerViewController = [[AVPlayerViewController alloc] init];
    _avPlayerViewController.view.frame = view.frame;
    AVPlayer *player=[AVPlayer playerWithURL:url];
    _avPlayerViewController.player = player;
    [view addSubview:_avPlayerViewController.view];
    [player play];
}

+ (void)playInNewController:(UINavigationController *)navi url:(NSURL *)url
{
    _avPlayerViewController = nil;
    _avPlayerViewController = [[AVPlayerViewController alloc] init];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    _avPlayerViewController.player = player;
    [player play];
    [navi pushViewController:_avPlayerViewController animated:YES];
}
@end
