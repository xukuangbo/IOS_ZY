//
//  QPPlayerManager.m
//  DevQPSDKCore
//
//  Created by Worthy on 16/8/31.
//  Copyright © 2016年 LYZ. All rights reserved.
//

#import "QPPlayerManager.h"


@interface QPPlayerManager ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *avPlayer;
@end

@implementation QPPlayerManager


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    self.avPlayer = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
}

#pragma mark - instance method

- (void)playVideoWithUrl:(NSURL *)url atView:(UIView *)view {
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer.frame = view.bounds;
    [view.layer addSublayer:self.playerLayer];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.avPlayer play];
}

- (void)stop {
    [self.avPlayer pause];
    [self.playerLayer removeFromSuperlayer];
}

#pragma mark - Notification

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (_avPlayer == nil || notification.object != _avPlayer.currentItem) {
        return;
    }
    __weak AVPlayer *wa = _avPlayer;
    [_avPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            [wa play];
        }
    }];
}

@end
