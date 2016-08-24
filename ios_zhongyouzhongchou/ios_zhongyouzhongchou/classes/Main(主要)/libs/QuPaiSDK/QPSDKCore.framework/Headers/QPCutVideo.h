//
//  CutVideo.h
//  duanqu2
//
//  Created by lyle on 1/20/14.
//  Copyright (c) 2014 duanqu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface QPCutVideo : NSObject

@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;

- (void)cutVideoAVAsset:(AVAsset *)asset range:(CMTimeRange)range offset:(CGPoint)offset size:(CGSize)size toURL:(NSURL *)toURL
          completeBlock:(void(^)(NSURL *filePath))block;
- (void)cutVideoAVAsset:(AVAsset *)asset range:(CMTimeRange)range waterMark:(UIImage *)waterMark offset:(CGPoint)offset size:(CGSize)size toURL:(NSURL *)toURL
          completeBlock:(void(^)(NSURL *filePath))block;
@end
