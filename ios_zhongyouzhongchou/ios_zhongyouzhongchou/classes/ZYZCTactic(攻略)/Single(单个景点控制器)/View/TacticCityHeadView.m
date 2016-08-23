//
//  TacticCityHeadView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticCityHeadView.h"
#import "TacticSingleViewController.h"

@implementation TacticCityHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, 60)];
        namelabel.font = [UIFont boldSystemFontOfSize:33];
        namelabel.shadowOffset=CGSizeMake(1, 1);
        namelabel.shadowColor=[UIColor blackColor];
        namelabel.textAlignment = NSTextAlignmentCenter;
        namelabel.textColor = [UIColor whiteColor];
        namelabel.centerX = KSCREEN_W * 0.5;
        namelabel.centerY = TacticSingleHeadViewHeight * 0.5;
        [self addSubview:namelabel];
        self.nameLabel = namelabel;
        
        CGFloat flagImageWH = 30;
        UIImageView *flagImage = [[UIImageView alloc] init];
        flagImage.size = CGSizeMake(flagImageWH, flagImageWH);
        flagImage.layer.cornerRadius = flagImageWH / 2.0;
        flagImage.layer.masksToBounds = YES;
        flagImage.left = KEDGE_DISTANCE;
        flagImage.bottom = TacticSingleHeadViewHeight - KEDGE_DISTANCE;
        [self addSubview:flagImage];
        self.flagImage = flagImage;
        
        UILabel *flagImageName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, 30)];
        flagImageName.font = [UIFont boldSystemFontOfSize:18];
        flagImageName.shadowOffset=CGSizeMake(1, 1);
        flagImageName.shadowColor=[UIColor blackColor];
        flagImageName.textAlignment = NSTextAlignmentLeft;
        flagImageName.textColor = [UIColor whiteColor];
        flagImageName.centerY = flagImage.centerY;
        flagImageName.left = flagImage.right + KEDGE_DISTANCE;
        [self addSubview:flagImageName];
        self.flagImageName = flagImageName;
        
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
