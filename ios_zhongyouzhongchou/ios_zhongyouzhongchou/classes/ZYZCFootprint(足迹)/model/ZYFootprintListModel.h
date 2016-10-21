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

typedef NS_ENUM(NSInteger, FootprintListType)
{
    MyFootprintList=1,
    OtherFootprintList,
};

#import <Foundation/Foundation.h>
#import "UserModel.h"
@class ZYFootprintDataModel;

@interface ZYFootprintDataModel : NSObject
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy  ) NSString *errorMsg;

@end


@interface ZYFootprintListModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger footprintType;

@property (nonatomic, copy  ) NSString  *creattime;

@property (nonatomic, copy  ) NSString *content;//文字内容

@property (nonatomic, copy  ) NSString *pics;

@property (nonatomic, copy  ) NSString *video;

@property (nonatomic, copy  ) NSString *videoimg;

@property (nonatomic, assign) NSInteger videosize;//视频时长

@property (nonatomic, assign) CGFloat videoimgsize;//封面长宽比

@property (nonatomic, copy  ) NSString *gpsData;//jsonStr

@property (nonatomic, assign) NSInteger zanTotles;//点赞数

@property (nonatomic, assign) BOOL hasZan;//是否点赞

@property (nonatomic, assign) NSInteger commentTotles;//评论总数

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *productId;

@property (nonatomic, assign) FootprintCellType cellType;//头部，中部，尾部

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL    showDate;

@property (nonatomic, assign) FootprintListType footprintListType;

@property (nonatomic, strong) UserModel  *user;//足迹发起者


@property (nonatomic, assign) NSInteger totalMonth;

@end




