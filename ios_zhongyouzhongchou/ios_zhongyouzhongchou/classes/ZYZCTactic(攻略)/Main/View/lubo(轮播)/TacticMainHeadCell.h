//
//  TacticMainHeadCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"

@interface TacticMainHeadCell : ZYZCBaseTableViewCell



@property (nonatomic, strong) NSArray *scrollImageArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
