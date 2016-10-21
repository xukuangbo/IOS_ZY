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


/**
 *  发布类型
 */
@property (nonatomic, assign) FootprintType footprintType;

/**
 *  手机相册图片
 */
@property (nonatomic, strong) NSArray *images;
/**
 *  视频第一帧
 */
@property (nonatomic, copy  ) NSString *thumbnailPath;
/**
 *  视频路径
 */
@property (nonatomic, copy  ) NSString *videoPath;

//视频图片长宽比
@property (nonatomic, assign) CGFloat  videoimgsize;

//视频时长
@property (nonatomic, assign) NSInteger videoLength;

@end
