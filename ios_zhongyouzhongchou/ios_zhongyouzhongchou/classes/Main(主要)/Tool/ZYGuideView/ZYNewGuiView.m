//
//  ZYNewGuiView.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYNewGuiView.h"
#import "ZYCGContextView.h"
#import "ZYDetailGuideView.h"
@implementation ZYNewGuiView
{
    ZYDetailGuideView *_guideView;
    ZYCGContextView *_cgContextView;
    CGContextType _contextType;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tapGesture];
        [tapGesture addTarget:self action:@selector(tap:)];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if([self.showDoneDelagate respondsToSelector:@selector(showDone)]){
        [self.showDoneDelagate showDone];
    }
}

- (void)initSubViewWithTeacherGuideType:(detailType)type withContextViewType:(CGContextType)contextType
{
    if (type != liveWindowType) {
        _cgContextView = [[ZYCGContextView alloc] initWithFrame:self.bounds];
        [self addSubview:_cgContextView];
        _guideView = [[ZYDetailGuideView alloc] initWithFrame:CGRectZero];
        [_cgContextView addSubview:_guideView];
    }
    
//    NSDictionary *dic = [self getDetailTitleArray][type];
    
    switch (type) {
        case startHomeType:
        {
            [_guideView createDetailWithAlignmentType:startHomeType];
        }
            break;
        case voiceType:
        {
            [_guideView createDetailWithAlignmentType:voiceType];
            break;
        }
        case skipType:
        {
            [_guideView createDetailWithAlignmentType:skipType];
        }
            break;
        case prevType:
        {
            [_guideView createDetailWithAlignmentType:prevType];
        }
            break;
        case liveWindowType:
        {
//            [_guideView createDetailWithAlignmentType:liveWindowType];
        }
            break;
            
        default:
            break;
    }
    
    
    switch (type) {
        case startHomeType:
        {
            [_cgContextView drawRectInWay:CGRectMake(0, self.frame.size.height-43, self.frame.size.width, 49) withdrawType:contextType];
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"guide_start"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).equalTo(@-5);
                make.width.equalTo(@(326/2));
                make.height.equalTo(@(83/2));
                make.top.equalTo(@3);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.bottom.equalTo(guideCircleImageView.mas_centerY).offset(-10-100);
            }];
        }
            break;
        case voiceType:
        {
            [_cgContextView drawRectInWay:CGRectMake(0, self.rectTypeOriginalY, self.frame.size.width, 40) withdrawType:contextType];
            
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"guide_change"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-5);
                make.width.equalTo(@(516/2));
                make.height.equalTo(@(83/2));
                make.top.equalTo(self.mas_top).offset(328);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.top.equalTo(self.mas_top).offset(0);
            }];
            break;
        }
        case skipType:
        {
            [_cgContextView drawRectInWay:CGRectMake(0, self.frame.size.height-43, self.frame.size.width, 49) withdrawType:contextType];
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"guide_skip"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).equalTo(@-5);
                make.width.equalTo(@(280/2));
                make.height.equalTo(@(83/2));
                make.top.equalTo(@3);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.bottom.equalTo(guideCircleImageView.mas_centerY).offset(-10-100);
            }];
            
            break;
        }
        case prevType:
        {
            [_cgContextView drawRectInWay:CGRectMake(0, self.rectTypeOriginalY, self.frame.size.width,44) withdrawType:contextType];
            
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"guide_preview"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@5);
                make.width.equalTo(@(280/2));
                make.height.equalTo(@(83/2));
                make.bottom.equalTo(@-3);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.top.equalTo(guideCircleImageView.mas_centerY).offset(0);
            }];
            
            break;
        }
        case liveWindowType:
        {
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            guideCircleImageView.image = [UIImage imageNamed:@"background_card"];
            [self addSubview:guideCircleImageView];
            
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 40, 40)];
            headerImageView.layer.masksToBounds = YES;
            headerImageView.layer.cornerRadius = 20;
            headerImageView.image = [UIImage imageNamed:@"icon_mxc_cy"];
            [self addSubview:headerImageView];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, KSCREEN_W - 135, 40)];
            contentLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
            contentLabel.font = [UIFont systemFontOfSize:13.0f];
            [contentLabel setTextAlignment:NSTextAlignmentCenter];
            contentLabel.text = @"众游红包正在直播\n点击进入直播间";
            contentLabel.numberOfLines = 2;
            [self addSubview:contentLabel];
            
            UIImageView *liveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 32, 23, 10)];
            liveImageView.image = [UIImage imageNamed:@"live_icon"];
            [self addSubview:liveImageView];
            
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.frame = CGRectMake(KSCREEN_W - 55, 15, 20, 20);
            [closeButton setImage:[UIImage imageNamed:@"live_message_closed"] forState:UIControlStateNormal];
            [self addSubview:closeButton];
            break;
        }
            
        default:
            break;
    }
}

- (NSMutableArray *)getDetailTitleArray
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    [titles addObject:@{@"title": @"来这里发起众筹"}];
    [titles addObject:@{@"title": @"切换按钮 使用更多方式描述更容易成功"}];
    [titles addObject:@{@"title": @"点击可以先跳过哦"}];
    [titles addObject:@{@"title": @"点击可以先看看哦"}];
    return titles;
}

@end
