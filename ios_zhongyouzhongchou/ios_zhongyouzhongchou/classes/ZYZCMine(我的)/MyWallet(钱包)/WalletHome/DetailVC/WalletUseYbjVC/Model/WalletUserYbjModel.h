//
//  WalletUserYbjModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletUserYbjModel : NSObject
//productDest = "[\"\U676d\U5dde\",\"\U5b89\U7279\U536b\U666e\",\"\U963f\U514b\U96f7\U91cc\",\"\U5723\U5f7c\U5f97\U5821\"]";
@property (nonatomic, copy) NSString *productDest;
//productEndTime = "2016-11-14";
@property (nonatomic, copy) NSString *productEndTime;
//productId = 146;
@property (nonatomic, assign) NSInteger productId;
//productPrice = 100;预筹
@property (nonatomic, assign) NSInteger productPrice;
//productTitle = "\U9b3c\U8650";
@property (nonatomic, copy) NSString *productTitle;
//productTotles = 0;已经筹集
@property (nonatomic, assign) NSInteger productTotles;
@end
