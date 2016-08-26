//
//  QPEffectViewController.m
//  QupaiSDK
//
//  Created by yly on 15/6/17.
//  Copyright (c) 2015年 lyle. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "QupaiSDK.h"
#import "QupaiSDK-Private.h"
#import "QPEffectViewController.h"
#import "QPEffectViewCell.h"
#import "QPEffectLoadMoreCell.h"
#import "QPEffectManager.h"
#import "QPEffectTabView.h"
#import "QPEventManager.h"
#import <QPSDKCore/QPAuth-Private.h>

#import "QPEffectView.h"
#import <CoreMotion/CoreMotion.h>
extern BOOL QPAuthSuccess;
extern BOOL QPAuthRequestSended;

typedef enum {
    QPEffectTabFilter,
    QPEffectTabMusic,
} QPEffectTab;

NSString *QPMoreMusicUpdateNotification = @"kQPMoreMusicUpdateNotification";

@interface QPEffectViewController()<QPEffectViewDelegate,QPMediaRenderDelegate>

@property (nonatomic, assign) QPEffectTab     selectTab;
@property (nonatomic, strong) QPEffectView    *qpEffectView;
@property (nonatomic, strong) CMMotionManager * motionManager;

@end

@implementation QPEffectViewController{
    QPEffectManager *_effectManager;
    
    QPMediaRender *_mediaRender;//渲染的封装
    
    BOOL _shouldPlay;
    BOOL _shouldSave;
    BOOL _cancelMovie;
    
    BOOL _viewIsShow;
    BOOL _viewIsBackground;
    BOOL _usedBaseLine;
    
    BOOL _isSaving;
    
    BOOL _isCheckAuth;
    
    BOOL _GPUImageMovieWriterAppendBufferFailed;
    NSTimeInterval _startEncodingTime;
    NSInteger _deviceAngle;
}

- (void)loadView {
    
    self.qpEffectView = [[QPEffectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.qpEffectView.delegate = self;
    self.view = _qpEffectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    [self addObserver];
    
    if ([QPSDKConfig isBigBig]) {
        self.qpEffectView.constraintViewCenterTop.constant = 26;
        self.qpEffectView.constraintViewBottomTop.constant = 26;
    }
    
    //TODO:  remove from xib,modify xib  file
    if (!self.qpEffectView.gpuImageView) {
        CGRect renderFrame = CGRectZero;
        CGSize videoSize = self.video.size;
        CGFloat ratio = videoSize.height/videoSize.width;
        if (ratio > 1) {
            renderFrame = CGRectMake(0, 0, ScreenWidth/ratio,  ScreenWidth);
        }else {
            renderFrame = CGRectMake(0, 0, ScreenWidth,  ScreenWidth * ratio);
        }
        UIView *renderView = [QPMediaRender createRenderViewWithFame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.qpEffectView.viewCenter addSubview:renderView];
        
        self.qpEffectView.gpuImageView = renderView;
    }
    
    _effectManager = [[QPEffectManager alloc] init];
    self.qpEffectView.collectionView.delegate = (id)self;
    self.qpEffectView.collectionView.dataSource = (id)self;
    [self.qpEffectView.collectionView registerNib:[UINib nibWithNibName:@"QPEffectViewCell" bundle:[QPBundle mainBundle]] forCellWithReuseIdentifier:@"QPEffectViewCell"];
    [self.qpEffectView.collectionView registerNib:[UINib nibWithNibName:@"QPEffectLoadMoreCell" bundle:[QPBundle mainBundle]] forCellWithReuseIdentifier:@"QPEffectLoadMoreCell"];
    
    [self.qpEffectView.sliderMix setMinimumTrackImage:[QPImage imageNamed:@"record_level"] forState:UIControlStateNormal];
    [self.qpEffectView.sliderMix setMaximumTrackImage:[QPImage imageNamed:@"edit_levelbase"] forState:UIControlStateNormal];
    self.qpEffectView.sliderMix.value = 1 - self.video.mixVolume;
    [self.qpEffectView.sliderMix setThumbImage:[QPImage imageNamed:@"record_handle"] forState:UIControlStateNormal];
    [self.qpEffectView.sliderMix setThumbImage:[QPImage imageNamed:@"record_handle"] forState:UIControlStateHighlighted];
    
    [self.qpEffectView.labelMixLeft setTextColor:[QupaiSDK shared].tintColor];
    
    if ([self.video.lastEffectName isEqual:@"music"]) {
        self.selectTab = QPEffectTabMusic;
    }else{
        self.selectTab = QPEffectTypeFilter;
    }
    
    [self checkAuth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _viewIsShow = YES;
    [self.view layoutIfNeeded];
    _shouldPlay = YES;
    [self destroyMovie];
    
    // 关闭手势滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startMotion];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _viewIsShow = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self endMotion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkAuth {
    _isCheckAuth = YES;
    if (!QPAuthRequestSended) {    // 没有调用鉴权接口
        [QPProgressHUD showNotice:@"鉴权失败" duration:1.5];
        _isCheckAuth = NO;
    }else if (![QPAuth shared].accessToken){  // 鉴权失败（包括超时等情况）
        NSDictionary *dict = [QPAuth shared].errorInfo;
        if (dict || !QPAuthSuccess) {                             // 服务端返回了失败信息
            NSInteger code = [[dict valueForKey:@"code"] integerValue];
            NSString *title = [dict valueForKey:@"message"];
            if (!title) {
                title = @"鉴权失败";
            }
            if (code > 2000) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alertView show];
            }else {
                NSLog(@"%@", title);
            }
        }
        _isCheckAuth = YES;
    }
}

#pragma mark - Notiction
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GPUImageMovieWriterAppendBufferFailed:)
                                                 name:@"GPUImageMovieWriterAppendBufferFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreMusicUpdateNotification:) name:QPMoreMusicUpdateNotification object:nil];
}

#pragma mark - Motion

- (void)startMotion {
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.5;
    }
    if (_motionManager.accelerometerActive) {
        return;
    }
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
         float xx = -acceleration.x;
         float yy = acceleration.y;
         float angle = atan2(yy, xx);
         float z = acceleration.z;
         
         if (z <= -0.8 || z >= 0.8) {
             return;
         }
         NSString *ori = @"";
        NSInteger oldAngle = _deviceAngle;
        if(angle >= -2 && angle <= -1){
             ori = @"Up";
             _deviceAngle = 0;
            
         }else if(angle >= -0.5 && angle <= 0.5){
             ori = @"Right";
             _deviceAngle = 90;
         }else if(angle >= 1 && angle <= 2){
             ori = @"Down";
             _deviceAngle = 180;
         }else if(angle <= -2.5 || angle >= 2.5){
             ori = @"Left";
             _deviceAngle = 270;
         }
         
         if (oldAngle != _deviceAngle) {
             self.qpEffectView.deviceAngle=_deviceAngle;
        }
    }];
}

- (void)endMotion {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}


- (void)GPUImageMovieWriterAppendBufferFailed:(NSNotification *)notification
{
    _GPUImageMovieWriterAppendBufferFailed = YES;
    [_mediaRender cancel];
}

- (void)_applicationWillEnterForeground:(NSNotification *)notification
{
    _viewIsBackground = NO;
    if (self.qpEffectView.activityIndicator.isAnimating) {
        [self.qpEffectView.activityIndicator stopAnimating];
        self.qpEffectView.buttonFinish.hidden = NO;
        self.qpEffectView.buttonClose.enabled = YES;
        self.qpEffectView.viewBottom.userInteractionEnabled = YES;
    }
    if (!_mediaRender) {
        _shouldPlay = YES;
        [self destroyMovie];
    }
    
    if (_isSaving) {
        _isSaving = NO;
        _cancelMovie = NO;
        _mediaRender = nil;
        _shouldPlay = YES;
        [self destroyMovie];
    }
    
}

- (void)_applicationDidEnterBackground:(NSNotification *)notification
{
    _viewIsBackground = YES;
    [self destroyMovie];
    sleep(1.0);
    NSLog(@"EffectViewController background");
}

- (void)moreMusicUpdateNotification:(NSNotification *)notification
{
    [_effectManager needUpdateMusicData];
    [self onClickButtonMusicAction:nil];
}
#pragma mark - KVO

- (NSArray *)allObserverKey
{
    return @[@"selectTab",@"_video.mixVolume"];
}
- (void)addObserver
{
    for (NSString *key in [self allObserverKey]) {
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectTab"]) {
        if (_selectTab == QPEffectTabFilter) {
            [self.qpEffectView.buttonFilter setTitleColor:[QupaiSDK shared].tintColor forState:UIControlStateNormal];
            [self.qpEffectView.buttonMusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.qpEffectView.viewTab.fromX = 5;
            self.qpEffectView.viewTab.toX = 60;
            self.qpEffectView.viewMix.hidden = YES;
        }else{
            self.qpEffectView.buttonFilter.selected = NO;
            
            [self.qpEffectView.buttonFilter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.qpEffectView.buttonMusic setTitleColor:[QupaiSDK shared].tintColor forState:UIControlStateNormal];
            
            //CGSize size =[QPString sizeWithFontSize:_buttonMusic.titleLabel.font.pointSize text:_buttonMusic.titleLabel.text];
            self.qpEffectView.viewTab.fromX = ScreenWidth -  CGRectGetWidth(self.qpEffectView.buttonMusic.frame);
            self.qpEffectView.viewTab.toX = ScreenWidth;
            self.qpEffectView.viewMix.hidden = NO;
        }
        [self.qpEffectView.collectionView reloadData];
        
        NSInteger i = 0;
        if (_selectTab == QPEffectTabFilter) {
            i = [_effectManager effectIndexByID:self.video.filterID type:QPEffectTypeFilter];
        }else{
            i = [_effectManager effectIndexByID:self.video.musicID type:QPEffectTypeMusic];
        }
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        [self.qpEffectView.collectionView selectItemAtIndexPath:ip animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }else if ([keyPath isEqual:@"_video.mixVolume"]){
        self.qpEffectView.sliderMix.value = 1.0 - self.video.mixVolume;
    }
}

- (void)removeObserver
{
    for (NSString *key in [self allObserverKey]) {
        @try {
            [self removeObserver:self forKeyPath:key];
        } @catch (NSException *exception) {
        }
    }
}


#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_selectTab == QPEffectTabFilter) {
        return [_effectManager effectCountByType:QPEffectTypeFilter];
    }
    return [_effectManager effectCountByType:QPEffectTypeMusic];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QPEffect *effect = nil;
    if (_selectTab == QPEffectTabFilter) {
        effect = [_effectManager effectAtIndex:indexPath.row type:QPEffectTypeFilter];
    }else{
        effect = [_effectManager effectAtIndex:indexPath.row type:QPEffectTypeMusic];
    }
    
    QPEffectViewCell *cell = (QPEffectViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"QPEffectViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text = effect.name;
    cell.nameLabel.textColor=[UIColor whiteColor];
    cell.iconImageView.image = [QPImage imageNamed:effect.icon];
    cell.contentView.frame = cell.bounds;
    if (self.video.filterID == effect.eid) {
        cell.selected = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QPEffect *effect = nil;
    if (_selectTab == QPEffectTabFilter) {
        effect = [_effectManager effectAtIndex:indexPath.row type:QPEffectTypeFilter];
        self.video.filterID = effect.eid;
    }else{
        QPEffectMusic *lastMusic = (QPEffectMusic *)[_effectManager effectByID:self.video.musicID type:QPEffectTypeMusic];
        effect = [_effectManager effectAtIndex:indexPath.row type:QPEffectTypeMusic];
        if (![effect isMore]) {
            self.video.musicID = effect.eid;
        }
        if ([effect isEmpty]) {
            self.video.mixVolume = 1.0;
        }else if([lastMusic isEmpty]){
            self.video.mixVolume = 0.5;
        }
    }
    if ([effect isMore]) {
        if ([QupaiSDK.shared.delegte respondsToSelector:@selector(qupaiSDKShowMoreMusicView:viewController:)]) {
            _viewIsShow = NO;
            [self destroyMovie];
            [QupaiSDK.shared.delegte qupaiSDKShowMoreMusicView:QupaiSDK.shared viewController:self];
        }
    }else{
        _shouldPlay = YES;
        [self destroyMovie];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QPEffect *effect = nil;
    if (_selectTab == QPEffectTabFilter) {
        effect = [_effectManager effectAtIndex:indexPath.row type:QPEffectTypeFilter];
    }else{
        effect = [_effectManager effectAtIndex:indexPath.row type:QPEffectTypeMusic];
    }
    if ([QPSDKConfig is35]) {
        if ([effect isMore]) {
            return CGSizeMake(ICON_WIDTH*2/7*5, ICON_WIDTH*2);
        }
        return CGSizeMake(ICON_WIDTH*2, ICON_WIDTH*2);
    }
    //    if ([effect isMore]) {
    //        return CGSizeMake(50, 95);
    //    }
    return CGSizeMake(ICON_WIDTH*2, kCollectionViewHeight);
}
#pragma mark - Play

- (void)playMovieAndAudio
{
    _shouldPlay = NO;
    
    if (!_viewIsShow) {
        return;
    }
    //    [self updateShouldMusic];
    [self updateMusicTabName];
    
    [self playDirectorAtTime:0.0];
}

- (void)playDirectorAtTime:(CGFloat)atTime
{
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
    
    QPEffectFilter *effect = (QPEffectFilter *)[_effectManager effectByID:self.video.filterID type:QPEffectTypeFilter];
    QPEffectMusic *effectMusic = (QPEffectMusic *)[_effectManager effectByID:self.video.musicID type:QPEffectTypeMusic];
    
    QPMediaPack *pack = [[QPMediaPack alloc] init];
//    pack.rotateArray = [self.video AllPointsRotate]; 
    pack.videoPathArray = [self.video fullPathsForFilePathArray];
    pack.musicPath = effectMusic.musicName;
    pack.mixVolume = self.video.mixVolume;
    pack.videoSize = self.video.size;
    
    if (effect.mvPath) {
        pack.effectPath = [[[QPBundle mainBundle] bundlePath] stringByAppendingPathComponent:effect.mvPath];
    }
    
    _mediaRender = [[QPMediaRender alloc] initWithMediaPack:pack];
    _mediaRender.delegate = self;
    
    [_mediaRender startRenderToView:self.qpEffectView.gpuImageView];
    
}

-(void)saveMovieToFile
{
    _shouldSave = NO;
    
    if (_mediaRender) {
        return;
    }
    NSString *pathFile = [self.video newUniquePathWithExt:@"mp4"];
    CGSize size = self.video.size;
    
    NSString *profileLevel = AVVideoProfileLevelH264Baseline30;
    if (_GPUImageMovieWriterAppendBufferFailed) {
        _GPUImageMovieWriterAppendBufferFailed = NO;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            profileLevel = AVVideoProfileLevelH264BaselineAutoLevel;
        }
    }else{
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            profileLevel = AVVideoProfileLevelH264BaselineAutoLevel;
        }else{
            profileLevel = AVVideoProfileLevelH264Baseline30;
        }
    }
    
    QPEffectFilter *effect = (QPEffectFilter *)[_effectManager effectByID:self.video.filterID type:QPEffectTypeFilter];
    QPEffectMusic *effectMusic = (QPEffectMusic *)[_effectManager effectByID:self.video.musicID type:QPEffectTypeMusic];
    
    QPMediaPack *pack = [[QPMediaPack alloc] init];
//    pack.rotateArray = [self.video AllPointsRotate];
    pack.videoPathArray = [self.video fullPathsForFilePathArray];
    pack.musicPath = effectMusic.musicName;
    pack.mixVolume = self.video.mixVolume;
    pack.videoSize = self.video.size;
    pack.saveWatermarkImage = [[QupaiSDK shared] watermarkImage];
    if (effect.mvPath) {
        pack.effectPath = [[[QPBundle mainBundle] bundlePath] stringByAppendingPathComponent:effect.mvPath];
    }
    //save
    pack.savePath = pathFile;
    pack.saveProfileLevel = profileLevel;
    pack.saveSize = size;
    pack.saveBitRate = self.video.bitRate;
    
    _mediaRender = [[QPMediaRender alloc] initWithMediaPack:pack];
    _mediaRender.delegate = self;
    [_mediaRender startExport];
    _isSaving = YES;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

#pragma mark - Direcot System
- (void)destroyMovie
{
    if (_cancelMovie) {
        return;
    }
    if (_mediaRender) {
        _cancelMovie = YES;
        
        [_mediaRender cancel];
        
    }else if(_shouldSave){
        
        [self saveMovieToFile];
        
    }else if (_shouldPlay) {
        [self playMovieAndAudio];
    }
}

- (void)effectVideoCompleteBlockCallback:(NSURL *)url
{
    if (self.qpEffectView.activityIndicator.isAnimating) {
        [self.qpEffectView.activityIndicator stopAnimating];
        self.qpEffectView.buttonFinish.hidden = NO;
        self.qpEffectView.buttonClose.enabled = YES;
        self.qpEffectView.viewBottom.userInteractionEnabled = YES;
    }
    // 销毁writer
    //    [self destroyWriter];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    NSURL *thumbnailURL = [QPVideo movieFirstFrame:url toPath:[self.video newUniquePathWithExt:@"jpg"]
                                           quality:QupaiSDK.shared.thumbnailCompressionQuality];
    
    [[QupaiSDK shared] compelete:url.path thumbnailPath:thumbnailURL.path];
}
#pragma mark - Delegate


- (void)currentVideoCompositionWithPlan:(CGFloat)plan {
    
    if (plan >= 1.0) {
        plan = 1.0;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.qpEffectView.activityIndicator isAnimating]) {
            
            NSLog(@"%@", [NSString stringWithFormat:@"%3.f%%", plan * 100]);
        }
    });
}

//- (void)directorCancel:(QUDirector *)movie
- (void)mediaRenderCancel:(QPMediaRender *)render;
{
    if (![render isPlayMode]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_viewIsBackground) {// 如果进入后台，取消保存操作
                [self destroyMovie];
            }else{
                [_mediaRender finishRecordingWithCompletionHandler:^(NSURL *url){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_GPUImageMovieWriterAppendBufferFailed) {
                            _shouldSave = YES;
                            [self destroyMovie];
                        }else{
                            [self processVideoLength:url];
                        }
                    });
                }];
            }
        });
        return;
    }
    
    BOOL showPlay = [render isPlayMode];
    if (_viewIsBackground || !_viewIsShow) {
        showPlay = NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_mediaRender) {
            _mediaRender = nil;
        }
        _shouldPlay = showPlay;
        _cancelMovie = NO;
        
        [self destroyMovie];
    });
}

- (void)directorPlayTime:(CGFloat)time format:(NSString *)format
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        _labelVideoTime.hidden = NO;
    //       _labelVideoTime.text = format;
    //    });
}

- (void)processVideoLength:(NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetTrack *videoTrack;
    AVAssetTrack *audioTrack;
    
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    if (videoTrack && audioTrack) {
        float videoDuration = CMTimeGetSeconds(videoTrack.timeRange.duration);
        float audioDuration = CMTimeGetSeconds(audioTrack.timeRange.duration);
        if (audioDuration - videoDuration > 0.5 && !_usedBaseLine) {
            _GPUImageMovieWriterAppendBufferFailed = YES;
            _usedBaseLine = YES;
            _shouldSave = YES;
            [self destroyMovie];
            
            return;///返回
        }
    }
    if (url) {
        NSTimeInterval finishEncodingTime = [[NSDate date] timeIntervalSince1970];
        CGFloat encodingDuration = finishEncodingTime - _startEncodingTime;
        [[QPEventManager shared] event:QPEventEncodeFinish
                            withParams:@{@"duration":[NSNumber numberWithInt:encodingDuration * 1000],
                                         @"filter":self.video.filterID ? @(1) : @(0),
                                         @"music":self.video.musicID ? @(1) : @(0)}];
        [self effectVideoCompleteBlockCallback:url];
    }
}
#pragma mark - UI

- (void)updateMusicTabName
{
    QPEffectMusic *effectMusic = (QPEffectMusic *)[_effectManager effectByID:self.video.musicID type:QPEffectTypeMusic];
    if ([effectMusic isEmptyMusic]) {
        [self.qpEffectView.buttonMusic setTitle:@"音乐" forState:UIControlStateNormal];
        //        [_buttonMusic setTitleColor:[QupaiSDK shared].tintColor forState:UIControlStateNormal];
        [self.qpEffectView.buttonMusic setImage:[QPImage imageNamed:@"edit_ico_music.png"] forState:UIControlStateNormal];
        [self.qpEffectView.buttonMusic setImage:[QPImage imageNamed:@"edit_ico_music.png"] forState:UIControlStateHighlighted];
    }else{
        [self.qpEffectView.buttonMusic setTitle:effectMusic.name forState:UIControlStateNormal];
        //        [_buttonMusic setTitleColor:[QupaiSDK shared].tintColor forState:UIControlStateNormal];
        [self.qpEffectView.buttonMusic setImage:[QPImage imageNamed:@"edit_ico_music_1.png"] forState:UIControlStateNormal];
        [self.qpEffectView.buttonMusic setImage:[QPImage imageNamed:@"edit_ico_music_1.png"] forState:UIControlStateHighlighted];
    }
    
    //    CGSize size =[QPString sizeWithFontSize:_buttonMusic.titleLabel.font.pointSize text:_buttonMusic.titleLabel.text];
    //    _viewTab.fromX = CGRectGetMinX(_buttonMusic.frame);
    //    _viewTab.toX = CGRectGetMinX(_buttonMusic.frame) + CGRectGetMaxX(_buttonMusic.titleLabel.frame) + size.width;
    self.qpEffectView.buttonMusic.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    self.qpEffectView.buttonMusic.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

#pragma mark - Action

- (void)onClickButtonCloseAction:(UIButton *)sender {
    _viewIsShow = NO;
    [self destroyMovie];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickButtonFinishAction:(UIButton *)sender {
    
    if (!_isCheckAuth) {
        // 鉴权失败
        [QPProgressHUD showNotice:@"鉴权失败" duration:1.5];
        return;
    }
    
    
    [self.qpEffectView.activityIndicator startAnimating];
    self.qpEffectView.buttonFinish.hidden = YES;
    self.qpEffectView.buttonClose.enabled = NO;
    self.qpEffectView.viewBottom.userInteractionEnabled = NO;
    
    _shouldSave = YES;
    [self destroyMovie];
    [[QPEventManager shared] event:QPEventEditNext];
    _startEncodingTime = [[NSDate date] timeIntervalSince1970];
}

- (void)onCLickButtonPlayOrPauseAction:(UIButton *)sender {
    [_mediaRender playOrPause];
    if (!_mediaRender) {
        _shouldPlay = YES;
        [self destroyMovie];
    }
}

- (void)onClickButtonFilterAction:(UIButton *)sender {
    self.video.lastEffectName = @"filter";
    self.selectTab = QPEffectTabFilter;
}

- (void)onClickButtonMusicAction:(UIButton *)sender {
    self.video.lastEffectName = @"music";
    self.selectTab = QPEffectTabMusic;
}

- (void)onClickSliderAction:(UISlider *)sender {
    self.video.mixVolume = 1.0 - self.qpEffectView.sliderMix.value;
    _shouldPlay = YES;
    [self destroyMovie];
}

@end
