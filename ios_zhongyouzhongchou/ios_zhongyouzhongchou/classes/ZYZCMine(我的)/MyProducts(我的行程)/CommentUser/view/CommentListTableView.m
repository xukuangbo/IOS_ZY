//
//  CommentListTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CommentListTableView.h"
#import "PartnerTableCell.h"
@implementation CommentListTableView

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
       
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num=(_myTogetherList.count>0)+(_myReturnList.count>0);
//    NSLog(@"section:%ld",num);
    return  num;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (_myTogetherList.count) {
            return _myTogetherList.count*2-1;
        }
        return 0;
    }
    else
    {
        return _myReturnList.count*2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (_myTogetherList.count) {
            if (indexPath.row%2==0) {
                PartnerTableCell *partnerCell=(PartnerTableCell *)[PartnerTableCell customTableView:tableView cellWithIdentifier:@"togtherCell" andCellClass:[PartnerTableCell class]];
                partnerCell.partnerModel=_myTogetherList[indexPath.row/2];
                partnerCell.productId=_productId;
                partnerCell.commentType=CommentToghterPartner;
                return partnerCell;
            }
            else
            {
                ZYZCBaseTableViewCell *normalCell=(ZYZCBaseTableViewCell *)[ZYZCBaseTableViewCell createNormalCell];
                return normalCell;
            }
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if (indexPath.row%2==0) {
            PartnerTableCell *partnerCell=(PartnerTableCell *)[PartnerTableCell customTableView:tableView cellWithIdentifier:@"returnCell" andCellClass:[PartnerTableCell class]];
            partnerCell.partnerModel=_myReturnList[indexPath.row/2];
            partnerCell.productId=_productId;
            partnerCell.commentType=CommentReturnPerson;
            return partnerCell;
        }
        else
        {
            ZYZCBaseTableViewCell *normalCell=(ZYZCBaseTableViewCell *)[ZYZCBaseTableViewCell createNormalCell];
            return normalCell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (_myTogetherList.count) {
            if (indexPath.row%2==0) {
                return PARTYNER_CELL_HEIGHT;
            }
            else
            {
                return KEDGE_DISTANCE;
            }
        }
        else
        {
            return 0.0;
        }
    }
    else
    {
        if (indexPath.row%2==0) {
            return PARTYNER_CELL_HEIGHT;
        }
        else
        {
            return KEDGE_DISTANCE;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (_myTogetherList.count) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 40)];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-KEDGE_DISTANCE, 40)];
            lab.text=@"一起游";
            lab.font=[UIFont systemFontOfSize:17];
            lab.textColor=[UIColor ZYZC_TextBlackColor];
            [view addSubview:lab];
            return  view;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 40)];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-KEDGE_DISTANCE, 40)];
        lab.text=@"回报";
        lab.font=[UIFont systemFontOfSize:17];
        lab.textColor=[UIColor ZYZC_TextBlackColor];
        [view addSubview:lab];
        return  view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end
