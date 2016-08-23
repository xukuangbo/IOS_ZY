//
//  WalletMingxiViewModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ViewModelClass.h"

typedef enum : NSUInteger {
    WalletMingXiRefreshTypeDefault,
    WalletMingXiRefreshTypeHead,
    WalletMingXiRefreshTypeFoot
} WalletMingXiRefreshType;

@interface WalletMingxiViewModel : ViewModelClass


@property (nonatomic, assign) WalletMingXiRefreshType refreshType ;

/**
 *  上啦刷新请求钱包名字页面数据
 */
- (void)footRefreshDataWithProductID:(NSNumber *)productID pageNo:(NSInteger )pageNO;

- (void)headRefreshDataWithProductID:(NSNumber *)productID;

@end
