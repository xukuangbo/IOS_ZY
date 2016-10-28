//
//  WalletKtxCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletKtxModel;
#define WalletKtxCellH ((KSCREEN_W - 20) * 9 / 16 + 80)
@interface WalletKtxCell : UITableViewCell

@property (nonatomic, strong) WalletKtxModel *mineWalletModel;
@end
