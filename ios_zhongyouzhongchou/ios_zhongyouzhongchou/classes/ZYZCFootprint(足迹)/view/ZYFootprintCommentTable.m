//
//  ZYFootprintCommentTable.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintCommentTable.h"


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
    NSInteger number=1;
    if (_supportUsersModel) {
        number+=1;
    }
    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
      ZYCommentFootprintCell *commentFootprintCell=(ZYCommentFootprintCell *)[ZYCommentFootprintCell customTableView:tableView cellWithIdentifier:@"commentFootprintCell" andCellClass:[ZYCommentFootprintCell class]];
        commentFootprintCell.footprintModel=_footprintModel;
        return commentFootprintCell;
    }
    else if (indexPath.row==1)
    {
        ZYSupportPeopleCell *supportPeopleCell=(ZYSupportPeopleCell *)[ZYSupportPeopleCell customTableView:tableView cellWithIdentifier:@"supportPeopleCell" andCellClass:[ZYSupportPeopleCell class]];
        supportPeopleCell.supportListModel=_supportUsersModel;
        return supportPeopleCell;
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
    else if(indexPath.row==1)
    {
        return _supportUsersModel.cellHeight;
    }
    else
    {
        return 100;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)setSupportUsersModel:(ZYSupportListModel *)supportUsersModel
{
    _supportUsersModel=supportUsersModel;
    [self reloadData];
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
