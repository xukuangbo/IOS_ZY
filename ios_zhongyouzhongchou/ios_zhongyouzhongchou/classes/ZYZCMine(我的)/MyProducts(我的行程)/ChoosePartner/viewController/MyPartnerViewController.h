//
//  MyPartnerViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "ChoosePartnerViewController.h"
@interface MyPartnerViewController : ZYZCBaseViewController
@property (nonatomic, strong) NSNumber  *productId;
@property (nonatomic, assign) MyPartnerType myPartnerType;
@property (nonatomic, assign) BOOL      fromMyReturn;//判断是否是点击回报进入的
@end
