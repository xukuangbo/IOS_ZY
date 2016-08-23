//
//  CommentUserCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define COMMENT_CELL_HEIGHT   200
#import "ZYZCBaseTableViewCell.h"
#import "UserModel.h"
@interface CommentUserCell : ZYZCBaseTableViewCell
@property (nonatomic, strong) NSNumber       *productId;
@property (nonatomic, strong) UserModel   *partnerModel;
@property (nonatomic, assign) NSInteger      *starNumber;
@end
