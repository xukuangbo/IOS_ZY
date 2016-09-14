//
//  FZCReplaceDataKeys.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScheduleData,ReportData;

@interface FZCReplaceDataKeys : NSObject<MJCoding>
@property (nonatomic, copy  ) NSString *userId;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *spell_buy_price;
@property (nonatomic, strong) NSArray  *productCountryId;
@property (nonatomic, strong) NSArray  *dest;
@property (nonatomic, copy  ) NSString *start_time;
@property (nonatomic, copy  ) NSString *end_time;
@property (nonatomic, copy  ) NSString *spell_end_time;
@property (nonatomic, strong) NSNumber *people;
@property (nonatomic, copy  ) NSString *cover;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, copy  ) NSString *voice;
@property (nonatomic, assign) float    voiceLen;
@property (nonatomic, copy  ) NSString *video;
@property (nonatomic, copy  ) NSString *videoImg;
@property (nonatomic, copy  ) NSString *descImgs;
@property (nonatomic, strong) NSArray  *schedule;
@property (nonatomic, strong) NSMutableArray  *report;

/**
 *  重新定义参数名
 */
-(void)replaceDataKeysBySubFileName:(NSString *)myZhouChouMarkName;

@end


@interface ScheduleData : NSObject<MJCoding>
@property (nonatomic, copy  ) NSString *day;
@property (nonatomic, copy  ) NSString *spot;
@property (nonatomic, strong) NSArray  *spots;
@property (nonatomic, copy  ) NSString *trans;
@property (nonatomic, copy  ) NSString *live;
@property (nonatomic, copy  ) NSString *food;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, copy  ) NSString *voice;
@property (nonatomic, assign) float    voiceLen;
@property (nonatomic, copy  ) NSString *video;
@property (nonatomic, copy  ) NSString *videoImg;
@property (nonatomic, copy  ) NSString *descImgs;


@end

@interface ReportData : NSObject<MJCoding>
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSNumber *people;
@property (nonatomic, copy  ) NSString *price;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, copy  ) NSString *voice;
@property (nonatomic, assign) float    voiceLen;
@property (nonatomic, copy  ) NSString *video;
@property (nonatomic, copy  ) NSString *videoUrl;
@property (nonatomic, copy  ) NSString *descImgs;
@end


