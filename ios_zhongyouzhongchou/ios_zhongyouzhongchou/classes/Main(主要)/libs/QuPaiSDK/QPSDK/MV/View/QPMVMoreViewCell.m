//
//  MVMoreViewCell.m
//  qupai
//
//  Created by yly on 15/2/9.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import "QPMVMoreViewCell.h"
//#import "PasterManager.h"
#import "UIImageView+WebCache.h"

static NSArray *ObservabKeys = nil;
static NSString *const ShopItemProgressKeyPath = @"_effectMV.downProgress";
static NSString *const ShopItemPlayProgressKeyPath = @"_effectMV.playProgress";
static NSString *const ShopItemStatusKeyPath = @"_effectMV.downStatus";

@implementation QPMVMoreViewCell{
    BOOL _isPreview;//um是否预览标志
}

- (void)awakeFromNib {
    if (ObservabKeys == nil) {
        ObservabKeys = @[ShopItemProgressKeyPath, ShopItemPlayProgressKeyPath,ShopItemStatusKeyPath];
    }
    _nameLabel.font = [UIFont systemFontOfSize:22];
    _descriptionTextView.font = [UIFont systemFontOfSize:12];
    _descriptionTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _useButton.layer.masksToBounds = YES;
    _useButton.layer.cornerRadius = 17.5;
    [_useButton setBackgroundColor:RGB(35, 182, 183)];
}

- (void)updateFrame {
    if (_isPreview) {
        CGRect frame = self.bounds;
        _actionConstraintVerticalSpace.constant = CGRectGetHeight(frame) - CGRectGetWidth(frame);
    }else{
        _actionConstraintVerticalSpace.constant = 0;
    }
}

- (IBAction)playButtonClick:(id)sender {
    [_delegate mvMoreViewCellPlay:self];
}

- (IBAction)downButtonClick:(id)sender {
    [_delegate mvMoreViewCellDown:self];
}

- (IBAction)useButtonClick:(id)sender {
    [_delegate mvMoreViewCellUse:self];
}

- (void)setEffectMV:(QPEffectMV *)effectMV {
    _isPreview = NO;
    if(_effectMV){
        [self removeObserver];
    }
    _effectMV = effectMV;
    [_imageViewIcon sd_setImageWithURL:[NSURL URLWithString:_effectMV.previewPic]];
    _nameLabel.text = _effectMV.name;
    _descriptionTextView.text = _effectMV.description;

    [self updateStatus];
    [self addObserver];
}

- (void)updateStatus {
    switch (_effectMV.downStatus) {
        case  QPEffectItemDownStatusDowning:
            _downButton.hidden = YES;
            _downProgressView.hidden = _isPreview;
            _useButton.hidden = YES;
            break;
        case QPEffectItemDownStatusFinish:
            _downButton.hidden = YES;
            _downProgressView.hidden = YES;
            _useButton.hidden = _isPreview;
            break;
        case  QPEffectItemDownStatusFailed:
        case QPEffectItemDownStatusNone:
            _downButton.hidden = _isPreview;
            _downProgressView.hidden = YES;
            _useButton.hidden = YES;
            break;
        default:
            break;
    }
    _downProgressView.progress = _effectMV.downProgress;
    NSLog(@"_effectMV.progress %f", _effectMV.downProgress);
}

- (void)showDetailView {
    _isPreview = YES;
    _nameLabel.hidden = YES;
    _descriptionTextView.hidden = YES;
    _playButton.hidden = YES;
    _imageViewIcon.hidden = YES;
    _downButton.hidden = YES;
    _useButton.hidden = YES;
    [self playButtonClick:nil];
}

- (void)closeDetailView {
    _isPreview = NO;
    _nameLabel.hidden = NO;
    _descriptionTextView.hidden = NO;
    _playButton.hidden = NO;
    _imageViewIcon.hidden = NO;
    _downButton.hidden = NO;
    _useButton.hidden = !(_effectMV.downStatus == QPEffectItemDownStatusFinish);
    [_delegate mvMoreViewCellStop:self];
    [self updateFrame];
}

#pragma mark - KVO

- (void)addObserver {
    for (NSString *keyPath in ObservabKeys) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserver {
    for (NSString *keyPath in ObservabKeys) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![ObservabKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath ofObject:self change:change context:context];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatus];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_effectMV) {
        [self removeObserver];
    }
}

@end
