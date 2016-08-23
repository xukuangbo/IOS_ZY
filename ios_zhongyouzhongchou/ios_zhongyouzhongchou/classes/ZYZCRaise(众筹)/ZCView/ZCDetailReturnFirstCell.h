//
//  ZCDetailReturnFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "ZCDetailModel.h"
#import "ZCSupportOneYuanView.h"
#import "ZCSupportAnyYuanView.h"
#import "ZCSupportReturnView.h"
#import "ZCSupportTogetherView.h"
#import "ZCListModel.h"

@interface ZCDetailReturnFirstCell : MoreFZCBaseTableViewCell

@property (nonatomic, strong) ZCDetailProductModel *cellModel;

@property (nonatomic, strong) ZCSupportOneYuanView *supportOneYuanView;

@property (nonatomic, strong) ZCSupportAnyYuanView *supportAnyYuanView;

@property (nonatomic, strong) ZCSupportReturnView *returnSupportView01;

@property (nonatomic, strong) ZCSupportReturnView *returnSupportView02;

@property (nonatomic, strong) ZCSupportTogetherView *togetherView;

/**
 *  众筹项目截止
 */
@property (nonatomic, assign) BOOL  productEndTime;

//记录众筹详情是从哪里来的
@property (nonatomic, assign) DetailProductType     detailProductType;


@end
