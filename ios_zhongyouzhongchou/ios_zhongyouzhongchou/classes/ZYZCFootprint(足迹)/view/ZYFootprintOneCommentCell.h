//
//  ZYFootprintOneCommentCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"
#import "ZYCommentListModel.h"
@interface ZYFootprintOneCommentCell : ZYZCBaseTableViewCell
@property (nonatomic, strong) ZYOneCommentModel *oneCommentModel;
@property (nonatomic, assign) BOOL              showCommentImg;
@end
