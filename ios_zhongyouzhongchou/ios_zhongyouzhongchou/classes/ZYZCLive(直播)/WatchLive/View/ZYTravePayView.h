//
//  ZYTravePayView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, kLiveUserContributionStyle) {
    kCommonLiveUserContributionStyle,              // 普通打赏
    kRewardLiveUserContributionStyle,               // 回报打赏
    kTogetherGoLiveUserContributionStyle,           // 一起去打赏
};

@protocol ZYTravePayViewDelegate;
@class ZYJourneyLiveModel;
@interface ZYTravePayView : UIView
+ (instancetype)loadCustumView:(NSMutableArray *)giftImageArray;
@property (strong, nonatomic) IBOutlet UIButton *contributionRecordButton;
@property (strong, nonatomic) IBOutlet UIButton *journeyDetailButton;
@property (weak, nonatomic) id <ZYTravePayViewDelegate> delegate;

@end

@protocol ZYTravePayViewDelegate <NSObject>

@required
// 跳转到支付
- (void)clickTravePayBtnUKey:(NSInteger)moneyNumber style:(kLiveUserContributionStyle)style;
// 跳转到行程详情
- (void)clickJourneyDetailBtnUKey;
@end
