//
//  ZYFootprintCommentTable.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"

#import "ZYCommentFootprintCell.h"
#import "ZYFootprintOneCommentCell.h"

@interface ZYFootprintCommentTable : ZYZCBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintModel:(ZYFootprintListModel *)footprintModel;

@property (nonatomic, strong)ZYSupportListModel *supportUsersModel;


@end
