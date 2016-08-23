//
//  ZYDescImgModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYDescImgModel : NSObject

/**
 *  是否是本地图片
 */
@property (nonatomic, assign) BOOL     isLocalImage;
/**
 *  本地图片的path
 */
@property (nonatomic, copy  ) NSString *filePath;

@property (nonatomic, strong) UIImage  *image;
/**
 *  网络图片的url
 */
@property (nonatomic, copy  ) NSString *minUrl;

@property (nonatomic, copy  ) NSString *maxUrl;

@end
