//
//  ZCProductDetailController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//所有他人众筹详情／我的众筹详情／我的草稿详情

#import "ZYZCBaseViewController.h"

#import "ZCProductDetailTableView.h"

@interface ZCProductDetailController : ZYZCBaseViewController

@property (nonatomic, copy  ) NSNumber         *productId;

@property (nonatomic, strong) ZCOneModel       *oneModel;

@property (nonatomic, strong) ZCDetailModel    *detailModel;

@property (nonatomic, strong) NSArray          *schedule;//行程安排（我的草稿中数据）
//标记：区分访客版,个人版还是草稿
@property (nonatomic, assign) DetailProductType detailProductType;

//记录众筹详情是从哪里来的
@property (nonatomic, assign) ProductType     fromProductType;

/**
 *  刷新部分数据
 */
-(void)reloadPartInfo;

@end
