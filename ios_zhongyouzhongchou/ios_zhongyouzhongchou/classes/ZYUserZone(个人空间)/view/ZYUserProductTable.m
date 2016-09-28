//
//  ZYUserProductTable.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYUserProductTable.h"
#import "ZYZCOneProductCell.h"
#import "ZCProductDetailController.h"
@implementation ZYUserProductTable

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count) {
        return self.dataArr.count*2+1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        NSString *cellId=@"productCell";
        ZYZCOneProductCell *productCell=(ZYZCOneProductCell*)[ZYZCOneProductCell customTableView:tableView cellWithIdentifier:cellId andCellClass:[ZYZCOneProductCell class]];
        ZCOneModel *oneModel=self.dataArr[(indexPath.row-1)/2];
        oneModel.productType=ZCListProduct;
        productCell.oneModel=oneModel;
        return productCell;
    }
    else{
        UITableViewCell *cell=[ZYZCOneProductCell createNormalCell];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        return PRODUCT_CELL_HEIGHT;
    }
    else
    {
        return KEDGE_DISTANCE;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        //推出信息详情页
        ZCProductDetailController *personDetailVC=[[ZCProductDetailController alloc]init];
        personDetailVC.hidesBottomBarWhenPushed=YES;
        ZCOneModel *oneModel=self.dataArr[(indexPath.row+1)/2-1];
        personDetailVC.oneModel=oneModel;
        personDetailVC.oneModel.productType=ZCDetailProduct;
        personDetailVC.productId=oneModel.product.productId;
        personDetailVC.detailProductType=PersonDetailProduct;
        [self.viewController.navigationController pushViewController:personDetailVC animated:YES];
    }
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
