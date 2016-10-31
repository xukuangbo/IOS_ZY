//
//  WalletYbjTableView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"

typedef void (^ScrollWillBeginDraggingBlock)();
typedef void (^ScrollDidEndDeceleratingBlock)();

typedef void (^FirstRefreshBlock)();
@interface WalletYbjTableView : ZYZCBaseTableView

@property (nonatomic, copy  ) ScrollWillBeginDraggingBlock scrollWillBeginDraggingBlock;

@property (nonatomic, copy  ) ScrollDidEndDeceleratingBlock scrollDidEndDeceleratingBlock;

@property (nonatomic, copy) FirstRefreshBlock firstRefreshBlock;

@property (nonatomic, strong) NSMutableDictionary *selectDic;
@end
