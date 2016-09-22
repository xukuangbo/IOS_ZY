//
//  ZYCommentListModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZYOneCommentModel;

@interface ZYCommentListModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy  ) NSString *errorMsg;

@end

//userId、userName、realName、faceImg,faceImg64,faceImg132,faceImg640、comment,creattime,id,pid,replyUserId
@interface ZYOneCommentModel : NSObject
@property (nonatomic, assign) NSInteger  ID;//评论id
@property (nonatomic, assign) NSInteger pid;//足迹id
@property (nonatomic, strong) NSNumber  *userId;
@property (nonatomic, copy  ) NSString  *userName;
@property (nonatomic, copy  ) NSString  *realName;
@property (nonatomic, copy  ) NSString  *faceImg;
@property (nonatomic, copy  ) NSString  *faceImg64;
@property (nonatomic, copy  ) NSString  *faceImg132;
@property (nonatomic, copy  ) NSString  *faceImg640;
@property (nonatomic, copy  ) NSString  *comment;
@property (nonatomic, copy  ) NSString  *creattime;
@property (nonatomic, copy  ) NSString  *replyUserId;
@property (nonatomic, copy  ) NSString  *replyUserName;
@property (nonatomic, assign) CGFloat   cellHeight;
@end
