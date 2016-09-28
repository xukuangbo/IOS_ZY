//
//  ZYUserProductTable.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"

@interface ZYUserProductTable : ZYZCBaseTableView
typedef void (^ScrollWillBeginDraggingBlock)();
typedef void (^ScrollDidEndDeceleratingBlock)();

@property (nonatomic, copy  ) ScrollWillBeginDraggingBlock scrollWillBeginDraggingBlock;

@property (nonatomic, copy  ) ScrollDidEndDeceleratingBlock scrollDidEndDeceleratingBlock;

@end
