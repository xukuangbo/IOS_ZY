//
//  MyProductViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

#import "MyProductTableView.h"

@interface MyProductViewController : ZYZCBaseViewController

//我的众筹项目类型
@property (nonatomic, assign) MyProductType      myProductType;

//删除项目
-(void)removeDataByProductId:(NSNumber *)productId;
//刷新数据
-(void)reloadData;



@end
