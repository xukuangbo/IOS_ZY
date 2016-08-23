//
//  PartnerTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "PartnerTableView.h"
#import "MBProgressHUD+MJ.h"
@implementation PartnerTableView

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
        _myListArr=[NSMutableArray array];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myListArr.count*2+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        PartnerTableCell *partnerCell=(PartnerTableCell *)[PartnerTableCell customTableView:tableView cellWithIdentifier:@"partnerCell" andCellClass:[PartnerTableCell class]];
        partnerCell.partnerModel=self.myListArr[(indexPath.row-1)/2];
        partnerCell.myPartnerType=_myPartnerType;
        partnerCell.productId    =_productId;
        partnerCell.fromMyReturn =_fromMyReturn;
        return partnerCell;
    }
    else
    {
        ZYZCBaseTableViewCell *normalCell=(ZYZCBaseTableViewCell *)[ZYZCBaseTableViewCell createNormalCell];
        return normalCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        
       return PARTYNER_CELL_HEIGHT;
    }
    return KEDGE_DISTANCE;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *model=self.myListArr[(indexPath.row-1)/2];
    //如果是从回报进入，则不可删除
    if (_fromMyReturn) {
        return UITableViewCellEditingStyleNone;
    }
    
    //  如果cell的my_status类型为0或4，可以删除
    if (_myPartnerType==TogtherPartner) {
        if ([model.my_status isEqual:@0]||[model.my_status isEqual:@4]) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UserModel *model=self.myListArr[(indexPath.row-1)/2];
    //
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    NSString *httpUrl=DELETE_TOGETHER_PARTNER([ZYZCAccountTool getUserId],_productId,model.userId);
    [ZYZCHTTPTool  getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        [MBProgressHUD hideHUDForView:self.viewController.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            [self.myListArr removeObjectAtIndex:(indexPath.row-1)/2];
            [self reloadData];
        }
    } andFailBlock:^(id failResult)
    {
        [MBProgressHUD hideHUDForView:self.viewController.view];
        [MBProgressHUD showError:@"删除失败!"];
//        NSLog(@"%@",failResult);
    }];
    
}

//设置删除键的宽度，根据字数来
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"哈哈哈";
//}

@end
