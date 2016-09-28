//
//  ZYFootprintListView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"
#import "ZYfootprintListCell.h"
#import "ZYStartPublishFootprintCell.h"
typedef void (^ScrollWillBeginDraggingBlock)();
typedef void (^ScrollDidEndDeceleratingBlock)();
@interface ZYFootprintListView : ZYZCBaseTableView


@property (nonatomic, copy  ) ScrollWillBeginDraggingBlock scrollWillBeginDraggingBlock;

@property (nonatomic, copy  ) ScrollDidEndDeceleratingBlock scrollDidEndDeceleratingBlock;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintListType:(FootprintListType ) footprintListType;

@end
