//
//  AddCommentView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommentTargetType)
{
    CommentProductType=1,//回复项目
    CommentUserType,     //回复某人
};

/**
 *  评论成功后操作
 */
typedef void (^CommentSuccess)();
/**
 * 评论操作
 */
typedef void (^CommitComment)(NSString  *content);

@interface AddCommentView : UIView
@property (nonatomic, strong) UITextView     *editFieldView;

@property (nonatomic, copy  ) CommentSuccess commentSuccess;//评论成功后需要的操作
@property (nonatomic, copy  ) CommitComment  commitComment; //提交评论的操作

@property (nonatomic, assign) CommentTargetType commentTargetType;//评论对象

@property (nonatomic, copy  ) NSString      *commentUserName;//评论的人名

- (void) textFieldRegisterFirstResponse;
- (void) textFieldBecomeFirstResponse;

@end
