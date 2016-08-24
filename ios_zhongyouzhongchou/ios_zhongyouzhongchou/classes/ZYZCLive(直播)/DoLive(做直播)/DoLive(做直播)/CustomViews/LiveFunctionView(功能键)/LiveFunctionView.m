
//
//  LiveFunctionView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "LiveFunctionView.h"
#import <QPLive/QPLive.h>
#import <Masonry.h>
@interface LiveFunctionView ()
/**
 *  相机翻转
 */
@property (nonatomic, strong) UIButton *cameraDirectionBtn;
/**
 *  美颜
 */
@property (nonatomic, strong) UIButton *skimBtn;
/**
 *  闪光灯
 */
@property (nonatomic, strong) UIButton *flashBtn;


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

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self configUI];
//    }
//    return self;
//}
//- (instancetype)initWithSuperFrame:(CGRect)superFrame
//{
//    //计算出在self.view中的frame
//    CGRect frame = CGRectZero;
//    frame.size = CGSizeMake(150, 300);
//    frame.origin.x = (superFrame.origin.x + superFrame.size.width * 0.5) - frame.size.width * 0.5;
//    frame.origin.y = superFrame.origin.y - superFrame.size.height;
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self configUI];
//    }
//    return  self;
//}

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
    _cameraDirectionBtn = [UIButton new];
    [self addSubview:_cameraDirectionBtn];
    
    _skimBtn = [UIButton new];
    [self addSubview:_skimBtn];
    
    
    _flashBtn = [UIButton new];
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

- (void)addForSuperView:(UIButton *)button Image:(NSString *)imageString labelText:(NSString *)textString
{
    UIImageView *imageView = [UIImageView new];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.bottom.equalTo(button);
        make.width.equalTo(imageView.mas_height);
    }];
    imageView.image = [UIImage imageNamed:imageString];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.bottom.equalTo(button);
        make.left.equalTo(imageView.mas_right);
    }];
    label.text = textString;
}
#pragma mark - 点击动作
#pragma mark ---翻转
- (void)cameraDirectionBtnAction:(UIButton *)button
{
    //点击了翻转
    button.selected = !button.isSelected;
    _liveSession.devicePosition = button.isSelected ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _currentPosition = _liveSession.devicePosition;
    
    if (button.selected == YES) {//后置
        _flashBtn.selected = NO;
    }
}
#pragma mark ---美颜
- (void)skimBtnAction:(UIButton *)button
{
    button.selected = !button.isSelected;
    [_liveSession setEnableSkin:button.isSelected];
    
}
#pragma mark ---闪光
- (void)flashBtnAction:(UIButton *)button
{
    //如果前置的话,点击没有效果
    if (_currentPosition != AVCaptureDevicePositionBack) {
        return ;
    }
    
    //后置的话
    button.selected = !button.isSelected;
    _liveSession.torchMode = button.isSelected ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    
}

@end
