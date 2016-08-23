//
//  TacticGoXXTravelCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticGoXXTravelCell.h"

@implementation TacticGoXXTravelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W - KEDGE_DISTANCE * 2, TacticGoXXTravelCellRowHeight)];
        bgView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        [self.contentView addSubview:bgView];
        
        //绿线
       UIView *lineView =[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, 2, bgView.height - 25) andColor:[UIColor ZYZC_MainColor]];
        [bgView addSubview:lineView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + KEDGE_DISTANCE, KEDGE_DISTANCE, bgView.width - lineView.right - KEDGE_DISTANCE, lineView.height)];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor ZYZC_titleBlackColor];
        [bgView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
    }
    return self;
}



@end
