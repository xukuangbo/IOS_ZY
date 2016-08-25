//
//  QPEffectView.m
//  QPSDK
//
//  Created by LYZ on 16/4/27.
//  Copyright © 2016年 danqoo. All rights reserved.
//

#import "QPEffectView.h"
#import "QPImage.h"
#import "QPEffectTabView.h"

#define VIEW_ALPHA    0.5

#define kViewTopHeight 44

#define kButtonViewTopWeight 54

#define kActivityIndicatorWeight 37

#define kViewCenterNextTipHeight 34

#define kViewBottomViewtapHeight 30

#define kViewCenterViewMixHeight 32

#define kCBottomViewHeight    120

@interface QPEffectView()

@property (nonatomic, strong) UILabel *topLab;

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *containView;

@property (nonatomic, strong) UIView *topBgView;

@property (nonatomic, assign) BOOL   isHidden;

@end

@implementation QPEffectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupCenterSubViews];
    
    [self setupTopSubViews];
    
    [self setupBottomSubViews];
    
    [self setupViewMixSubViews];
    
}

#pragma mark UI

// top
- (void)setupTopSubViews {
    
    self.topBgView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, ScreenWidth, kViewTopHeight))];
    self.topBgView.backgroundColor = [UIColor blackColor];
    self.topBgView.alpha=VIEW_ALPHA;
    [self addSubview:self.topBgView];
    
    self.viewTop = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, ScreenWidth, kViewTopHeight))];
    self.viewTop.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewTop];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.viewTop.bounds];
    label.text = @"编辑视频";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17.f];
    [self.viewTop addSubview:label];
    self.topLab=label;
    
    self.buttonClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.buttonClose setImage:[QPImage imageNamed:@"record_ico_back.png"] forState:(UIControlStateNormal)];
    self.buttonClose.frame = CGRectMake(0, 0, kButtonViewTopWeight, kViewTopHeight - 4);
    [self.buttonClose addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewTop addSubview:self.buttonClose];
    
    self.buttonFinish = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.buttonFinish.frame = CGRectMake(CGRectGetWidth(self.viewTop.frame) - kButtonViewTopWeight, 0, kButtonViewTopWeight, kViewTopHeight - 4);
    [self.buttonFinish setImage:[QPImage imageNamed:@"record_ico_next.png"] forState:(UIControlStateNormal)];
    [self.buttonFinish addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewTop addSubview:self.buttonFinish];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    self.activityIndicator.frame = CGRectMake(CGRectGetWidth(self.viewTop.frame) - 9 - kActivityIndicatorWeight, 0, kActivityIndicatorWeight, kViewTopHeight - 7);
    self.activityIndicator.color=[UIColor whiteColor];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.viewTop addSubview:self.activityIndicator];
    self.activityIndicator.hidden = YES;
    
}


// centerView
- (void)setupCenterSubViews {
    
    self.viewCenter = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, ScreenWidth, ScreenHeight))];
    self.viewCenter.backgroundColor = [UIColor blackColor];
    [self addSubview:self.viewCenter];
    
    self.viewVideoContainer = [[UIView alloc] initWithFrame: self.viewCenter.bounds];
    self.viewVideoContainer.backgroundColor = [UIColor clearColor];
    [self.viewCenter addSubview:self.viewVideoContainer];
    
    self.viewNextTip = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(self.viewCenter.frame), kViewCenterNextTipHeight))];
    [self.viewCenter addSubview:self.viewNextTip];
    UILabel *nextTipLabel = [[UILabel alloc] initWithFrame: self.viewNextTip.bounds];
    nextTipLabel.text = @"视频已保存";
    nextTipLabel.textColor = [UIColor whiteColor];
    nextTipLabel.font = [UIFont systemFontOfSize:17.f];
    nextTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.viewNextTip addSubview:nextTipLabel];
    
    self.viewNextTip.hidden = YES;
    
    self.buttonPlayOrPause = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.buttonPlayOrPause.backgroundColor = [UIColor clearColor];
    self.buttonPlayOrPause.frame = self.viewCenter.bounds;
    [self.buttonPlayOrPause addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewCenter addSubview:self.buttonPlayOrPause];
    
    self.labelVideoTime = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetWidth(self.viewCenter.frame) - 16 - 54, 20, 54, 21))];
    self.labelVideoTime.textAlignment = NSTextAlignmentLeft;
    self.labelVideoTime.text = @"00:00";
    self.labelVideoTime.textColor = [UIColor redColor];
    self.labelVideoTime.font = [UIFont systemFontOfSize:17.f];
    [self.viewCenter addSubview:self.labelVideoTime];
    
    self.labelVideoTime.hidden = YES;
    
}

-(void)setLeftBottomViews
{
    
}


// bottomView
- (void)setupBottomSubViews {
    
    
    self.containView =[[UIView alloc]initWithFrame:(CGRectMake(0, ScreenHeight-kCBottomViewHeight, ScreenWidth, kCBottomViewHeight))];
    self.containView.backgroundColor=[UIColor blackColor];
    self.containView.alpha=VIEW_ALPHA;
    [self addSubview:self.containView];
    
    self.viewBottom = [[UIView alloc] initWithFrame:(CGRectMake(0, ScreenHeight-kCBottomViewHeight, ScreenWidth, kCBottomViewHeight))];
    self.viewBottom.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewBottom];
    
    
    self.viewEffect = [[UIView alloc] initWithFrame:self.viewBottom.bounds];
    [self.viewBottom addSubview:self.viewEffect];
    
    [self setupBottomTabViews];

}

- (void)setupBottomTabViews {
    
    self.viewTab = [[QPEffectTabView alloc] initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(self.viewEffect.frame), kViewBottomViewtapHeight))];
    self.viewTab.backgroundColor = [UIColor clearColor];
//    self.viewTab.alpha=VIEW_ALPHA;
    [self.viewEffect addSubview:self.viewTab];
    
    self.buttonFilter = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.buttonFilter.frame = CGRectMake(0, 0, 80, kViewBottomViewtapHeight);
    [self.buttonFilter setTitle:@"滤镜" forState:(UIControlStateNormal)];
    self.buttonFilter.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.buttonFilter setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.buttonFilter addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewEffect addSubview:self.buttonFilter];
    
    self.buttonMusic = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.buttonMusic.frame = CGRectMake(CGRectGetWidth(self.viewTab.frame) - 8 - 100, 0, 100, kViewBottomViewtapHeight);
    [self.buttonMusic setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.buttonMusic.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.buttonMusic setTitle:@"音乐" forState:(UIControlStateNormal)];
    self.buttonMusic.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 0, 0);
    
    [self.buttonMusic setImage:[QPImage imageNamed:@"edit_ico_music.png"] forState:(UIControlStateNormal)];
    self.buttonMusic.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.buttonMusic addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
     [self.viewEffect addSubview:self.buttonMusic];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    UIView *BgView = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.viewTab.frame), ScreenWidth, CGRectGetHeight(self.viewEffect.frame) - CGRectGetMaxY(self.viewTab.frame)))];
//    BgView.backgroundColor = RGB(212, 212, 212);
    [self.viewEffect addSubview:BgView];
    self.BgView=BgView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 86);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);

    self.collectionView = [[UICollectionView alloc]  initWithFrame:(CGRectMake(0, (CGRectGetHeight(BgView.frame) - kCollectionViewHeight) / 2, ScreenWidth, kCollectionViewHeight)) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [BgView addSubview:self.collectionView];
}


// viewMix
- (void)setupViewMixSubViews {
    
    self.viewMix = [[UIView alloc] initWithFrame:(CGRectMake(3, ScreenHeight-kCBottomViewHeight-5-kViewCenterViewMixHeight, CGRectGetWidth(self.viewCenter.frame) - 6, kViewCenterViewMixHeight))];
    [self addSubview:self.viewMix];
    
    UIImageView *viewMixImage = [[UIImageView alloc] initWithFrame:self.viewMix.bounds];
    viewMixImage.image = [QPImage imageNamed:@"record_levelbase_bg.png"];
    [self.viewMix addSubview:viewMixImage];
    
    self.labelMixLeft = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 45, CGRectGetHeight(self.viewMix.frame)))];
    self.labelMixLeft.text = @"音乐";
    self.labelMixLeft.textColor = RGB(2, 204, 269);
    self.labelMixLeft.font = [UIFont systemFontOfSize:11.f];
    self.labelMixLeft.textAlignment = NSTextAlignmentCenter;
    [self.viewMix addSubview:self.labelMixLeft];
    
    self.labelMixRight = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetWidth(self.viewMix.frame) - 45, 0, 45, CGRectGetHeight(self.viewMix.frame)))];
    self.labelMixRight.text = @"原音";
    self.labelMixRight.textColor = RGB(255, 204, 2);
    self.labelMixRight.font = [UIFont systemFontOfSize:11.f];
    self.labelMixRight.textAlignment = NSTextAlignmentCenter;
    [self.viewMix addSubview:self.labelMixRight];
    
    self.sliderMix = [[UISlider alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(self.labelMixLeft.frame), 0, CGRectGetMinX(self.labelMixRight.frame) - CGRectGetMaxX(self.labelMixLeft.frame), 100))];
    self.sliderMix.center = CGPointMake(self.sliderMix.center.x, CGRectGetHeight(self.viewMix.frame) / 2);
    [self.sliderMix addTarget:self action:@selector(sliderClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.sliderMix.value = 0.5;
    self.sliderMix.minimumTrackTintColor = RGB(2, 204, 269);
    self.sliderMix.maximumTrackTintColor = RGB(255, 204, 2);
    [self.viewMix addSubview:self.sliderMix];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.gpuImageView.center = CGPointMake(CGRectGetWidth(self.viewCenter.bounds)/2, (CGRectGetHeight(self.viewCenter.bounds)/2));
}

#pragma mark Action

- (void)buttonAction:(UIButton *)sender {
    
    if ([sender isEqual:self.buttonClose] && _delegate && [_delegate respondsToSelector:@selector(onClickButtonCloseAction:)]) {
        [_delegate onClickButtonCloseAction:sender];
    }
    
    if ([sender isEqual:self.buttonFinish] && _delegate && [_delegate respondsToSelector:@selector(onClickButtonFinishAction:)]) {
        [_delegate onClickButtonFinishAction:sender];
    }
    
    if ([sender isEqual:self.buttonPlayOrPause] && _delegate && [_delegate respondsToSelector:@selector(onCLickButtonPlayOrPauseAction:)]) {
        [_delegate onCLickButtonPlayOrPauseAction:sender];
    }
    
    
    if ([sender isEqual:self.buttonFilter] && _delegate && [_delegate respondsToSelector:@selector(onClickButtonFilterAction:)]) {
        [_delegate onClickButtonFilterAction:sender];
    }
    
    if ([sender isEqual:self.buttonMusic] && _delegate && [_delegate respondsToSelector:@selector(onClickButtonMusicAction:)]) {
        [_delegate onClickButtonMusicAction:sender];
    }
    
}

- (void)sliderClickAction:(UISlider *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickSliderAction:)]) {
        [_delegate onClickSliderAction:sender];
    }
}

-(void)setDeviceAngle:(NSInteger)deviceAngle
{
    
    _deviceAngle=deviceAngle;
    
    NSLog(@"deviceAngle:%ld",deviceAngle);
    
     CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/180.0 * _deviceAngle);
//
    if (deviceAngle==0) {
       // Up
        self.viewBottom.transform  = transform;
        self.containView.transform = transform;
        self.viewMix.transform     = transform;
        self.viewTop.transform     = transform;
        self.topBgView.transform   = transform;

        self.viewBottom.transform=CGAffineTransformTranslate(self.viewBottom.transform, ScreenHeight/2-ScreenWidth/2, -(ScreenHeight/2-ScreenWidth/2));
        
        self.containView.transform=CGAffineTransformTranslate(self.containView.transform, ScreenHeight/2-ScreenWidth/2, -(ScreenHeight/2-ScreenWidth/2));
        
         self.viewTop.transform=CGAffineTransformTranslate(self.viewTop.transform, ScreenHeight/2-ScreenWidth/2, -(ScreenHeight/2-ScreenWidth/2));
        
        self.topBgView.transform=CGAffineTransformTranslate(self.topBgView.transform, ScreenHeight/2-ScreenWidth/2, -(ScreenHeight/2-ScreenWidth/2));

        self.viewBottom.height=kCBottomViewHeight;
        
        self.collectionView.width=ScreenWidth;
        
        self.BgView.width=ScreenWidth;
        
        self.viewEffect.width=ScreenWidth;
        
        self.viewTab.width=ScreenWidth;
        
        self.buttonMusic.left=CGRectGetWidth(self.viewTab.frame) - 8 - 100;
        
        self.containView.height=kCBottomViewHeight;
        
        self.viewTop.height=kViewTopHeight;
        
        self.topLab.width=ScreenWidth;
        
        self.buttonFinish.left=ScreenWidth - kButtonViewTopWeight;

        
    }
    else if(deviceAngle == 90)
    {
    //Right

        self.viewBottom.transform = transform;
        self.containView.transform= transform;
        self.viewMix.transform    = transform;
        self.viewTop.transform    = transform;
        self.topBgView.transform  = transform;

        self.viewBottom.transform=CGAffineTransformTranslate(self.viewBottom.transform, -(ScreenHeight-ScreenWidth/2-kCBottomViewHeight/2),( ScreenWidth-kCBottomViewHeight)/2);
        
        self.containView.transform=CGAffineTransformTranslate(self.containView.transform, -(ScreenHeight-ScreenWidth/2-kCBottomViewHeight/2),( ScreenWidth-kCBottomViewHeight)/2);
        
        self.viewMix.transform=CGAffineTransformTranslate(self.viewMix.transform, -((ScreenHeight-ScreenWidth)/2+(ScreenWidth/2-kCBottomViewHeight)/2),ScreenWidth/2-(kCBottomViewHeight+10)-kViewCenterViewMixHeight/2);
        
        self.viewTop.transform=CGAffineTransformTranslate(self.viewTop.transform,(ScreenWidth-kViewTopHeight)/2,-(ScreenWidth-kViewTopHeight)/2);
        
        self.topBgView.transform=CGAffineTransformTranslate(self.topBgView.transform,(ScreenWidth-kViewTopHeight)/2,-(ScreenWidth-kViewTopHeight)/2);
        
        self.viewBottom.height=ScreenHeight;
        
        self.collectionView.width=ScreenHeight;
        
        self.BgView.width=ScreenHeight;
        
        self.viewEffect.width=ScreenHeight;
        
        self.viewTab.width=ScreenHeight;
        
        self.buttonMusic.left=CGRectGetWidth(self.viewTab.frame) - 8 - 100;
        
        self.containView.height=ScreenHeight;
        
        self.viewTop.height=ScreenHeight;

        self.topLab.width=ScreenHeight;
        
        self.buttonFinish.left=ScreenHeight - kButtonViewTopWeight;
        
        self.topBgView.height=ScreenHeight;
    }
    else if (deviceAngle== 180 )
    {
        //Down

    }
    else if (deviceAngle== 270 )
    {
        //Left

        
    }
}

@end
