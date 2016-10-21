//
//  WalletSelectToolBar.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WalletSelectToolBarH 44
typedef NS_ENUM(NSInteger, WalletSelectType)
{
    WalletSelectTypeKTX=1,
    WalletSelectTypeYBJ
};


typedef void (^ChangeWalletSelectBlock)(WalletSelectType type) ;
@interface WalletSelectToolBar : UIView

//@property (nonatomic, strong) NSArray         *items;//按钮标题
@property (nonatomic, copy  ) ChangeWalletSelectBlock selectBlock;//可提现旅行预备金切换
@end
