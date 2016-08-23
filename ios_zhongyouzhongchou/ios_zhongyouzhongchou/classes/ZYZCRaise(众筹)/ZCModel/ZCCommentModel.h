//
//  ZCCommentModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@class ZCCommentList,ZCCommentInfoModel;

@interface ZCCommentList : NSObject
@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, strong) NSArray  *commentList;

@property (nonatomic, assign) CGFloat  listCommentHeight;
@end

@interface ZCCommentModel : NSObject
@property (nonatomic, strong) ZCCommentInfoModel *comment;
@property (nonatomic, strong) UserModel          *user;
@property (nonatomic, assign) CGFloat            cellHeight;
@end

@interface ZCCommentInfoModel : NSObject

@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, copy  ) NSString *content;
@property (nonatomic, strong) NSNumber *sourceId;
@property (nonatomic, strong) NSNumber *sourceType;
@property (nonatomic, copy  ) NSString *timestamp;
@property (nonatomic, strong) NSNumber *userId;

@end

