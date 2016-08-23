//
//  MinePersonSetUpController.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//#import "ZYZCBaseTableViewController.h"


#import "ZYZCBaseViewController.h"

#import "MinePersonSetUpScrollView.h"
@interface MinePersonSetUpController : ZYZCBaseViewController

@property (nonatomic, assign) BOOL wantFZC;

@property (nonatomic, weak) MinePersonSetUpScrollView *scrollView;
@end
