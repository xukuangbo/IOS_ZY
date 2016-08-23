//
//  MinePersonSetUpHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#import "MinePersonSetUpHeadView.h"
#import "FXBlurView.h"
#import "MinePersonSetUpModel.h"
@interface MinePersonSetUpHeadView ()

@end

@implementation MinePersonSetUpHeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image=[UIImage imageNamed:@"icon_placeholder"];
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.clipsToBounds = YES;
        
        self.userInteractionEnabled = YES;
        
        //添加毛玻璃
        [self addFXBlurView];
        
        //头像
        CGFloat iconViewWH = 80 * KCOFFICIEMNT;
        _iconView = [[ZYCustomIconView alloc] init];
        __weak typeof(&*self) weakSelf = self;
        _iconView.finishChoose = ^(UIImage *image){
            
            weakSelf.image = image;
            
            weakSelf.iconImg = image;
            
            [weakSelf addFXBlurView];
        };
        _iconView.size = CGSizeMake(iconViewWH, iconViewWH);
        _iconView.center = self.center;
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor ZYZC_BgGrayColor].CGColor;
        _iconView.image = [UIImage imageNamed:@"icon_placeholder"];
        _iconView.layer.borderWidth = 2;
        [self addSubview:_iconView];
        
        //名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.left = 0;
        _nameLabel.top = _iconView.bottom;
        _nameLabel.size = CGSizeMake(self.width, 20 * KCOFFICIEMNT);
        [self addSubview:_nameLabel];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        //微信view
        _weixinView = [[UIImageView alloc] init];
        _weixinView.size = CGSizeMake(20 * KCOFFICIEMNT, 20 * KCOFFICIEMNT);
        _weixinView.top = _nameLabel.top;
        _weixinView.left = _nameLabel.right;
        _weixinView.image = [UIImage imageNamed:@"wechat_icon"];
        [self addSubview:_weixinView];
    }
    return self;
}


-(void)addFXBlurView
{
    if (_blurView) {
        [_blurView removeFromSuperview];
    }
    //创建毛玻璃
    _blurView = [[FXBlurView alloc] initWithFrame:self.bounds];
    [_blurView setDynamic:NO];
    _blurView.blurRadius=10;
    [self addSubview:_blurView];
    _blurColorView=[[UIView alloc]initWithFrame:_blurView.bounds];
    _blurColorView.backgroundColor=[UIColor ZYZC_MainColor];
    _blurColorView.alpha=0.7;
    [_blurView addSubview:_blurColorView];
    [self insertSubview:_blurView atIndex:0];
    
}

#pragma set方法
- (void)setMinePersonSetUpModel:(MinePersonSetUpModel *)minePersonSetUpModel
{
    _minePersonSetUpModel = minePersonSetUpModel;
    
//    NSArray *textArr=nil;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:minePersonSetUpModel.faceImg]];
    [self sd_setImageWithURL:[NSURL URLWithString:minePersonSetUpModel.faceImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self addFXBlurView];
    }];
    //名字
    UIFont *font=_nameLabel.font;
    NSString *name=minePersonSetUpModel.realName?minePersonSetUpModel.realName:minePersonSetUpModel.userName;
    CGSize nameSize=[ZYZCTool calculateStrLengthByText:name andFont:font andMaxWidth:self.width];
    if (nameSize.width>self.width-40) {
        nameSize.width=self.width-40;
    }
    _nameLabel.size = nameSize;
    _nameLabel.centerX = self.centerX;
    _nameLabel.text=name;
    
    _weixinView.left = _nameLabel.right;
    _weixinView.top = _nameLabel.top;
//    _weixinView.size = CGSizeMake(nameSize.height, nameSize.height);
}
@end
