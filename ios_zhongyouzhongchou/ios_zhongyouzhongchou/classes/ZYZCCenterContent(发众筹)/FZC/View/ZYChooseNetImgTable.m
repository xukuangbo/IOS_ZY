//
//  ZYChooseNetImgTable.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYChooseNetImgTable.h"

@interface ZYChooseNetImgTable ()
@property (nonatomic, assign) CGFloat oldY;
@property (nonatomic, strong) ZYImageModel *preImgModel;
@end

@implementation ZYChooseNetImgTable

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
        self.contentInset=UIEdgeInsetsMake(64+40, 0, 49, 0) ;
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count*2+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%2) {
        ZYChooseNetImgCell *imgCell=(ZYChooseNetImgCell *)[ZYChooseNetImgCell customTableView:tableView cellWithIdentifier:@"imgCell" andCellClass:[ZYChooseNetImgCell class]];
        imgCell.imageModel=self.dataArr[(indexPath.row-1)/2];
        return imgCell;
    }
    else
    {
        UITableViewCell *normalCell=[ZYZCBaseTableViewCell createNormalCell];
        normalCell.contentView.backgroundColor=[UIColor whiteColor];
        return normalCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        return NET_IMG_CELL_HEIGHT;
    }
    return KEDGE_DISTANCE;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2)
    {
        if (_preImgModel) {
            _preImgModel.markHidden=YES;
        }
        ZYImageModel *imgModel=self.dataArr[indexPath.row/2];
        imgModel.markHidden=NO;
        _preImgModel=imgModel;
        
        if (_chooseImgBlock) {
            _chooseImgBlock(_preImgModel);
        }
        [self reloadData];
    }
}

#pragma mark --- 置顶按钮状态变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self) {
        CGFloat offSetY=scrollView.contentOffset.y;
        //        NSLog(@"offSetY:%.2f",offSetY);
        if (self.scrollDidScrollBlock) {
            self.scrollDidScrollBlock(offSetY);
        }
    }
    
    if (scrollView ==self) {
        if (self.contentOffset.y > _oldY) {
            // 上滑
            if (_scrollUpBlock) {
                _scrollUpBlock(self.contentOffset.y);
            }
        }
        else{
            // 下滑
            if (_scrollDownBlock) {
                _scrollDownBlock(self.contentOffset.y);
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    _oldY = self.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollEndBlock) {
        _scrollEndBlock(self.contentOffset.y);
    }
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
}


@end
