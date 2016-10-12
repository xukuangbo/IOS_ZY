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
    _cgContextView = [[ZYCGContextView alloc] initWithFrame:self.bounds];
    [self addSubview:_cgContextView];
    _guideView = [[ZYDetailGuideView alloc] initWithFrame:CGRectZero];
    [_cgContextView addSubview:_guideView];
    
    NSDictionary *dic = [self getDetailTitleArray][type];
    
    
    switch (type) {
        case startHomeType:
        {[_guideView createDetailTitle:dic[@"title"] withAlignmentType:commonType];
        }
            break;
        case voiceType:
        {
            [_guideView createDetailTitle:dic[@"title"] withAlignmentType:commonType];
        }
        case skipType:
        {
            [_guideView createDetailTitle:dic[@"title"] withAlignmentType:commonType];
        }
            break;
        case prevType:
        {
            [_guideView createDetailTitle:dic[@"title"] withAlignmentType:commonType];
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
            guideCircleImageView.image = [UIImage imageNamed:@"common_circle_small"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right);
                make.width.equalTo(@(218/2));
                make.height.equalTo(@(218/2));
                make.centerY.equalTo(self.mas_bottom).offset(-43/2);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.bottom.equalTo(guideCircleImageView.mas_centerY).offset(-10-100);
            }];
        }
            break;
        case voiceType:
        {
            [_cgContextView drawRectInWay:CGRectMake(self.frame.size.width - 33, 40, 20, 20) withdrawType:contextType];
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.top.equalTo(self.mas_top).offset(10+50+100);
            }];
            
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"common_aperture"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(5);
                make.width.equalTo(@(152/2));
                make.height.equalTo(@(152/2));
                make.top.equalTo(self.mas_top).offset(2);
            }];
            break;
        }
        case skipType:
        {
            [_cgContextView drawRectInWay:CGRectMake(0, self.rectTypeOriginalY, self.frame.size.width,44) withdrawType:contextType];
            
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"common_circle_small"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right);
                make.width.equalTo(@(218/2));
                make.height.equalTo(@(218/2));
                make.centerY.equalTo(self.mas_top).offset(self.rectTypeOriginalY+44/2);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.top.equalTo(guideCircleImageView.mas_centerY).offset(22+50+100);
            }];
            
            break;
        }
        case prevType:
        {
            [_cgContextView drawRectInWay:CGRectMake(0, self.rectTypeOriginalY, self.frame.size.width,44) withdrawType:contextType];
            
            UIImageView *guideCircleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cgContextView addSubview:guideCircleImageView];
            guideCircleImageView.image = [UIImage imageNamed:@"common_circle_small"];
            [guideCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right);
                make.width.equalTo(@(218/2));
                make.height.equalTo(@(218/2));
                make.centerY.equalTo(self.mas_top).offset(self.rectTypeOriginalY+44/2);
            }];
            
            [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_cgContextView);
                make.top.equalTo(guideCircleImageView.mas_centerY).offset(22+50+100);
            }];
            
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
