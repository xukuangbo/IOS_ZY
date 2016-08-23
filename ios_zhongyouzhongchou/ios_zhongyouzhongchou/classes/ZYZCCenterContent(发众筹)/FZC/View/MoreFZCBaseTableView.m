//
//  MoreFZCBaseTableView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableView.h"
#import "MoreFZCViewController.h"
@interface MoreFZCBaseTableView ()


@end

@implementation MoreFZCBaseTableView
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.contentInset = UIEdgeInsetsMake(toolBarHeight + kMoreFZCToolBar, 0, 0, 0);
//        self.toolBar = [self FZCViewController].toolBar;
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor ZYZC_BgGrayColor];
      self.contentInset = UIEdgeInsetsMake(64 + 40, 0, 49, 0);
      self.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
      self.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return self;
}
@end
