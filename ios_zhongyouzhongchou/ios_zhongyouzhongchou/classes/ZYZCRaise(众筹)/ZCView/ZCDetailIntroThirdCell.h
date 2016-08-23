//
//  ZCDetailIntroThirdCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ZCDETAILINTRO_THIRDCELL_HEIGHT  85+(KSCREEN_W-4*KEDGE_DISTANCE)*5/8
#define SUBDES_FORMOVIE(goal) [NSString stringWithFormat:@"趣味动画教你畅游%@",goal]

#import "MoreFZCBaseTableViewCell.h"
#import "ZYZCCusomMovieImage.h"
#import "ZCSpotVideoModel.h"
@interface ZCDetailIntroThirdCell : MoreFZCBaseTableViewCell
@property (nonatomic, strong) UILabel *subDesLab;
@property (nonatomic, strong) ZCSpotVideoModel *spotVideoModel;
@property (nonatomic, strong) ZYZCCusomMovieImage *movieImg;
@end
