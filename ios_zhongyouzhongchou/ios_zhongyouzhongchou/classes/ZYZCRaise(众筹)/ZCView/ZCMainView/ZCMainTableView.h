//
//  ZCMainTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"


typedef void (^ScrollEndScrollBlock)(CGPoint velocity);//滑动结束
@interface ZCMainTableView : ZYZCBaseTableView
@property (nonatomic, copy ) ScrollEndScrollBlock  scrollEndScrollBlock;
@end
