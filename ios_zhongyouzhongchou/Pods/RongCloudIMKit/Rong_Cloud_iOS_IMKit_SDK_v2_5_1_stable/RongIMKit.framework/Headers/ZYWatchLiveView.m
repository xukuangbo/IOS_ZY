//
//  ZYWatchLiveView.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYWatchLiveView.h"

@implementation ZYWatchLiveView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    // 关闭直播
    UIButton *closeLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeLiveButton setBackgroundImage:[UIImage imageNamed:@"live-quit"] forState:UIControlStateNormal];
    [self addSubview:closeLiveButton];
    self.closeLiveButton = closeLiveButton;
    
    
    _feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_feedBackBtn setBackgroundImage:[UIImage imageNamed:@"live-talk"] forState:UIControlStateNormal];
    [self addSubview:_feedBackBtn];
    
    _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flowerBtn setBackgroundImage:[UIImage imageNamed:@"giftFlower"] forState:UIControlStateNormal];
    [self addSubview:_flowerBtn];
    
    _shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"live-share"] forState:UIControlStateNormal];
    [self addSubview:_shareBtn];
    
    
    //    _clapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    //    UIImageView *clapImg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heartIcon"]];
    //    clapImg3.frame = CGRectMake(0,0, 35, 35);
    //    [_clapBtn addSubview:clapImg3];
    //    [_clapBtn addTarget:self
    //                 action:@selector(clapButtonPressed:)
    //       forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_clapBtn];
    
    // //私信按钮端
    _massageBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_massageBtn setImage:[UIImage imageNamed:@"giftIcon"] forState:UIControlStateNormal];
    [self addSubview:_massageBtn];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
