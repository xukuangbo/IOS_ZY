//
//  WalletYbjTableView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletYbjTableView.h"
//#import "MineWalletTableViewCell.h"
#import "WalletYbjCell.h"
#import "WalletYbjModel.h"
#import "WalletHomeVC.h"
#import "WalletYbjBottomBar.h"
static NSString *cellID = @"WalletYbjCell";

@implementation WalletYbjTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerNib:[UINib nibWithNibName:@"WalletYbjCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
        
        //注册通知
        [ZYNSNotificationCenter addObserver:self selector:@selector(selectCellAction:) name:WalletYbjSelectNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [ZYNSNotificationCenter removeObserver:self];
    
    DDLog(@"%@已经被移除", [self class]);
}


- (NSMutableDictionary *)selectDic
{
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    return _selectDic;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count) {
        return self.dataArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletYbjCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.walletYbjModel = self.dataArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WalletYbjCellH;
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


#pragma mark - 点击事件
- (void)selectCellAction:(NSNotification *)noti
{
    WalletYbjCell *cell = (WalletYbjCell *)noti.object;
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    NSString *key = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    //1.需要修改model的yes或者no值
    WalletYbjModel *model = self.dataArr[indexPath.row];
    model.status = cell.selectButton.selected == YES? 3:0;
    
    //2.增加或者删除key
    if (cell.selectButton.selected == YES) {//选中
        //赋值
        [self.selectDic setValue:cell.totalMoney forKey:key];
    }else{//取消
        [self.selectDic removeObjectForKey:key];
    }
    
    //3.判断是否有key来设置颜色
    WalletHomeVC *homeVC = (WalletHomeVC *)self.viewController;
    [homeVC.ybjBottomBar changeUIWithDic:self.selectDic];
}

@end
