//
//  showDashangMapView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "showDashangMapView.h"
#import "showDashangView.h"
@interface showDashangMapView ()

@property (nonatomic, strong) showDashangView *firstView;
@property (nonatomic, strong) showDashangView *sencondView;
@end

@implementation showDashangMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
//    self.backgroundColor = [UIColor greenColor];
    
    _firstView = [[showDashangView alloc] initWithFrame:CGRectMake(-showDashangMapViewW, 0, showDashangMapViewW, showDashangMapViewH)];
    [self addSubview:_firstView];
//    _sencondView = [[showDashangView alloc] initWithFrame:CGRectMake(-showDashangMapViewH, 40, showDashangMapViewW, 40)];
//    [self addSubview:_sencondView];
    
    
}

- (void)showDashangData{
    
    self.backgroundColor = [UIColor greenColor];
    
    LiveShowDashangModel *model = [[LiveShowDashangModel alloc] init];
    model.headURL = @"http://img3.imgtn.bdimg.com/it/u=2459118549,2741314486&fm=21&gp=0.jpg";
    model.nameLabel = @"小白";
    model.numberPeople = @"100";
    _firstView.dashangModel = model;
//    _firstView.backgroundColor = [UIColor yellowColor];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(self){
            
            [UIView animateWithDuration:2 animations:^{
                _firstView.left = 100;
            } completion:^(BOOL finished) {
                //延迟2秒执行
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _firstView.alpha = 0;
                    } completion:^(BOOL finished) {
                        _firstView.left = -showDashangMapViewW;
                        _firstView.alpha = 1;
                    }];
                });
                
            }];
            sleep(0.5);
        }
    });
    
}
@end
