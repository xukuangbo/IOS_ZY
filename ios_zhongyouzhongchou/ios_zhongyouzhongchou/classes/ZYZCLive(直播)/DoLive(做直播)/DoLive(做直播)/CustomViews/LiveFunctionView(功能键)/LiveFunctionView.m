
//
//  LiveFunctionView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "LiveFunctionView.h"
#import  <QPSDKCore/QPSDKCore.h>
#import <Masonry.h>
#import "LiveFunctionViewButton.h"
@interface LiveFunctionView ()
/**
 *  相机翻转
 */
@property (nonatomic, strong) LiveFunctionViewButton *cameraDirectionBtn;
/**
 *  美颜
 */
@property (nonatomic, strong) LiveFunctionViewButton *skimBtn;
/**
 *  闪光灯
 */
@property (nonatomic, strong) LiveFunctionViewButton *flashBtn;


/*!
 *  摄像头方向
 */
@property (nonatomic, assign) AVCaptureDevicePosition currentPosition;

@end

@implementation LiveFunctionView
- (instancetype)initWithSession:(QPLiveSession *)liveSession
{
    self = [super init];
    if (self) {
        self.liveSession = liveSession;
        [self configUI];
        
    }
    return self;
}


- (void)configUI
{
    UIImageView *bgImageView = [UIImageView new];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = KPULLIMG(@"Popup-background", 14, 0, 14, 0);
    
    //翻转功能
    _cameraDirectionBtn = [LiveFunctionViewButton new];
    [self addSubview:_cameraDirectionBtn];
    
    _skimBtn = [[LiveFunctionViewButton alloc] init];
    [self addSubview:_skimBtn];
    
    
    _flashBtn = [LiveFunctionViewButton new];
    [self addSubview:_flashBtn];
    
    [_cameraDirectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        
        make.top.mas_equalTo(self.mas_top);
        make.height.equalTo(_flashBtn);
    }];
    
    [_skimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(_cameraDirectionBtn.mas_bottom);
        make.height.equalTo(_flashBtn);
    }];
    
    [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(_skimBtn.mas_bottom);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(_cameraDirectionBtn);
    }];
    
    //给每个btn添加一个图片,一个label
    [self addForSuperView:_cameraDirectionBtn Image:@"live-turn" labelText:@"翻转"];
    [self addForSuperView:_skimBtn Image:@"live-beauty-face-on" labelText:@"美颜"];
    [self addForSuperView:_flashBtn Image:@"live-flash-on" labelText:@"闪光"];
    
    //给每个btn添加点击事件
    [_cameraDirectionBtn addTarget:self action:@selector(cameraDirectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_skimBtn addTarget:self action:@selector(skimBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_flashBtn addTarget:self action:@selector(flashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addForSuperView:(LiveFunctionViewButton *)button Image:(NSString *)imageString labelText:(NSString *)textString
{
    UIImageView *imageView = [UIImageView new];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.bottom.equalTo(button);
        make.width.equalTo(imageView.mas_height);
    }];
    imageView.image = [UIImage imageNamed:imageString];
    button.iconView = imageView;
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.bottom.equalTo(button);
        make.left.equalTo(imageView.mas_right);
    }];
    label.text = textString;
    button.textLabel = label;
}
#pragma mark - 点击动作
#pragma mark ---翻转
- (void)cameraDirectionBtnAction:(LiveFunctionViewButton *)button
{
    //点击了翻转
    button.selected = !button.selected;
    
    _liveSession.devicePosition = button.isSelected ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _currentPosition = _liveSession.devicePosition;
    
    if (button.selected == YES) {//后置
        _flashBtn.selected = NO;
    }
}
#pragma mark ---美颜
- (void)skimBtnAction:(LiveFunctionViewButton *)button
{
    button.selected = !button.selected;
    if (button.selected == YES) {
        button.iconView.image = [UIImage imageNamed:@"live-beauty-face-off"];
    }else{
        button.iconView.image = [UIImage imageNamed:@"live-beauty-face-on"];
    }
    [_liveSession setEnableSkin:button.isSelected];
    
}
#pragma mark ---闪光
- (void)flashBtnAction:(LiveFunctionViewButton *)button
{
    //如果前置的话,点击没有效果
    if (_currentPosition != AVCaptureDevicePositionBack) {
        return ;
    }
    
    //后置的话
    button.selected = !button.selected;
    if (button.selected == YES) {
        button.iconView.image = [UIImage imageNamed:@"live-flash-off"];
    }else{
        button.iconView.image = [UIImage imageNamed:@"live-flash-on"];
    }
    
    _liveSession.torchMode = button.isSelected ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    
}

@end
