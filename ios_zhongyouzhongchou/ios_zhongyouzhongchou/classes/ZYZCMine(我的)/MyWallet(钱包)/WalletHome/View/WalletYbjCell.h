//
//  WalletYbjCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletYbjModel;
typedef void(^SelctBlock)();
#define WalletYbjCellH ((KSCREEN_W - 20) * 9 / 16 + 80)


@interface WalletYbjCell : UITableViewCell

@property (nonatomic, strong) WalletYbjModel *walletYbjModel;

@property (nonatomic, copy) SelctBlock selectBlock;
@end
