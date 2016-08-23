//
//  TacticMoreVideoCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewCell.h"
@class TacticVideoModel;
#define TacticMoreVideoDescLabelHeight 50
#define TacticMoreVideoRowHeight ((KSCREEN_W - 2 * KEDGE_DISTANCE) / 16.0 * 10 + TacticMoreVideoDescLabelHeight)
@interface TacticMoreVideoCell : ZYZCBaseTableViewCell


@property (nonatomic, strong) TacticVideoModel *tacticVideoModel;
@end
