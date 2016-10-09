//
//  ZYVoicePlayer.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYVoicePlayer.h"

static ZYVoicePlayer *_zyVPlayer;

@implementation ZYVoicePlayer

+(instancetype )defaultAVPlayerWithPlayerItem:(AVPlayerItem *)playerItem
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (!_zyVPlayer) {
            _zyVPlayer=[[ZYVoicePlayer alloc]initWithPlayerItem:playerItem];
        }
    });
    
    if (_zyVPlayer) {
        [_zyVPlayer pause];
        [_zyVPlayer replaceCurrentItemWithPlayerItem:playerItem];
    }
    
    return _zyVPlayer;
}

-(instancetype)initWithPlayerItem:(AVPlayerItem *)item
{
    if (self=[super initWithPlayerItem:item]) {
       
    }
    return self;
}



@end
