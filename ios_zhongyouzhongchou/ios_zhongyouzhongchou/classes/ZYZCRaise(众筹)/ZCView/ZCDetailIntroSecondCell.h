//
//  ZCDetailIntroSecondCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ZCDETAILINTRO_SECONDCELL_HEIGHT  230+(KSCREEN_W-4*KEDGE_DISTANCE)*5/8

#import "MoreFZCBaseTableViewCell.h"

#import "TacticSingleModel.h"

@interface ZCDetailIntroSecondCell : MoreFZCBaseTableViewCell

@property (nonatomic, strong) NSArray *goals;

@property (nonatomic, strong) UIImageView *oneGoalImg;

@property (nonatomic, strong) UILabel *generalLab;

@property (nonatomic, strong) TacticSingleModel *tacticSingleModel;

@end
