//
//  MoreFZCTravelTableView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableView.h"
#import "TravelFirstCell.h"
#import "TravelSecondCell.h"
@interface MoreFZCTravelTableView : MoreFZCBaseTableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL isChangeHeight;
@property (nonatomic, assign) NSInteger travelDays;
@property (nonatomic, strong) NSMutableDictionary *rowsChangeHeight;
@property (nonatomic, strong) NSMutableArray *travelDetailCellArr;
@end
