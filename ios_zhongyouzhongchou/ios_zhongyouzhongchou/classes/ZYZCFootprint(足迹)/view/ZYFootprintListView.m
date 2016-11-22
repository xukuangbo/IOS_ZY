//
//  ZYFootprintListView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintListView.h"
#import "ZYCommentFootprintController.h"
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
        self.contentInset=UIEdgeInsetsMake(64, 0, 0, 0) ;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintListType:(FootprintListType ) footprintListType
{
    if (self=[super initWithFrame:frame style:style]) {
        self.contentInset=UIEdgeInsetsMake(64, 0, 0, 0) ;
        _footprintListType=footprintListType;
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _footprintListType==MyFootprintList?
    self.dataArr.count+3:self.dataArr.count+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||
        indexPath.row==(_footprintListType==MyFootprintList?
        self.dataArr.count+2:self.dataArr.count+1)) {
        UITableViewCell *cell=[ZYStartPublishFootprintCell createNormalCell];
        return cell;
    }
    else{
        if (_footprintListType==MyFootprintList) {
            if (indexPath.row==1) {
                ZYStartPublishFootprintCell *startFootprintCell=(ZYStartPublishFootprintCell *)[ZYStartPublishFootprintCell customTableView:tableView cellWithIdentifier:@"startFootprintCell" andCellClass:[ZYStartPublishFootprintCell class]];
                startFootprintCell.footprintCellType=self.dataArr.count?HeadCell:CompleteCell;
                return startFootprintCell;
            }
            else
            {
                ZYfootprintListCell *footprintListCell=[self createFootprintListCellWithTableView:tableView andIndex:indexPath.row-2];
                return footprintListCell;
            }
        }
        else
        {
            ZYfootprintListCell *footprintListCell=[self createFootprintListCellWithTableView:tableView andIndex:indexPath.row-1];
            return footprintListCell;
        }
    }
}

-(ZYfootprintListCell *)createFootprintListCellWithTableView:(UITableView *)tableView andIndex:(NSInteger)index
{
    ZYfootprintListCell *footprintCell=(ZYfootprintListCell *)[ZYfootprintListCell customTableView:tableView cellWithIdentifier:[NSString stringWithFormat:@"footprintCell%ld",index] andCellClass:[ZYfootprintListCell class]];
    ZYFootprintListModel *cellModel=self.dataArr[index];
    cellModel.footprintListType=_footprintListType;
    if (cellModel.creattime) {
        NSString *time=[ZYZCTool turnTimeStampToDate:cellModel.creattime];
        NSInteger year  = [[time substringToIndex:4] integerValue];
        NSInteger month = [[time substringWithRange:NSMakeRange(5, 2)] integerValue];
        cellModel.totalMonth=year*12+month;
    }
    if (index==0) {
        cellModel.showDate=YES;
    }
    else
    {
        ZYFootprintListModel *pre_cellModel=self.dataArr[index-1];
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
        if (index==0) {
            cellModel.cellType=HeadCell;
        }
        else if (index==self.dataArr.count-1)
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
        if (index==0) {
            cellModel.cellType=HeadCell;
        }
        else
        {
            cellModel.cellType=FootCell;
        }
    }
    else
    {
        if (_footprintListType==MyFootprintList)
        {
             cellModel.cellType=FootCell;
        }
        else
        {
            cellModel.cellType=CompleteCell;
        }
    }
    
    if (_footprintListType==MyFootprintList&&index==0&&self.dataArr.count>1) {
        cellModel.cellType=BodyCell;
    }
    
    footprintCell.listModel=cellModel;
    
    return footprintCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||
        indexPath.row==(_footprintListType==MyFootprintList?
                        self.dataArr.count+2:self.dataArr.count+1)) {
        return KEDGE_DISTANCE;
    }
    else{
        if (_footprintListType==MyFootprintList) {
            if (indexPath.row==1) {
                return  START_CELL_HEIGHT;
            }
            else
            {
                 ZYFootprintListModel *cellModel=(ZYFootprintListModel *)self.dataArr[indexPath.row-2];
                return cellModel.cellHeight;
            }
        }
        else
        {
            ZYFootprintListModel *cellModel=(ZYFootprintListModel *)self.dataArr[indexPath.row-1];
            return cellModel.cellHeight;

        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = _footprintListType==MyFootprintList?indexPath.row-2:indexPath.row-1;
    if (index>=0) {
        ZYCommentFootprintController *commentFootprintController=[[ZYCommentFootprintController alloc]init];
        commentFootprintController.footprintModel=self.dataArr[index];
        commentFootprintController.hidesBottomBarWhenPushed=YES;
        commentFootprintController.showWithKeyboard = NO;
        [self.viewController.navigationController pushViewController:commentFootprintController animated:YES];
    }
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


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollWillBeginDraggingBlock) {
        self.scrollWillBeginDraggingBlock();
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollDidEndDeceleratingBlock) {
        self.scrollDidEndDeceleratingBlock();
    }
}



@end
