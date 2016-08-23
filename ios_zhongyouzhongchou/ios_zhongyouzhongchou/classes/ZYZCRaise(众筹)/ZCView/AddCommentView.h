//
//  AddCommentView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommentSuccess)(NSString *content);
@interface AddCommentView : UIView
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, copy  ) CommentSuccess commentSuccess;//评论成功后需要的操作
@property (nonatomic, strong) UITextView     *editFieldView;
@property (nonatomic, strong) UIButton       *sendComentBtn;
@end
