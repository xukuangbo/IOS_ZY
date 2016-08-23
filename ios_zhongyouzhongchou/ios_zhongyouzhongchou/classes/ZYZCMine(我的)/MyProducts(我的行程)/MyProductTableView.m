//
//  MyProductTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MyProductTableView.h"
#import "ZYZCOneProductCell.h"
#import "ZCProductDetailController.h"
@interface MyProductTableView ()
@end

@implementation MyProductTableView

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
        self.contentInset=UIEdgeInsetsMake(44+64, 0, 0, 0) ;
//        self.backgroundColor=[UIColor orangeColor];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count*2+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==1) {
        ZYZCOneProductCell *productCell=(ZYZCOneProductCell *)[ZYZCOneProductCell customTableView:tableView cellWithIdentifier:@"myProductCell" andCellClass:[ZYZCOneProductCell class]];
//        NSLog(@"_myProductType:%ld",_myProductType);
        ZCOneModel *oneModel=self.dataArr[(indexPath.row-1)/2];
        if (_myProductType==MyRecommendType) {
            oneModel.productType=ZCListProduct;
        }
        else if (_myProductType==MyPublishType)
        {
            oneModel.productType=MyPublishProduct;
        }
        else if (_myProductType==MyJoinType)
        {
            oneModel.productType=MyJionProduct;
        }
        productCell.oneModel=oneModel;
        return productCell;
    }
    else
    {
        ZYZCOneProductCell *normalCell=(ZYZCOneProductCell *)[ZYZCOneProductCell createNormalCell];
        return normalCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        
        if (_myProductType==MyRecommendType) {
            return PRODUCT_CELL_HEIGHT;
        }
        else
        {
            return MY_ZC_CELL_HEIGHT;
        }
    }
    return KEDGE_DISTANCE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        ZCProductDetailController *detailController=[[ZCProductDetailController alloc]init];
        detailController.hidesBottomBarWhenPushed=YES;
        ZCOneModel  *oneModel=self.dataArr[(indexPath.row-1)/2];
        detailController.oneModel=oneModel;
        detailController.productId=oneModel.product.productId;
        detailController.detailProductType=_myProductType==MyPublishType?MineDetailProduct:PersonDetailProduct;
        detailController.fromProductType=oneModel.productType;
        [self.viewController.navigationController pushViewController:detailController animated:YES];
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


@end
