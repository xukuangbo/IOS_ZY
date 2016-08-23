//
//  CommentListTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"

@interface CommentListTableView : ZYZCBaseTableView

@property (nonatomic, strong) NSNumber       *productId;

//一起游的人
@property (nonatomic, strong) NSArray        *myTogetherList;
//回报的人
@property (nonatomic, strong) NSArray        *myReturnList;

@end
