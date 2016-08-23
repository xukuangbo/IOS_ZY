//
//  MineWalletTableViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineWalletModel;
#define WalletCellRowHeight 100
@interface MineWalletTableViewCell : UITableViewCell

@property (nonatomic, strong) MineWalletModel *mineWalletModel;
@end
