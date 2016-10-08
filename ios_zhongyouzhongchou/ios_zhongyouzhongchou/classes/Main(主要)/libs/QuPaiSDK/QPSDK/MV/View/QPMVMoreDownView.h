//
//  MVMoreDownView.h
//  qupai
//
//  Created by HZ_qp on 15/11/4.
//  Copyright © 2015年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPEffectMV.h"

@protocol MVMoreDownViewDelegate;

@interface QPMVMoreDownView : UIView

@property (nonatomic, strong) QPEffectMV *effectMV;
@property (nonatomic, weak) id<MVMoreDownViewDelegate> delegate;

@end

@protocol MVMoreDownViewDelegate <NSObject>

- (void)mvMoreDownViewDown:(QPEffectMV *)effectMV;
- (void)mvMoreDownViewUse:(QPEffectMV *)effectMV;
//- (void)mvMoreMvDownlUpVersion:(ShopItem *)shopItem;
@end