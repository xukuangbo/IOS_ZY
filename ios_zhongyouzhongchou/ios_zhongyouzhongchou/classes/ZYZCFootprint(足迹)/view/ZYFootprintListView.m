//
//  ZYFootprintListView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintListView.h"

@interface ZYFootprintListView ()

@property (nonatomic, assign) FootprintListType  footprintListType;

@end

@implementation ZYFootprintListView

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
        self.contentInset=UIEdgeInsetsMake(74, 0, 10, 0) ;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintListType:(FootprintListType ) footprintListType
{
    if (self=[super initWithFrame:frame style:style]) {
        self.contentInset=UIEdgeInsetsMake(74, 0, 10, 0) ;
        _footprintListType=footprintListType;
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYfootprintListCell *footprintCell=(ZYfootprintListCell *)[ZYfootprintListCell customTableView:tableView cellWithIdentifier:@"footprintCell" andCellClass:[ZYfootprintListCell class]];
    ZYFootprintListModel *cellModel=self.dataArr[indexPath.row];
    cellModel.footprintListType=_footprintListType;
    if (cellModel.creattime) {
        NSString *time=[ZYZCTool turnTimeStampToDate:cellModel.creattime];
        NSInteger year  = [[time substringToIndex:4] integerValue];
        NSInteger month = [[time substringWithRange:NSMakeRange(5, 2)] integerValue];
//        DDLog(@"year:%ld,month:%ld",year,month);
        cellModel.totalMonth=year*12+month;
    }
    
    if (indexPath.row==0) {
         cellModel.showDate=YES;
    }
    else
    {
        ZYFootprintListModel *pre_cellModel=self.dataArr[indexPath.row-1];
        if (cellModel.totalMonth<pre_cellModel.totalMonth) {
            cellModel.showDate=YES;
        }
        else
        {
            cellModel.showDate=NO;
        }
    }
    
    if(self.dataArr.count>=3)
    {
        if (indexPath.row==0) {
            cellModel.cellType=HeadCell;
        }
        else if (indexPath.row==self.dataArr.count-1)
        {
            cellModel.cellType=FootCell;
        }
        else
        {
            cellModel.cellType=BodyCell;
        }
    }
    else if (self.dataArr.count ==2)
    {
        if (indexPath.row==0) {
            cellModel.cellType=HeadCell;
        }
        else
        {
            cellModel.cellType=FootCell;
        }
    }
    else if(self.dataArr.count==1)
    {
        cellModel.cellType=CompleteCell;
        
    }
    
    footprintCell.listModel=cellModel;
    
    WEAKSELF;
    footprintCell.oneFootprintView.deleteFootprint=^(ZYFootprintListModel *oneFootprintModel)
    {
        NSMutableArray *mutArr= [NSMutableArray arrayWithArray:weakSelf.dataArr];
        [mutArr removeObject:oneFootprintModel];
        weakSelf.dataArr=mutArr;
        [weakSelf reloadData];
    };
    
    return footprintCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFootprintListModel *cellModel=(ZYFootprintListModel *)self.dataArr[indexPath.row];
    return cellModel.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark --- 置顶按钮状态变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self) {
        CGFloat offSetY=scrollView.contentOffset.y;
        if (self.scrollDidScrollBlock) {
            self.scrollDidScrollBlock(offSetY);
        }
    }
}


@end
