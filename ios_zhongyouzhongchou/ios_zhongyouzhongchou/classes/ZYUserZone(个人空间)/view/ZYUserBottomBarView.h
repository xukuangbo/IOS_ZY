//
//  ZYUserBottomBarView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeFansNumber)(NSInteger fansNumber) ;

@interface ZYUserBottomBarView : UIView
@property (nonatomic, assign) BOOL      friendship;
@property (nonatomic, strong) NSNumber  *friendID;//关注的人id
@property (nonatomic, copy  ) NSString  *friendName;//关注的人名
@property (nonatomic, assign) NSInteger fansNumber;//粉丝数
@property (nonatomic, copy  ) ChangeFansNumber changeFansNumber;
@end
