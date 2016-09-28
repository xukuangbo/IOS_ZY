//
//  ZYLiveEndModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYLiveEndModel : NSObject
/** 结束直播的时间 */
@property (nonatomic, copy) NSString *endTime;
/** 本次直播筹集多少钱 */
@property (nonatomic, strong) NSString *totalMoneyCount;
/** 最大的人数 */
@property (nonatomic, assign) NSInteger totalPeopleCount;
/** 在线最大人数 */
@property (nonatomic, assign) NSInteger totalOnlinePeopleNumber;
/**直播用户的唯一标识 */
@property (nonatomic, copy) NSString *streamName;
/**直播的存储 */
@property (nonatomic, copy) NSString *spaceName;


@end
