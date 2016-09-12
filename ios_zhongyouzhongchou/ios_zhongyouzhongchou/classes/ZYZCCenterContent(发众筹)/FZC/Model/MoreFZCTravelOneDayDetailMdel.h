//
//  MoreFZCTravelOneDayDetailMdel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreFZCTravelOneDayDetailMdel : NSObject<MJCoding>
/**
 *  日期
 */
@property (nonatomic, copy  ) NSString *date;

@property (nonatomic, strong) NSNumber *day;
/**
 *  景点描述
 */
@property (nonatomic, copy  ) NSString *siteDes;
/**
 *  交通描述
 */
@property (nonatomic, copy  ) NSString *trafficDes;
/**
 *  住宿描述
 */
@property (nonatomic, copy  ) NSString *liveDes;
/**
 *  餐饮描述
 */
@property (nonatomic, copy  ) NSString *foodDes;
/**
 *  当天旅游景点
 */
@property (nonatomic, strong) NSArray  *sites;
/**
 *  当天旅游的文字描述
 */
@property (nonatomic, strong) NSString *wordDes;
/**
 *  当天旅游图片描述
 */
@property (nonatomic, strong) NSArray  *imgsDes;
/**
 *  当天旅游的语音录入
 */
@property (nonatomic, copy  ) NSString *voiceUrl;

@property (nonatomic, assign) float  voiceLen;

/**
 *  当天旅游视屏录入
 */
@property (nonatomic, copy  ) NSString *movieUrl;

/**
 *  当天旅游视屏第一帧
 */
@property (nonatomic, copy  ) NSString *movieImg;

/**
 *  图片url（多个图片以“,”分隔）
 */
@property (nonatomic, copy  ) NSString *imgUrlStr;


@property (nonatomic, assign) float cellHeight;

@end
