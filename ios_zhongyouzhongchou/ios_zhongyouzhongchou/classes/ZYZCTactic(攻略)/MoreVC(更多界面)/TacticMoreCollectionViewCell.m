//
//  TacticMoreCollectionViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMoreCollectionViewCell.h"
#import "TacticImageView.h"
#import "ZYZCPlayViewController.h"
#import "TacticSingleViewController.h"
#import "TacticSingleFoodVC.h"
#import "TacticVideoModel.h"
#import "TacticSingleFoodModel.h"
#import "TacticSingleModel.h"
@interface TacticMoreCollectionViewCell ()

@end
@implementation TacticMoreCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        TacticImageView *imageView = [[TacticImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}


@end
