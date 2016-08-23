//
//  ZYVoicePlayer.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface ZYVoicePlayer : AVPlayer

+(instancetype)defaultAVPlayerWithPlayerItem:(AVPlayerItem *)playerItem;
@property (nonatomic, assign) BOOL  getStart;
@end
