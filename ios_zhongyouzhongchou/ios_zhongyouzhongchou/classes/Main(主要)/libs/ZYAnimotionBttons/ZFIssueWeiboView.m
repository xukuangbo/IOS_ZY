//
//  ZFIssueWeiboView.m
//  ZFIsuueWeiboDemo
//
//  Created by 张锋 on 16/5/24.
//  Copyright © 2016年 张锋. All rights reserved.
//

#import "ZFIssueWeiboView.h"
#import "ZFWeiboButton.h"

#define buttonWH 100 // 按钮宽高
//static CGFloat const tabbarH = 40.;
static CGFloat const tabbarImgWH = 30.;
static NSInteger const ButtonTag = 1000;

//#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
//#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ZFIssueWeiboView ()  <ZFWeiboButtonDelegate>
@property (nonatomic, strong) UIImageView        *inerImgView;
@property (nonatomic, strong) UIVisualEffectView *backView;
@end

@implementation ZFIssueWeiboView


- (instancetype)initWithTitles:(NSArray *)titles andImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        _titles=titles;
        _images=images;
        [self createSubviews];
    }
    return self;
}

- (UIView *)deleteView
{
        _inerImgView = [[UIImageView alloc] init];
        _inerImgView.frame = CGRectMake((KSCREEN_W-tabbarImgWH) / 2,
                                        KSCREEN_H-tabbarImgWH-10,
                                        tabbarImgWH,
                                        tabbarImgWH);
        _inerImgView.image = [UIImage imageNamed:@"add_green"];
    
        [UIView animateWithDuration:0.3 animations:^{
            self.inerImgView.transform = CGAffineTransformMakeRotation(M_PI_4);
        }];
    
    return _inerImgView;
}

- (UIVisualEffectView *)backView
{
    if (!_backView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _backView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _backView.frame = CGRectMake(0, 0, KSCREEN_W, KSCREEN_H);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHiddenAnimation)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

#pragma mark - tabbar点击事件
- (void)tabbarClicked
{
    [self viewHiddenAnimation];
}

#pragma mark - 视图消失动画
- (void)viewHiddenAnimation
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ZFWeiboButton class]]) {
            [tempArray addObject:view];
        }
    }
    NSArray *array = [[tempArray reverseObjectEnumerator] allObjects];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.inerImgView.alpha=0;
        self.inerImgView.transform = CGAffineTransformMakeRotation(- M_PI_4);
    } completion:nil];
    
    for (int i=0; i<array.count; i++) {
        ZFWeiboButton *button =  (ZFWeiboButton *)array[i];
        [UIView animateWithDuration:0.4 delay:0.05 * i  usingSpringWithDamping:0.7 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
            button.y = KSCREEN_H;
        } completion:^(BOOL finished) {
            [button removeFromSuperview];
            [UIView animateWithDuration:0.1 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }
}

- (void)createSubviews
{
    [self addSubview:self.backView];
    [self addSubview:self.deleteView];
    
    NSArray *titles = @[@"文字",@"照片/视频",@"头条文章",@"签到",@"点评",@"更多"];
    NSArray *fImages = @[@"tabbar_compose_idea",
                         @"tabbar_compose_photo",
                         @"tabbar_compose_headlines",
                         @"tabbar_compose_lbs",
                         @"tabbar_compose_review",
                         @"tabbar_compose_more"];
    if (!self.titles) {
        self.titles = titles;
    }
    if (!self.images) {
        self.images = fImages;
    }
   /* NSArray *sImages = @[@"tabbar_compose_friend",
                         @"tabbar_compose_wbcamera",
                         @"tabbar_compose_music",
                         @"tabbar_compose_voice",
                         @"tabbar_compose_productrelease",
                         @"tabbar_compose_shooting"]; */
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i=0; i<self.titles.count; i++) {
        CGFloat lefSpacing = (KSCREEN_W - (buttonWH*3)) / 5;
        CGFloat midSpacing = lefSpacing * 1.5;
        CGFloat buttonX = lefSpacing + (midSpacing+buttonWH) * (i%3);
        
        ZFWeiboButton *button = [ZFWeiboButton buttonWithFrame:CGRectMake(buttonX,
                                                                KSCREEN_H,
                                                                buttonWH,
                                                                buttonWH)
                                               image:self.images[i]
                                               title:self.titles[i]];
        button.btnTag = ButtonTag + i;
        button.delegate = self;
        [mArray addObject:button];
        [self addSubview:button];
    }
    
    /**
     *  usingSpringWithDamping：0-1 数值越小，弹簧振动效果越明显
     *  initialSpringVelocity ：数值越大，一开始移动速度越快
     */
    for (int i=0; i<mArray.count; i++) {
//        CGFloat topSpacing = (KSCREEN_H-40) / 2;
        CGFloat topSpacing = KSCREEN_H -250;
        CGFloat buttonY = topSpacing + (buttonWH+30) * (i/3);
        ZFWeiboButton *button = mArray[i];
        
        [UIView animateWithDuration:0.5 delay:0.05*i  usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
            button.y = buttonY;
        } completion:nil];
    }
}

- (void)WeiboButtonClick:(ZFWeiboButton *)button
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ZFWeiboButton class]]) {
            [array addObject:view];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
        button.transform = CGAffineTransformMakeScale(3.0, 3.0);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        for (int i=0; i<array.count; i++) {
            ZFWeiboButton *wbButton = (ZFWeiboButton *)array[i];
            if (button != wbButton) {
                wbButton.transform = CGAffineTransformMakeScale(0.3, 0.3);
                wbButton.alpha = 0;
            }
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(animationHasFinishedWithButton:)]) {
            [self.delegate animationHasFinishedWithButton:button];
        }
    }];
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
}

@end
