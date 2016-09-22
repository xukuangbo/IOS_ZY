//
//  ZYSupportListModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZYOneSupportModel;

@interface ZYSupportListModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy  ) NSString *errorMsg;

@property (nonatomic,assign) CGFloat cellHeight;

@end


@interface ZYOneSupportModel : NSObject
//userId、userName、realName、faceImg,faceImg64,faceImg132,faceImg640、pid 
@property (nonatomic, strong) NSNumber  *userId;
@property (nonatomic, copy  ) NSString  *userName;
@property (nonatomic, copy  ) NSString  *realName;
@property (nonatomic, copy  ) NSString  *faceImg;
@property (nonatomic, copy  ) NSString  *faceImg64;
@property (nonatomic, copy  ) NSString  *faceImg132;
@property (nonatomic, copy  ) NSString  *faceImg640;
@property (nonatomic, assign) NSInteger pid;


@end
