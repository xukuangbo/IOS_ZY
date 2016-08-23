//
//  TacticBaseCustomView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"

#define titleFont [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define descFont [UIFont systemFontOfSize:13]


@interface TacticBaseCustomView : UIImageView
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *moreButton;



+ (instancetype)viewWithMaxCount:(NSInteger )maxCount;

- (void)moreButtonAction:(UIButton *)button;
@end
