//
//  ZCDetailReturnSecondCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define RETURN_SEC_CELL_HEIGHT    100
#import "ZCCommentModel.h"
#import "MoreFZCBaseTableViewCell.h"

@interface ZCDetailReturnSecondCell : MoreFZCBaseTableViewCell
@property (nonatomic, strong) ZCCommentList  *commentList;
@property (nonatomic, strong) NSArray        *comments;
@property (nonatomic, assign) CGFloat        cellHeight;
@end
