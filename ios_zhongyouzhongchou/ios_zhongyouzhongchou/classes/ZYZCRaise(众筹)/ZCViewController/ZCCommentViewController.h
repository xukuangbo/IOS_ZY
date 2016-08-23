//
//  ZCCommitViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "UserModel.h"

@interface ZCCommentViewController : ZYZCBaseViewController
@property (nonatomic, strong) NSNumber  *productId;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) BOOL      needGetData;
@property (nonatomic, strong) NSArray   *comments;
@end
