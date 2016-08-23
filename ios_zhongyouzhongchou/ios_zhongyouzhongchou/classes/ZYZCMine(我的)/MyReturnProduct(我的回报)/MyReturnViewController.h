//
//  MyReturnViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "ZCListModel.h"
@interface MyReturnViewController : ZYZCBaseViewController

@property (nonatomic, assign) ProductType productType;

/**
 *  删除草稿
 */
-(void)deleteProductFromProductId:(NSNumber *)productId;

@end
