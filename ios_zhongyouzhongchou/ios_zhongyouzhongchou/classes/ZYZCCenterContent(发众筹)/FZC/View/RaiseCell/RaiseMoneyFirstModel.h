//
//  RaiseMoneyFirstModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaiseMoneyFirstModel : NSObject
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) BOOL openButtonSelected;
@property (nonatomic, assign) CGFloat bgImageHeight;
@property (nonatomic, assign) CGFloat detailViewHeight;
@property (nonatomic, assign) CGFloat moneyTextfliedBottom;
@property (nonatomic, copy) NSString *totalMoney;
//@property (nonatomic, copy) NSString *sightMoney;
//@property (nonatomic, copy) NSString *transMoney;
//@property (nonatomic, copy) NSString *liveMoney;
//@property (nonatomic, copy) NSString *eatMoney;



@property (nonatomic, assign) BOOL sightTextfiledHidden;
@property (nonatomic, assign) BOOL transportTextfiledHidden;
@property (nonatomic, assign) BOOL liveTextfiledHidden;
@property (nonatomic, assign) BOOL eatTextfiledHidden;
@end
