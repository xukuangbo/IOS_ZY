//
//  MoreFZCGoalTableView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCGoalTableView.h"
#import "GoalFirstCell.h"
#import "GoalSecondCell.h"
@interface MoreFZCGoalTableView ()

@end
@implementation MoreFZCGoalTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource =self;
        self.delegate  = self;
        self.tableFooterView.backgroundColor=[UIColor greenColor];
        self.tableHeaderView.backgroundColor=[UIColor orangeColor];
//        self.contentInset = UIEdgeInsetsMake(64 +40, 0, 49, 0);
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        GoalFirstCell *firstCell=[tableView dequeueReusableCellWithIdentifier:@"goalFirstCell"];
        if (!firstCell) {
             firstCell=[[GoalFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goalFirstCell"];
        }
        [firstCell reloadViews];
        return firstCell;
    }
    else if (indexPath.row==2){
        GoalSecondCell *secondCell=[tableView dequeueReusableCellWithIdentifier:@"goalSecondCell"];
        if (!secondCell) {
            secondCell=[[GoalSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goalSecondCell"];
        }
        return secondCell;
    }
    else
    {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor ZYZC_BgGrayColor];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return FIRSTCELLHEIGHT;
            break;
        case 2:
            return SECONDCELLHEIGHT;
            break;
        default:
            return KEDGE_DISTANCE;
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

-(void)dealloc
{
    
}

@end
