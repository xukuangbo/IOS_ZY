//
//  ParterStatusBtn.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "CommentUserViewController.h"
@interface ParterStatusBtn : UIButton<UIAlertViewDelegate>

@property (nonatomic, strong) NSNumber *comentStatus;//评价状态

@property (nonatomic, strong) NSNumber *status;//一起游状态

@property (nonatomic, strong) NSNumber *returnState;//回报状态

@property (nonatomic, strong) NSNumber *productId;

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, assign) MyPartnerType myPartnerType;

//如果是评价，评价类型
@property (nonatomic, assign) CommentType  commentType;
//是否已投诉
@property (nonatomic, assign) BOOL         hasComplain;

//@property (nonatomic, assign) BOOL fromReturn;

@end
