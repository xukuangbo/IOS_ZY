//
//  QPPEngine.h
//  QPPhotoMovie
//
//  Created by yly on 7/12/16.
//  Copyright © 2016 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol QPPEngineDelegate;

@interface QPPEngine : NSObject

- (instancetype)initWithImageNames:(NSArray *)names screenSize:(CGSize)screenSize;

@property (nonatomic, assign) CGFloat actionDuration;//默认3秒
@property (nonatomic, assign) CGFloat transitionDuration;//默认1秒
- (void)play;
- (void)pause;
- (BOOL)isPlaying;

- (void)exportToPath:(NSString *)path videoSize:(CGSize)videoSize bitRate:(NSInteger)bitRate;

- (UIView *)previewView;

@property (nonatomic, assign) id<QPPEngineDelegate> delegate;

@end

@protocol QPPEngineDelegate <NSObject>

- (void)exportComplete;
- (void)exportFailedWithError:(NSError *)error;
- (void)exportProgress:(CGFloat)progress;
- (void)playComplete;

@end