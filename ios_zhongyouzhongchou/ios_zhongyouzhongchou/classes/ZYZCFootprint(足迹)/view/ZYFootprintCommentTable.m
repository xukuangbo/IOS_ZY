//
//  ZYFootprintCommentTable.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintCommentTable.h"
#import "ZYCommentFootprintCell.h"

@interface ZYFootprintCommentTable ()

@property (nonatomic, strong) ZYFootprintListModel *footprintModel;

@end

@implementation ZYFootprintCommentTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintModel:(ZYFootprintListModel *)footprintModel
{
    if (self=[super initWithFrame:frame style:style]) {
        self.backgroundColor=[UIColor whiteColor];
        self.contentInset=UIEdgeInsetsMake(74, 0, 10, 0) ;
        self.footprintModel=footprintModel;
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
      ZYCommentFootprintCell *commentFootprintCell=(ZYCommentFootprintCell *)[ZYCommentFootprintCell customTableView:tableView cellWithIdentifier:@"commentFootprintCell" andCellClass:[ZYCommentFootprintCell class]];
        commentFootprintCell.footprintModel=_footprintModel;
        return commentFootprintCell;
    }
    else
    {
        ZYCommentFootprintCell *normalCell=(ZYCommentFootprintCell *)[ZYCommentFootprintCell createNormalCell];
        return normalCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return  _footprintModel.cellHeight;
    }
    else
    {
        return 100;
    }
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
