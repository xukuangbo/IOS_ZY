//
//  WaterFlowLayout.h
//  瀑布流
//
//  Created by 任玉飞 on 16/6/30.
//  Copyright © 2016年 任玉飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>

@required
/* 通过cell的宽度计算每个cell的高度 */
- (CGFloat)WaterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/* 列数 */
- (CGFloat)columnCountInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
/* 每一列之间的间距 */
- (CGFloat)columnMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
/* 每一行之间的间距 */
- (CGFloat)rowMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
/* 边缘间距 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;

@end
@interface WaterFlowLayout : UICollectionViewLayout
@property (nonatomic ,weak) id<WaterFlowLayoutDelegate> delegate;
@end
