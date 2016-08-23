//
//  ZYImageModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListImgModel;

@interface ListImgModel : NSObject
@property (nonatomic, strong) NSArray *data;
@end


@interface ZYImageModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *descript;
@property (nonatomic, copy  ) NSString *img;//原图
@property (nonatomic, copy  ) NSString *imgMin;//小图
@property (nonatomic, strong) NSNumber *viewspotId;//景点id
@property (nonatomic, assign) BOOL     markHidden;
@end
