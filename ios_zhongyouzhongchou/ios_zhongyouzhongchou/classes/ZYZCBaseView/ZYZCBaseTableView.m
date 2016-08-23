//
//  ZYZCBaseTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"
@interface ZYZCBaseTableView ()

@end

@implementation ZYZCBaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
        self.delegate=self;
        self.dataSource=self;
        self.showsVerticalScrollIndicator=NO;
        self.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        self.backgroundColor=[UIColor ZYZC_BgGrayColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        __weak typeof (&*self)weakSelf=self;
        //添加下拉刷新
        MJRefreshNormalHeader *normarlHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.headerRefreshingBlock) {
                weakSelf.headerRefreshingBlock();
            }
        }];
        normarlHeader.lastUpdatedTimeLabel.hidden=YES;
        self.mj_header=normarlHeader;
        
        //添加上拉刷新
        MJRefreshAutoNormalFooter *autoFooter=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.footerRefreshingBlock) {
                weakSelf.footerRefreshingBlock();
            }
        }];
        [autoFooter setTitle:@"" forState:MJRefreshStateIdle];
        self.mj_footer=autoFooter;
    }
    return self;
}


-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr=dataArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0.001;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.001;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.001;
//}



@end
