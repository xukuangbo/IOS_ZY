//
//  AddDetailView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSceneView.h"
typedef NS_ENUM(NSInteger, CourseType)
{
    SceneType=KFZC_COURSE_TYPE,
    TrafficType,
    AccommodateType,
    FoodType
};
typedef NS_ENUM(NSInteger, ContentCourseType)
{
    SceneContentType=KFZC_CONTENTCOURSE_TYPE,
    TrafficContentType,
    AccommodateContentType,
    FoodContentType
};

@interface AddDetailView : UIView
@property (nonatomic, strong) UIButton *preClickBtn;
@end
