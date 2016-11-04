//
//  ZCSupportMoneyView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupportStateModel.h"
#import "ZCDetailModel.h"
#import "UIView+GetSuperTableView.h"
#import "MBProgressHUD+MJ.h"
@interface ZCSupportMoneyView : UIView

@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) ReportModel       *reportModel;      //数据model
@property (nonatomic, strong) SupportStateModel *supportStateModel;//状态model


- (instancetype)initWithFrame:(CGRect)frame andProductDetailModel:(ZCDetailProductModel *)productDetailModel;

@end
