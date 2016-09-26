//
//  AddCommentView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommentSuccess)();
typedef void (^CommitComment)(NSString  *content);
@interface AddCommentView : UIView
@property (nonatomic, copy  ) CommentSuccess commentSuccess;//评论成功后需要的操作
@property (nonatomic, copy  ) CommitComment  commitComment; //提交评论的操作
- (void) textFieldRegisterFirstResponse;
- (void) textFieldBecomeFirstResponse;
@end
