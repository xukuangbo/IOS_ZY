 //
//  MVMoreDownView.m
//  qupai
//
//  Created by HZ_qp on 15/11/4.
//  Copyright © 2015年 duanqu. All rights reserved.
//

#import "QPMVMoreDownView.h"
#import "QPMusicMoreDownProgressView.h"



static NSArray *ObservabKeys = nil;
static NSString *const categotyProgress             = @"_effectMV.downProgress";
static NSString *const categotyStatusType           = @"_effectMV.downStatus";

@interface QPMVMoreDownView ()
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) QPMusicMoreDownProgressView * loadProgressView;

@end

@implementation QPMVMoreDownView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.downButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.downButton.layer.masksToBounds = YES;
    [self addSubview:self.downButton];
    self.loadProgressView = [[QPMusicMoreDownProgressView alloc] init];
    [self addSubview:self.loadProgressView];
    self.layer.masksToBounds = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.downButton.frame = self.bounds;
    self.loadProgressView.frame = self.bounds;
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
}

- (void)setEffectMV:(QPEffectMV *)effectMV{
    if (ObservabKeys == nil) {
        ObservabKeys = @[categotyProgress, categotyStatusType];
    }
    if (_effectMV) {
        [self removeObserver];
    }
    _effectMV = effectMV;
    [self addObserver];
    [self freshDownType];
}

- (void)freshDownType{
    
    UIColor *btnColor = [UIColor clearColor];
    NSString *title = @"";
    NSString *imageName = @"";
//    NSString *imageHname = @"";
    CGFloat fontSize = 18;
    if (_effectMV.downStatus == QPEffectItemDownStatusFinish) {
        btnColor = RGB(255, 109, 0);
        title =@"使用";
    }else{
        if (_effectMV.downStatus == QPEffectItemDownStatusDowning) {
            _loadProgressView.progress = _effectMV.downProgress;
            title = @"";
        }else if (_effectMV.downStatus == QPEffectItemDownStatusFailed) {
            title = @"继续\n下载";
            fontSize = 14.0;
        }else if (_effectMV.downStatus == QPEffectItemDownStatusNone) {
            imageName = @"more_ico_download";
        }
    }
    self.backgroundColor = btnColor;
    [_downButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_downButton setTitle:title forState:UIControlStateNormal];
    _downButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _downButton.titleLabel.numberOfLines = 0;
    
    _loadProgressView.hidden = !(_effectMV.downStatus == QPEffectItemDownStatusDowning);
}

- (void)downButtonClick:(id)sender{
    if(_effectMV.downStatus == QPEffectItemDownStatusFinish){
        [_delegate mvMoreDownViewUse:_effectMV];
    }else{
//        if (_effectMV.mvVersion <= 1) {
//            [[PasterManager share] downeffectMV:_effectMV type:effectMVDownTypeMore shopType:ShopTypeMV];
            [_delegate mvMoreDownViewDown:_effectMV];
//        }else{
//            [_delegate mvMoreMvDownlUpVersion:_effectMV];
//        }
    }
}

#pragma mark - KVO

- (void)addObserver
{
    for (NSString *keyPath in ObservabKeys) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)removeObserver
{
    for (NSString *keyPath in ObservabKeys) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![ObservabKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath ofObject:self change:change context:context];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self freshDownType];
    });
}

- (void)dealloc{
    if (_effectMV) {
        [self removeObserver];
    }
}
@end
