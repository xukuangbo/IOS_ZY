//
//  ZYUserHeadView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define User_Head_Height     189+40+80*KCOFFICIEMNT
#define My_User_Head_height  189+80*KCOFFICIEMNT

typedef NS_ENUM(NSInteger, UserZoomType)
{
    OtherZoomType=1,
    MySelfZoomType
};


#import <UIKit/UIKit.h>
#import "ZYTravelTypeView.h"

typedef void (^ChangeContent)(NSInteger contentType) ;

@interface ZYUserHeadView : UIView
@property (nonatomic, strong) UserModel     *userModel;
@property (nonatomic, assign) NSInteger     fansNumber;   //粉丝数
@property (nonatomic, assign) NSInteger     friendNumber; //关注数

@property (nonatomic, assign) CGFloat       tableOffSetY;

@property (nonatomic, strong) ZYTravelTypeView *travelTypeView;

@property (nonatomic, copy  ) ChangeContent    changeContent;//改变内容展示

- (instancetype)initWithUserZoomtype:(UserZoomType)userZoomType;

@end





