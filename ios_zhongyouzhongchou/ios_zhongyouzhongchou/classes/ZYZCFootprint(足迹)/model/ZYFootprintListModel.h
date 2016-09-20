//
//  ZYFootprintListModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

typedef NS_ENUM(NSInteger, FootprintCellType)
{
    HeadCell=1,
    BodyCell,
    FootCell,
    CompleteCell
};

#import <Foundation/Foundation.h>

@class ZYFootprintDataModel;

@interface ZYFootprintDataModel : NSObject
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy  ) NSString *errorMsg;

@end


@interface ZYFootprintListModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger footprintType;

@property (nonatomic, copy  ) NSString  *creattime;

@property (nonatomic, copy  ) NSString *content;

@property (nonatomic, copy  ) NSString *pics;

@property (nonatomic, copy  ) NSString *video;

@property (nonatomic, copy  ) NSString *videoimg;

@property (nonatomic, copy  ) NSString *gpsData;//jsonStr

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *productId;

@property (nonatomic, assign) FootprintCellType cellType;//头部，中部，尾部

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL    showDate;

@property (nonatomic, assign) NSInteger totalMonth;

@end
