//
//  MinePersonSetUpHeadView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "ZYCustomIconView.h"
@class MinePersonSetUpModel;
#define imageHeadHeight (KSCREEN_W / 16.0 * 10)
@interface MinePersonSetUpHeadView : UIImageView
@property (nonatomic, strong) ZYCustomIconView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIImageView *infoView;
@property (nonatomic, strong) UIImageView *weixinView;
@property (nonatomic, strong) UIView *blurColorView;

@property (nonatomic, strong) UIImage *iconImg;
- (void)addFXBlurView;

@property (nonatomic, strong) MinePersonSetUpModel *minePersonSetUpModel;
@end
