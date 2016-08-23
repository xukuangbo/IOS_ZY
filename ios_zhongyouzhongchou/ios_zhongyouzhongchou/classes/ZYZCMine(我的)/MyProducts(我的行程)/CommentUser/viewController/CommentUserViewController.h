//
//  CommentUserViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

typedef NS_ENUM(NSInteger, CommentType)
{
    CommentToghterPartner,//评价一起游的人
    CommentReturnPerson,  //评价回报的人
    CommentProductPerson, //评价发起人
    CommentMyReturnProduct//评价我的回报的人
    
};

#import "ZYZCBaseViewController.h"
#import "UserModel.h"

typedef void (^FinishComment)();

@interface CommentUserViewController : ZYZCBaseViewController

@property (nonatomic, strong) NSNumber       *productId;

/**
 * 被评价者对象
 */
@property (nonatomic, strong) UserModel      *userModel;
/**
 *  评价后操作
 */
@property (nonatomic, copy  ) FinishComment  finishComent;
/**
 *  评价类型
 */
@property (nonatomic, assign) CommentType    commentType;

/**
 *  是否评价过
 */
@property (nonatomic, assign) BOOL           hasComment;

/**
 *  是否已投诉
 */
@property (nonatomic, assign) BOOL           hasComplain;

@end
