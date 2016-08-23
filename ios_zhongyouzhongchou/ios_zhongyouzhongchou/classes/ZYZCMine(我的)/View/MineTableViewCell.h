//
//  MineTableViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineOneItemCell.h"
#define CELL_NUMBER          8
#define MINE_CELL_HEIGHT     ONE_ITEM_CELL_HEIGHT*CELL_NUMBER+5
@interface MineTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger myBadgeValue;
@end
