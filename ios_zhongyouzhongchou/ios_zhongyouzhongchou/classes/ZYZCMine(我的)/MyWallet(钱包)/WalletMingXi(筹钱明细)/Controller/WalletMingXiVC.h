//
//  WalletMingXiVC.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

@interface WalletMingXiVC : ZYZCBaseViewController

@property (nonatomic, strong) NSNumber *productId;

@property (nonatomic, copy) NSString *spaceName;

@property (nonatomic, copy) NSString *streamName;

- initWIthProductId:(NSNumber *)productId;

- initWIthYbjSpaceName:(NSString *)spaceName StreamName:(NSString *)streamName;
@end
