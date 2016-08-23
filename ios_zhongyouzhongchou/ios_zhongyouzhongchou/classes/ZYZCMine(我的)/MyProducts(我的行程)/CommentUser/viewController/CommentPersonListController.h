//
//  CommentPersonListController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

@interface CommentPersonListController : ZYZCBaseViewController

@property (nonatomic, strong) NSNumber       *productId;
//是否有回报支持的人
@property (nonatomic, assign) BOOL           hasReturnPerson;

@end
