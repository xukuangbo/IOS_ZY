//
//  MineOneItemCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineOneItemModel.h"
#define ONE_ITEM_CELL_HEIGHT  60
@interface MineOneItemCell : UITableViewCell

@property (nonatomic, strong) MineOneItemModel *itemModel;

@property (nonatomic, assign) BOOL      hiddenLine;
@property (nonatomic, assign) NSInteger myBadgeValue;
           

@end
