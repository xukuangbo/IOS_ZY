//
//  WalletKtxTableView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletKtxTableView.h"
//#import "MineWalletTableViewCell.h"
#import "WalletKtxCell.h"
static NSString *cellID = @"WalletKtxCell";

@implementation WalletKtxTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerNib:[UINib nibWithNibName:@"WalletKtxCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count) {
        return self.dataArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletKtxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.mineWalletModel = self.dataArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WalletKtxCellH;
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
