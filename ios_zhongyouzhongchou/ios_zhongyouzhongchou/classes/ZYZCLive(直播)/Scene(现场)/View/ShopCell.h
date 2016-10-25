//
//  ShopCell.h
//  瀑布流
//
//  Created by 任玉飞 on 16/7/1.
//  Copyright © 2016年 任玉飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYFootprintListModel;
typedef void(^PlayBtnCallBackBlock)(UIButton *);

@interface ShopCell : UICollectionViewCell
@property (nonatomic, strong) ZYFootprintListModel *model;
/** 播放按钮block */
@property (nonatomic, copy  ) PlayBtnCallBackBlock playBlock;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
