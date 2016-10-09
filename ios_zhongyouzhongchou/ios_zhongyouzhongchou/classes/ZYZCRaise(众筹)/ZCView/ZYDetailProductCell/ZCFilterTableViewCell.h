//
//  ZCFilterTableViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCFilterModel.h"
#define FILTER_CELL_HEIGHT    40
@interface ZCFilterTableViewCell : UITableViewCell
@property(nonatomic,strong)ZCFilterModel *model;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andRowAtIndexPath:(NSIndexPath *)indexPath;

@end
