//
//  ZYBottomPayView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYBottomPayViewDelegate;
@interface ZYBottomPayView : UIView
+ (instancetype)loadCustumView;
@property (strong, nonatomic) IBOutlet UIView *selectPayView;
@property (weak, nonatomic) id <ZYBottomPayViewDelegate> delegate;

@end

@protocol ZYBottomPayViewDelegate <NSObject>

@required
// 是否要跳转到支付
- (void)clickPayBtnUKey:(NSInteger)moneyNumber;


@end