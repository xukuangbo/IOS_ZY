//
//  MsgListTableViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define MSG_LIST_CELL_HEIGHT  80

#import "ZYZCBaseTableViewCell.h"
#import "MsgListModel.h"

@interface MsgListTableViewCell : ZYZCBaseTableViewCell

@property (nonatomic, strong) MsgListModel *msgListModel;

@end
