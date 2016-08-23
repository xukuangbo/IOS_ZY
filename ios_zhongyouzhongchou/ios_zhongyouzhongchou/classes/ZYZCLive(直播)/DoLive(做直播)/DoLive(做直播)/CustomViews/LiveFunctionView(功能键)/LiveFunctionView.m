
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



@end

@implementation LiveFunctionView
- (instancetype)initWithSession:(QPLiveSession *)liveSession
{
    self = [super init];
    if (self) {
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
    bgImageView.image = KPULLIMG(@"Popup-background", 14, 0, 14, 0);
    
    //翻转功能
    _cameraDirectionBtn = [UIButton new];
    [self addSubview:_cameraDirectionBtn];
    
    _skimBtn = [UIButton new];
    [self addSubview:_skimBtn];
    
    _flashBtn = [UIButton new];
    [self addSubview:_flashBtn];
    
//    [_cameraDirectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.top.mas_equalTo(self.mas_top);
//        make.height.equalTo(_flashBtn);
//    }];
//    
//    [_skimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.top.mas_equalTo(_cameraDirectionBtn.mas_bottom);
//        make.height.equalTo(_flashBtn);
//    }];
    
//    [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.top.mas_equalTo(_skimBtn.mas_bottom);
//        make.height.equalTo(_cameraDirectionBtn);
//    }];
}

@end
