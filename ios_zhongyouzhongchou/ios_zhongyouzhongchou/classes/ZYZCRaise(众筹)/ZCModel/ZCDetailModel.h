//
//  ZCDetailModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@class ZCDetailProductModel,ReportModel;

@interface ZCDetailModel : NSObject

@property (nonatomic, copy   ) NSString *code;
@property (nonatomic, strong )ZCDetailProductModel *detailProductModel;

@end

@interface ZCDetailProductModel : NSObject

@property (nonatomic, copy  ) NSString *cover;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, copy  ) NSString *productVoice;
@property (nonatomic, assign) float     productVoiceLen;
@property (nonatomic, copy  ) NSString *productVideo;
@property (nonatomic, copy  ) NSString *productVideoImg;
@property (nonatomic, copy  ) NSString *dest;
@property (nonatomic, strong) NSNumber *Friend;
@property (nonatomic, strong) NSNumber *friendsCount;//收藏／推荐个数
@property (nonatomic, strong) NSNumber *mySelf;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *spell_buy_price;
@property (nonatomic, copy  ) NSString *spell_end_time;//众筹截止时间
@property (nonatomic, copy  ) NSString *start_time;//旅行开始时间
@property (nonatomic, copy  ) NSString *end_time;//旅行结束时间
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *descImgs;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray  *schedule;

@property (nonatomic, strong) NSArray  *report;

@property (nonatomic, assign) CGFloat introFirstCellHeight;
@property (nonatomic, assign) CGFloat returnFirtCellHeight;


@end

@interface ReportModel : NSObject

@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, copy  ) NSString *spellVoice;
@property (nonatomic, assign) float    spellVoiceLen;
@property (nonatomic, copy  ) NSString *spellVideo;
@property (nonatomic, copy  ) NSString *spellVideoImg;
@property (nonatomic, copy  ) NSString *descImgs;
@property (nonatomic, strong) NSNumber *people;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *reportId;
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSNumber *sumPeople;
@property (nonatomic, strong) NSNumber *sumPrice;
@property (nonatomic, strong) NSArray  *users;

@end









