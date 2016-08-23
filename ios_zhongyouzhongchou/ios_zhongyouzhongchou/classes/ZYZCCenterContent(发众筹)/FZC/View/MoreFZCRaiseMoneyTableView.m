//
//  MoreFZCRaiseMoneyTableView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCRaiseMoneyTableView.h"
@interface MoreFZCRaiseMoneyTableView ()


@end
@implementation MoreFZCRaiseMoneyTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource =self;
        self.delegate  = self;
    }
    return self;
}


- (NSMutableArray *)openArray
{
    if (!_openArray) {
        _openArray = [NSMutableArray arrayWithArray:@[@0]];
    }
    return _openArray;
}

/**
 *  初始化数组高度
 */
- (NSArray *)heightArray
{
    NSNumber *raiseSechHeight=[NSNumber numberWithFloat:RAISECECONDHEIGHT];
    if (!_heightArray) {
        _heightArray = [NSMutableArray arrayWithArray:@[@kRaiseMoneyRealHeight,@10,raiseSechHeight,@10]];
    }
    return _heightArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 3灰色空白视图
    if (indexPath.row == 1 ||indexPath.row ==3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noneCell"];
        cell.contentView.backgroundColor = [UIColor ZYZC_BgGrayColor];
        return cell;
    }else if(indexPath.row == 0){
        
        NSString *ID = @"MoreFZCRaiseMoneyFirstCell";
        MoreFZCRaiseMoneyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[MoreFZCRaiseMoneyFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.open = [self.openArray[indexPath.row] integerValue];
        //block的定义
        __weak typeof(&*self) weakSelf = self;
        
        cell.changeHeightBlock = ^(BOOL open){
            weakSelf.openArray[indexPath.row] = (open == YES? @1 : @0);
            CGFloat newHeight = (open == YES?kRaiseMoneyRealHeight + 200:kRaiseMoneyRealHeight);
            weakSelf.heightArray[indexPath.row] = @(newHeight);
            [weakSelf reloadData];
        };
        return cell;
    }else{//这里是第二个cell
        NSString *cellId=@"MoreFZCRaiseMoneySecondCell";
        MoreFZCRaiseMoneySecondCell *cell = [[MoreFZCRaiseMoneySecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        return cell;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
    
}

-(void)dealloc
{
    
}


@end
