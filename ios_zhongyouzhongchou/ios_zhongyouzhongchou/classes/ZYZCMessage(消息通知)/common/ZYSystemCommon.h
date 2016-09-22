//
//  ZYSystemCommon.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYLiveListModel;
typedef void (^GetLiveDataSuccess)(ZYLiveListModel *liveModel);

@interface ZYSystemCommon : NSObject
- (void)cleanNewMessageRedDot:(NSString *)systemID;

- (void)getLiveContent:(NSDictionary *)parameters;
@property (nonatomic, copy) GetLiveDataSuccess getLiveDataSuccess;//评论成功后需要的操作

@end
