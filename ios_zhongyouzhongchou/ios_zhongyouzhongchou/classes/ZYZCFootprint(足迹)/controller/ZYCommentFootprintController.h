//
//  ZYCommentFootprintController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "ZYFootprintListModel.h"

@interface ZYCommentFootprintController : ZYZCBaseViewController

@property (nonatomic, strong) ZYFootprintListModel *footprintModel;

@property (nonatomic, assign) BOOL                 showWithKeyboard;

-(void)startEditComment;

@end
