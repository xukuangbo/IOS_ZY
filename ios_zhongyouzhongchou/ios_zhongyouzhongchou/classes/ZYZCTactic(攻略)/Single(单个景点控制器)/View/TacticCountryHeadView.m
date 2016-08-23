//
//  TacticCountryHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticCountryHeadView.h"
#import "TacticSingleViewController.h"

@implementation TacticCountryHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        [self addSubview:mapView];
        
        CGFloat flagImageWH = 60;
        UIImageView *flagImage = [[UIImageView alloc] init];
        flagImage.contentMode = UIViewContentModeScaleAspectFill;
        flagImage.size = CGSizeMake(flagImageWH, flagImageWH);
        flagImage.layer.cornerRadius = flagImageWH / 2.0;
        flagImage.layer.masksToBounds = YES;
        flagImage.centerX = mapView.centerX;
        flagImage.top = 0;
        [mapView addSubview:flagImage];
        self.flagImage = flagImage;
        
        UILabel *flagImageName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, 40)];
        flagImageName.font = [UIFont boldSystemFontOfSize:33];
        flagImageName.shadowOffset=CGSizeMake(1, 1);
        flagImageName.shadowColor=[UIColor blackColor];
        flagImageName.textAlignment = NSTextAlignmentCenter;
        flagImageName.textColor = [UIColor whiteColor];
        flagImageName.top = flagImage.bottom;
        flagImageName.centerX = mapView.centerX;
        [mapView addSubview:flagImageName];
        self.flagImageName = flagImageName;
        
        mapView.height = flagImageName.bottom;
        mapView.center = CGPointMake(KSCREEN_W * 0.5, TacticSingleHeadViewHeight * 0.5);
        
//        NSLog(@"%@",NSStringFromCGRect(mapView.frame));
        //        UILabel *flagImageName = [[UILabel alloc] init];
        //        flagImageName.size = CGSizeMake(30, 30);
        //        flagImageName.left = flagImage.right + 5;
        //        flagImageName.centerY = flagImage.centerY;
        //        flagImageName.shadowOffset=CGSizeMake(1, 1);
        //        [self addSubview:flagImageName];
        //        self.flagImageName = flagImageName;
        
    }
    return self;
}

@end
