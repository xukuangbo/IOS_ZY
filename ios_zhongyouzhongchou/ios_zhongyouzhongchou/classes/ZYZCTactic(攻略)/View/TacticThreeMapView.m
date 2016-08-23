
//
//  TacticThreeMapView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticThreeMapView.h"
#import "TacticVideoModel.h"
#import "TacticImageView.h"
#import "TacticSingleFoodModel.h"
#import "ZYZCPlayViewController.h"
#import "TacticSingleViewController.h"
#import "TacticSingleFoodVC.h"
#import "TacticSingleModel.h"
@interface TacticThreeMapView()

@property (nonatomic, strong) NSMutableArray *viewArray;

@end
@implementation TacticThreeMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewArray = [NSMutableArray array];
        
        //先让自己的数组拥有3个view，是否显示要看以后
        CGFloat threeMapViewMargin = 10;
        CGFloat buttonWH = (frame.size.width - threeMapViewMargin * 2) / 3.0;
        for (int i = 0; i < 3; i++) {
            CGFloat buttonX = i * (threeMapViewMargin + buttonWH);
            CGFloat buttonY = 0;
            TacticImageView *button = [[TacticImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWH, buttonWH)];
            button.frame = CGRectMake(buttonX, buttonY, buttonWH, buttonWH);
            [self.viewArray addObject:button];
        }
        
    }
    return self;
}


- (void)setVideos:(NSArray *)videos
{
    if (_videos != videos) {
        _videos = videos;
        //先清空原来的view
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        int maxCount = videos.count >= 3? 3:(int)videos.count;
            for (int i = 0; i < maxCount; i++) {
                TacticVideoModel *videoModel = (TacticVideoModel *)videos[i];
                if (self.threeMapViewType == threeMapViewTypeDefult) {
                    //如果之前没有被设置过的话
                    if (videoModel.viewType == 1) {
                        self.threeMapViewType = threeMapViewTypeCountryView;
                    }else if (videoModel.viewType == 2){
                        self.threeMapViewType = threeMapViewTypeCityView;
                    }else if (videoModel.viewType == 3){
                        self.threeMapViewType = threeMapViewTypeSingleView;
                    }
                }
                TacticImageView *imageView = self.viewArray[i];
                imageView.pushType = self.threeMapViewType;
                imageView.tacticVideoModel = videoModel;
                //只添加这几个已有的view
                [self addSubview:imageView];
                
            }
    }
}

- (void)setSingleViews:(NSArray *)singleViews
{
    if (_singleViews != singleViews) {
        _singleViews = singleViews;
        //先清空原来的view
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        int maxCount = singleViews.count >= 3? 3:(int)singleViews.count;
        for (int i = 0; i < maxCount; i++) {
            TacticSingleModel *singleModel = (TacticSingleModel *)singleViews[i];
            if (self.threeMapViewType == threeMapViewTypeDefult) {
                //如果之前没有被设置过的话
                if (singleModel.viewType == 1) {
                    self.threeMapViewType = threeMapViewTypeCountryView;
                }else if (singleModel.viewType == 2){
                    self.threeMapViewType = threeMapViewTypeCityView;
                }else if (singleModel.viewType == 3){
                    self.threeMapViewType = threeMapViewTypeSingleView;
                }
            }
            TacticImageView *imageView = self.viewArray[i];
            imageView.pushType = self.threeMapViewType;
            imageView.tacticSingleModel = singleModel;
            //只添加这几个已有的view
            [self addSubview:imageView];
            
        }
    }
}

- (void)setFoodsArray:(NSArray *)foodsArray
{
    if (_foodsArray != foodsArray) {
        _foodsArray = foodsArray;
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        int maxCount = foodsArray.count >= 3? 3:(int)foodsArray.count;
        for (int i = 0; i < maxCount; i++) {
            TacticSingleFoodModel *foodModel = (TacticSingleFoodModel *)foodsArray[i];
            TacticImageView *imageView = self.viewArray[i];
            imageView.pushType = self.threeMapViewType;
            imageView.tacticSingleFoodModel = foodModel;
            //只添加这几个已有的view
            [self addSubview:imageView];
            
        }
    }
}
@end
