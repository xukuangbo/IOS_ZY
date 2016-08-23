//
//  TacticMainCountryCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"

@interface TacticMainCountryCell : ZYZCBaseTableViewCell


@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *moreButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView maxViewCount:(NSInteger )maxViewCount;

@property (nonatomic, strong) NSArray *countryArray;
@end
