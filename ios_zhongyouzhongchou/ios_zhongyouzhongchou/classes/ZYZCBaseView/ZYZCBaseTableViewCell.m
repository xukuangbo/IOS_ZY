//
//  ZYZCBaseTableViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"

@implementation ZYZCBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor= [UIColor ZYZC_BgGrayColor];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark --- 创建自定义cell
+ (UITableViewCell *) customTableView:(UITableView *)tableView cellWithIdentifier:(NSString *)cellId andCellClass:(id)cellClass
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

#pragma mark --- 创建普通cell,灰色背景，高度为10
+ (UITableViewCell *) createNormalCell
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    return cell;
}


@end
