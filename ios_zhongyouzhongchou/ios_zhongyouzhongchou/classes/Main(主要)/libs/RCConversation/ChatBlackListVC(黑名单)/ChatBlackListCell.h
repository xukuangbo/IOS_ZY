//
//  ChatBlackListCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBlackListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
