//
//  DownloadFile.h
//  Pods
//
//  Created by 李灿 on 16/11/04.
//
//

#import <Foundation/Foundation.h>
#import "UIProgressView+AFNetworking.h"
@interface ZYZCMCDownloadFileManager : NSObject

// 判断url对应的缓存是否已经存在
- (BOOL)isExistedWithFileUrl:(NSURL *)fileUrl;

// 下载...
- (void)downloadRecordFile:(NSURL *)fileUrl;

@property (copy, nonatomic) void(^failureError)(void);
@property (copy, nonatomic) void(^success)(NSString *);
@property (copy, nonatomic) void(^fractionCompleted)(double);

@end
