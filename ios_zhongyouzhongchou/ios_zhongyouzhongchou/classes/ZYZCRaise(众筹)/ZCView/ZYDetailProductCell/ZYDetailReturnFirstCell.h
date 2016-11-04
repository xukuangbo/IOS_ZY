//
//  ZYDetailReturnFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "ZCDetailModel.h"
#import "ZCListModel.h"
#import "ZCSupportMoneyView.h"
@interface ZYDetailReturnFirstCell : MoreFZCBaseTableViewCell
@property (nonatomic, strong) ZCDetailProductModel *cellModel;
/**
 *  众筹项目截止
 */
@property (nonatomic, assign) BOOL  productEndTime;
//记录众筹详情是从哪里来的
@property (nonatomic, assign) DetailProductType     detailProductType;

@end
