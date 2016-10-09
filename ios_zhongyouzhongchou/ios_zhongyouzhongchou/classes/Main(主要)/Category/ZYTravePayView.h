//
//  ZYTravePayView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYTravePayViewDelegate;

@interface ZYTravePayView : UIView
+ (instancetype)loadCustumView;
@property (strong, nonatomic) IBOutlet UIButton *playTourRecordButton;
@property (strong, nonatomic) IBOutlet UIButton *journeyDetailButton;
@property (weak, nonatomic) id <ZYTravePayViewDelegate> delegate;

@end

@protocol ZYTravePayViewDelegate <NSObject>

@required
// 跳转到支付
- (void)clickTravePayBtnUKey:(NSInteger)moneyNumber;

@end
