//
//  MsgListTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MsgListTableView.h"
#import "ZYZCMsgDetailViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
@implementation MsgListTableView

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
        self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        self.contentInset=UIEdgeInsetsMake(0, 0, 0, 0) ;
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListTableViewCell *msgCell=(MsgListTableViewCell *)[MsgListTableViewCell customTableView:tableView cellWithIdentifier:@"msgCell" andCellClass:
        [MsgListTableViewCell class]];
    msgCell.msgListModel=self.dataArr[indexPath.row];
    return msgCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MSG_LIST_CELL_HEIGHT;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListModel *msgListModel=self.dataArr[indexPath.row];
    msgListModel.readstatus=YES;
    [self reloadData];
    //如果存在productId参数，说明消息与项目有关
    if (msgListModel.productId&&[msgListModel.productId integerValue]>0) {
        ZYZCMsgDetailViewController *msgDetailController=[[ZYZCMsgDetailViewController alloc]init];
        msgDetailController.msgListModel=msgListModel;
        [self.viewController.navigationController pushViewController:msgDetailController animated:YES];
    }
    else
    {
        //msgStyle为99，进入appstore更新app
        if (msgListModel.msgStyle==99) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
        }
        else
        //系统通知
        {
            
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return UITableViewCellEditingStyleDelete;
}

#pragma mark --- 删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MsgListModel *msgModel=self.dataArr[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Post_Delete_Msg andParameters:@{@"id":[NSNumber numberWithInteger:msgModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self];
        DDLog(@"%@",result);
        if (isSuccess) {
            NSMutableArray *newDataArr=[NSMutableArray arrayWithArray:self.dataArr];
            [newDataArr removeObjectAtIndex:indexPath.row];
            self.dataArr=newDataArr;
            [self reloadData];
        }
        else
        {
            [MBProgressHUD showShortMessage:@"删除失败"];
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showShortMessage:@"删除失败"];
        [MBProgressHUD hideHUDForView:self];
        DDLog(@"%@",failResult);
    }];
}



@end
