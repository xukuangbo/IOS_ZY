//
//  ChatBlackListCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ChatBlackListCell.h"

@implementation ChatBlackListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ChatBlackListCell";
    
    ChatBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatBlackListCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    self.nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
