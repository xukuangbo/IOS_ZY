//
//  ZYDescImage.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYDescImgModel.h"
@interface ZYDescImage : UIImageView

@property (nonatomic, strong) ZYDescImgModel *imgModel;
///**
// *  是否是本地图片
// */
//@property (nonatomic, assign) BOOL     isLocalImage;
///**
// *  本地图片的path
// */
//@property (nonatomic, copy  ) NSString *filePath;
///**
// *  网络图片的url
// */
//@property (nonatomic, copy  ) NSString *minUrl;
//@property (nonatomic, copy  ) NSString *maxUrl;

@end
