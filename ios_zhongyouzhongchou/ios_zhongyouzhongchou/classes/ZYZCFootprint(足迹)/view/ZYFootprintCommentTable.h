//
//  ZYFootprintCommentTable.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"
#import "ZYFootprintListModel.h"

@interface ZYFootprintCommentTable : ZYZCBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintModel:(ZYFootprintListModel *)footprintModel;

@end
