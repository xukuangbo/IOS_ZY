//
//  MyProductController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "ProductTableView.h"
@interface MyProductController : ZYZCBaseViewController
//我的众筹项目类型
@property (nonatomic, assign) K_MyProductType      myProductType;

//删除项目
-(void)removeDataByProductId:(NSNumber *)productId withMyProductType:(K_MyProductType)myProductType;

//刷新table
-(void) reloadTableView;


@end
