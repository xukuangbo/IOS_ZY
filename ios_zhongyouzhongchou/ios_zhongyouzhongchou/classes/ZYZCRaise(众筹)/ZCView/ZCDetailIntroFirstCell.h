//
//  ZCDetailIntroFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "ZCWSMView.h"
#import "ZCDetailModel.h"
@interface ZCDetailIntroFirstCell : MoreFZCBaseTableViewCell
@property (nonatomic, strong) ZCWSMView    *wsmView;

@property (nonatomic, strong) UIButton     *supportTogther;

@property (nonatomic, strong) ZCDetailProductModel *cellModel;
@end
