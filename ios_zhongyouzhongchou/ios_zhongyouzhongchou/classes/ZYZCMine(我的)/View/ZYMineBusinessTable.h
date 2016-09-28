//
//  ZYMineBusinessTable.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"
@interface ZYMineBusinessTable : ZYZCBaseTableView

typedef void (^ScrollWillBeginDraggingBlock)();
typedef void (^ScrollDidEndDeceleratingBlock)();

@property (nonatomic, copy  ) ScrollWillBeginDraggingBlock scrollWillBeginDraggingBlock;

@property (nonatomic, copy  ) ScrollDidEndDeceleratingBlock scrollDidEndDeceleratingBlock;

@property (nonatomic, assign) int            count;//未读消息数
@end
