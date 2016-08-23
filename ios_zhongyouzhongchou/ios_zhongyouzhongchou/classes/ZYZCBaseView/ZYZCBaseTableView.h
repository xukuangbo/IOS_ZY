//
//  ZYZCBaseTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HeaderRefreshingBlock)();
typedef void(^FooterRefreshingBlock)();
typedef void (^ScrollDidScrollBlock)(CGFloat offSetY);//滑动要实现的block
@interface ZYZCBaseTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;//数据源

//下拉刷新
@property (nonatomic, copy  ) HeaderRefreshingBlock headerRefreshingBlock;
//上拉刷新
@property (nonatomic, copy  ) FooterRefreshingBlock footerRefreshingBlock;
//滑动
@property (nonatomic, copy) ScrollDidScrollBlock scrollDidScrollBlock;

@end
