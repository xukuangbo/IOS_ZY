//
//  ZCDetailIntroFifthCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "ZCDetailModel.h"
#import "ZCListModel.h"
@interface ZCDetailIntroFifthCell : MoreFZCBaseTableViewCell

@property (nonatomic, strong) ZCDetailProductModel *detailModel;
//记录众筹详情是从哪里来的
@property (nonatomic, assign) DetailProductType     detailProductType;
@end
