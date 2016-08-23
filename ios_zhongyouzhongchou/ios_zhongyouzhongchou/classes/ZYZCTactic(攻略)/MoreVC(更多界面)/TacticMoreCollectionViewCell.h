//
//  TacticMoreCollectionViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//
//typedef NS_ENUM(NSInteger, PushVCType)
//{
//    pushVCTypeDefult = 0,
//    pushVCTypeCountryView,//国家
//    pushVCTypeCityView,//城市
//    pushVCTypeSingleView,//一般景点
//    pushVCTypeFood,//食物
//    pushVCTypeVideo
//};
#import <UIKit/UIKit.h>
@class TacticImageView;
@interface TacticMoreCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) TacticImageView *imageView;

//@property (nonatomic, assign) PushVCType pushVCType;
@end
