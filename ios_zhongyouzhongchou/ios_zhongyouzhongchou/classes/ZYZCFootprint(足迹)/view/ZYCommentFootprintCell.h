//
//  ZYCommentFootprintCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"
#import "ZYFootprintListModel.h"
#import "ZYSupportListModel.h"

@interface ZYCommentFootprintCell : ZYZCBaseTableViewCell

@property (nonatomic, strong) ZYFootprintListModel *footprintModel;

@property (nonatomic, strong) ZYSupportListModel *supportListModel;

@property (nonatomic, assign) BOOL               showLine;

@property (nonatomic, assign) NSInteger          commentNumber;

@end
