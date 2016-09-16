//
//  ZYPublishFootprintController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

typedef NS_ENUM(NSInteger, FootprintType)
{
    Footprint_VideoType=1,
    Footprint_AlbumType,
    Footprint_PhotoType
};

@interface ZYPublishFootprintController : ZYZCBaseViewController

//@property (nonatomic, )

@property (nonatomic, assign) FootprintType footprintType;

@property (nonatomic, strong) NSArray *images;


@end
