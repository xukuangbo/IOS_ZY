//
//  ZYZCBaseTableViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYZCBaseTableViewCell : UITableViewCell

/**
 *  创建自定义cell
 */
+ (UITableViewCell *) customTableView:(UITableView *)tableView cellWithIdentifier:(NSString *)cellId andCellClass:(id)cellClass;

/**
 *  创建普通cell，灰色背景，高度为10
 */
+ (UITableViewCell *) createNormalCell;

@end
