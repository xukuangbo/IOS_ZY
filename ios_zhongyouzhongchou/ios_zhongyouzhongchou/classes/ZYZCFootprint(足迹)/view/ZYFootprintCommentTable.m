//
//  ZYFootprintCommentTable.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintCommentTable.h"
#import "ZYCommentFootprintController.h"
#import "MBProgressHUD+MJ.h"
#import <objc/runtime.h>
@interface ZYFootprintCommentTable ()

@property (nonatomic, strong) ZYFootprintListModel *footprintModel;
@property (nonatomic, strong) UIAlertController    *alertController;
@property (nonatomic, strong) ZYOneCommentModel    *deleteOneComment;

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
//        self.contentInset=UIEdgeInsetsMake(74, 0, 0, 0) ;
        footprintModel.footprintListType=OtherFootprintList;
        self.footprintModel=footprintModel;
        
        WEAKSELF;
        if (!_alertController) {
            //创建UIAlertController控制器
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除我的评论" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            // 删除
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                [weakSelf  deleteCommentWithComment:weakSelf.deleteOneComment];
            }];
            
            [cancelAction setValue:[UIColor ZYZC_MainColor]
                            forKey:@"_titleTextColor"];
            [deleteAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
            
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            
            _alertController=alertController;
        }
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1+self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
      ZYCommentFootprintCell *commentFootprintCell=(ZYCommentFootprintCell *)[ZYCommentFootprintCell customTableView:tableView cellWithIdentifier:@"commentFootprintCell" andCellClass:[ZYCommentFootprintCell class]];
        commentFootprintCell.footprintModel=_footprintModel;
        commentFootprintCell.supportListModel=_supportUsersModel;
        commentFootprintCell.showLine=self.dataArr.count;
        self.commentNumberChangeBlock=^(NSInteger commentNumber)
        {
            commentFootprintCell.commentNumber=commentNumber;
        };
        return commentFootprintCell;
    }
    else
    {
        ZYFootprintOneCommentCell *oneCommentCell=(ZYFootprintOneCommentCell *) [ZYFootprintOneCommentCell customTableView:tableView cellWithIdentifier:@"oneCommentCell" andCellClass:[ZYFootprintOneCommentCell class]];
       
            oneCommentCell.showCommentImg=indexPath.row==1;
            oneCommentCell.showLine=indexPath.row!=self.dataArr.count;
            oneCommentCell.oneCommentModel=self.dataArr[indexPath.row-1];
        return oneCommentCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return  _supportUsersModel.cellHeight;
    }
    else
    {
        ZYOneCommentModel *oneCommentModel=self.dataArr[indexPath.row-1];
        return oneCommentModel.cellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self.viewController.view endEditing:YES];
    }
    
    if(indexPath.row>=1)
    {
        
        ZYOneCommentModel *oneCommentModel=self.dataArr[indexPath.row-1];
        self.deleteOneComment=oneCommentModel;
        //如果是自己的评论，提示是否需要删除
        if ([[NSString stringWithFormat:@"%@",oneCommentModel.userId] isEqualToString:[ZYZCAccountTool getUserId]]) {
            [self.viewController presentViewController:_alertController animated:YES completion:nil];
        }
        else
        {
            self.replyUserId=oneCommentModel.userId;
            self.replyUserName=oneCommentModel.realName?oneCommentModel.realName:oneCommentModel.userName;
            ZYCommentFootprintController *commentController=(ZYCommentFootprintController *) self.viewController;
            if (commentController) {
                [commentController startEditComment];
            }
        }
    }
}


#pragma mark --- 删除评论
-(void)deleteCommentWithComment:(ZYOneCommentModel *)oneCommentModel
{
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_delComment"] andParameters:@{@"id":[NSNumber numberWithInteger:oneCommentModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.viewController.view];
        if (isSuccess) {
            [MBProgressHUD showShortMessage:@"删除成功"];
            [self.dataArr removeObject:oneCommentModel];
            if (self.commentNumberChangeBlock) {
                self.commentNumberChangeBlock(self.dataArr.count);
            }
            [self reloadData];
        }
        else
        {
            [MBProgressHUD showShortMessage:@"删除失败"];
        }
        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.viewController.view];
        [MBProgressHUD showShortMessage:@"删除失败"];
    }];
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollDidEndDeceleratingBlock) {
        _scrollDidEndDeceleratingBlock();
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (_scrollWillBeginDecelerating) {
        _scrollWillBeginDecelerating();
    }
}



@end
