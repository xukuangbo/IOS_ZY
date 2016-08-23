//
//  PartnerTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"
#import "PartnerTableCell.h"
@interface PartnerTableView : ZYZCBaseTableView
@property (nonatomic, strong) NSMutableArray *myListArr;
@property (nonatomic, strong) NSNumber       *productId;
@property (nonatomic, assign) MyPartnerType  myPartnerType;
@property (nonatomic, assign) BOOL           fromMyReturn;//是否来自回报
@end
