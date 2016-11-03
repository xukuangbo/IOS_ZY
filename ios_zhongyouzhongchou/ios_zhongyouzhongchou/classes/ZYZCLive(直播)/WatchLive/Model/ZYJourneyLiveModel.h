//
//  ZYJourneyLiveModel.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/10/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYJourneyLiveModel : NSObject
/**回报金额 */
@property (nonatomic, assign) NSInteger rewardMoney;
/**一起去金额 */
@property (nonatomic, assign) NSInteger togetherGoMoney;
/**行程标题 */
@property (nonatomic, copy) NSString *journeyTitle;

@end
