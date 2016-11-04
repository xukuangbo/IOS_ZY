//
//  WalletYbjSelectXcVC.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

typedef void(^DidChangeProductBlock)(NSInteger);

@interface WalletYbjSelectXcVC : ZYZCBaseViewController

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy) DidChangeProductBlock didChangeProductBlock;
@end
