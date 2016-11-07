//
//  WalletHeadView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletHeadModel;
#define WalletHeadViewH  208

@interface WalletHeadView : UIView

@property (nonatomic, strong) WalletHeadModel *model;

-(void)addFXBlurView;
@end
