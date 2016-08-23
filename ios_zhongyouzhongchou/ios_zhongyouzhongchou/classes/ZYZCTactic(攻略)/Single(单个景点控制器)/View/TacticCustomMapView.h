//
//  TacticCustomMapView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KEDGE_DISTANCE 10
#define TacticTableViewCellTextMargin 4
#define titleFont [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define descFont [UIFont systemFontOfSize:13]
#define descLabelBottom 34

//我提供两种高度给他
//这是视频播放，图文那种
#define oneViewMapHeight ((KSCREEN_W - KEDGE_DISTANCE * 4) / 8.0 * 5 + descLabelBottom + KEDGE_DISTANCE + TacticTableViewCellTextMargin)
#define oneViewHeight ((KSCREEN_W - KEDGE_DISTANCE * 4) / 8.0 * 5)
//这是3个view视频那种
#define threeViewMapHeight ((KSCREEN_W - KEDGE_DISTANCE * 6) / 3.0 + descLabelBottom + TacticTableViewCellTextMargin + KEDGE_DISTANCE)
#define threeViewHeight ((KSCREEN_W - KEDGE_DISTANCE * 6) / 3.0)

//6个小view
#define sixViewMapHeight (((KSCREEN_W - KEDGE_DISTANCE * 6) / 3.0 + KEDGE_DISTANCE) * 2 + descLabelBottom + TacticTableViewCellTextMargin )
#define sixViewHeight ((KSCREEN_W - KEDGE_DISTANCE * 6) / 3.0 * 2 + KEDGE_DISTANCE)
typedef NS_ENUM(NSInteger, MoreVCType)
{
    MoreVCTypeDefult = 0,
    MoreVCTypeTypeCountryView,//国家
    MoreVCTypeTypeCityView,//城市
    MoreVCTypeTypeSingleView,//一般景点
    MoreVCTypeTypeFood,//食物
    MoreVCTypeTypeVideo,//视频
    MoreVCTypeTypeMoreText
};

@protocol TacticCustomMapViewDelegate <NSObject>

- (void)pushToMoreVC:(UIButton *)button;
@end

@interface TacticCustomMapView : UIImageView
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *moreButton;

@property (nonatomic, weak) id<TacticCustomMapViewDelegate> delegate;
@end
