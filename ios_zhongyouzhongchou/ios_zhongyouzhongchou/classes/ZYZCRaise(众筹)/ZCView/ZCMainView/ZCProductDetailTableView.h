//
//  ZCProductDetailTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define BGIMAGEHEIGHT  200*KCOFFICIEMNT
#define BLURHEIGHT     44

#import "ZYZCBaseTableView.h"
#import "ZCDetailModel.h"
#import "ZYZCOneProductCell.h"
#import "ZCDetailTableHeadView.h"

@interface ZCProductDetailTableView : ZYZCBaseTableView

@property (nonatomic, strong) UIImageView   *topImgView;   //头部风景图

@property (nonatomic, strong) ZCDetailTableHeadView *headView; //切换的头图

@property (nonatomic, copy  ) NSString      *travelTheme;  //旅行主题名

@property (nonatomic, strong) ZCOneModel    *oneModel;    //众筹概况数据

@property (nonatomic, strong) ZCDetailModel *detailModel; //众筹详细数据

@property (nonatomic, strong) NSArray       *detailDays;  //行程安排数组

@property (nonatomic, copy  ) NSString      *productDest;  //旅行目的地

@property (nonatomic, strong) NSArray       *viewSpots;    //目的地数组

@property (nonatomic, strong) NSMutableArray  *spotVideos;   //目的地视屏数组

@property (nonatomic, strong) NSMutableArray  *commentArr;   //评论信息数组

@property (nonatomic, strong)NSNumber   *productId;

//记录众筹详情是从哪里来的
@property (nonatomic, assign) DetailProductType     detailProductType;

@end
