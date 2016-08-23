//
//  ZYChooseNetImgCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define NET_IMG_CELL_HEIGHT  (KSCREEN_W-2*KEDGE_DISTANCE)/2.24
#import "ZYZCBaseTableViewCell.h"
#import "ZYImageModel.h"
@interface ZYChooseNetImgCell : ZYZCBaseTableViewCell
@property (nonatomic, strong) ZYImageModel *imageModel;
@end
