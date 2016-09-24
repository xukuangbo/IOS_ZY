//
//  ZYfootprintListCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//


#import "ZYZCBaseTableViewCell.h"
#import "ZYOneFootprintView.h"
@interface ZYfootprintListCell : ZYZCBaseTableViewCell

@property (nonatomic, strong) ZYFootprintListModel *listModel;

@property (nonatomic, strong) ZYOneFootprintView  *oneFootprintView;

@end
