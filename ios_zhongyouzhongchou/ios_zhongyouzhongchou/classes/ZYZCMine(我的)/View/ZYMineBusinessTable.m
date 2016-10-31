//
//  ZYMineBusinessTable.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYMineBusinessTable.h"
#import "MineTableViewCell.h"
@implementation ZYMineBusinessTable

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
        self.mj_header=nil;
        self.mj_footer=nil;
    }
    return self;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        NSString *cellId=@"mineCell";
        MineTableViewCell *mineCell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!mineCell) {
            mineCell=[[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        mineCell.myBadgeValue=_count;
        return mineCell;
    }
    else
    {
        UITableViewCell *mormalCell=[MineTableViewCell createNormalCell];
        return mormalCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        if ([[ZYZCAPIGenerate sharedInstance] isTestMode]) {
            return MINE_CELL_HEIGHT + 60;
        }
        return MINE_CELL_HEIGHT;
    }
    else
    {
        return KEDGE_DISTANCE;
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
