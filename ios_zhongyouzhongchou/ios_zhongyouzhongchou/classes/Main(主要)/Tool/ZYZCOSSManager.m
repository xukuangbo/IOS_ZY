//
//  ZYZCOSSManager.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCOSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "ZYZCTool+getLocalTime.h"

NSString * const AccessKey = @"ZEoTY0iktlhynuSO";
NSString * const SecretKey = @"GQkbvA5jPY3gCFKjXQg3Pvw6DZQulM";
NSString * const endPoint  = @"http://oss-cn-hangzhou.aliyuncs.com";
NSString * const multipartUploadKey = @"multipartUploadObject"; 
NSString * const _bucketName = @"zyzc-bucket01";
NSString * const _bucketName_voucher = @"zyzc-voucher";

static ZYZCOSSManager *ossManager;

OSSClient * client;



@implementation ZYZCOSSManager


+(instancetype )defaultOSSManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (!ossManager) {
            ossManager=[[ZYZCOSSManager alloc]init];
        }
    });
    
    return ossManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [OSSLog enableLog];
        [self initOSS];
    }
    return self;
}
#pragma mark --- 初始化OSS
-(void)initOSS
{
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey
                                secretKey:SecretKey];
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 1; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 10; // 网络请求的超时时间
    conf.timeoutIntervalForResource = 30 * 60 * 60; // 允许资源传输的最长时间
    
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
}

#pragma mark --- 创建存储空间
- (void)createBucket {
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = _bucketName;
    create.xOssACL = @"public-read";
    create.location = @"oss-cn-hangzhou";
    
    OSSTask * createTask = [client createBucket:create];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
//            NSLog(@"create bucket success!");
        } else {
//            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark --- 删除存储空间
- (void)deleteBucket {
    OSSDeleteBucketRequest * delete = [OSSDeleteBucketRequest new];
    delete.bucketName = _bucketName;
    
    OSSTask * deleteTask = [client deleteBucket:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
//            NSLog(@"delete bucket success!");
        } else {
//            NSLog(@"delete bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark --- 获取存储空间中的对象
- (void)listObjectsInBucketByPrefix:(NSString *)prefix{
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = _bucketName;
    getBucket.delimiter = @"";
    getBucket.prefix = prefix;

    OSSTask * getBucketTask = [client getBucket:getBucket];
    
    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
//            OSSGetBucketResult * result = task.result;
//            NSLog(@"get bucket success!");
//            NSArray *contents=result.contents;
//            NSLog(@"contents:%@",contents);
//            for (NSDictionary * objectInfo in result.contents) {
//                NSLog(@"list object: %@", objectInfo);
//            }
        } else {
//            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark --- 同步上传对象
- (BOOL )uploadObjectSyncByFileName:(NSString *)fileName andFilePath:(NSString *)filePath {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    NSString *userId=[ZYZCAccountTool getUserId];
    put.bucketName = _bucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",userId,fileName];
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    
    // optional fields
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
//        NSLog(@"upload object success!");
        return YES;
        
    } else {
//        NSLog(@"upload object failed, error: %@" , putTask.error);
        return NO;
       
    }
}


#pragma mark --- 异步上传对象
- (void )uploadObjectAsyncByFileName:(NSString *)fileName andFilePath:(NSString *)filePath withSuccessUpload:(GetSuccessBlock )successUpload andFailUpload:(GetFailBlock )failUpload{
      //获取文件名
    NSString *userId=[ZYZCAccountTool getUserId];
//    NSLog(@"userId:%@",userId);
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = _bucketName;
    put.objectKey  = [NSString stringWithFormat:@"%@/%@",userId,fileName];
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            if (successUpload) {
                successUpload();
            }
        } else {
            if (failUpload) {
                failUpload();
            }
        }
        return nil;
    }];
    [putTask waitUntilFinished];
}

#pragma mark --- 异步下载数据
- (void)downloadObjectAsyncByFileName:(NSString *)fileName {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = _bucketName;
    request.objectKey =   fileName;
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSURL *dataUrl=[NSURL fileURLWithPath:[tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"downloadfile/%@",request.objectKey]]];
     request.downloadToFileURL = dataUrl;
//    NSLog(@"dataUrl:%@",dataUrl);
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
//            NSLog(@"download object success!");
//            OSSGetObjectResult * getResult = task.result;
//            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
//            NSData *data=[NSData dataWithContentsOfURL:dataUrl];
//            NSLog(@"data.length:%zd",data.length);
            
        } else {
//            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
    
    [getTask waitUntilFinished];
}

#pragma mark --- 删除文件
- (BOOL )deleteObjectByFileName:(NSString *)fileName {
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = _bucketName;
    delete.objectKey = fileName;
    OSSTask * deleteTask = [client deleteObject:delete];
    
//    [deleteTask continueWithBlock:^id(OSSTask *task) {
//        if (!task.error) {
//            if (successDeleteOne) {
//                successDeleteOne();
//            }
//        } else {
//            if (failDeleteOne) {
//                failDeleteOne();
//            }
//        }
//        return nil;
//    }];
    [deleteTask waitUntilFinished];
    if (!deleteTask.error) {
//        NSLog(@"delete object success!");
        return YES;
        
    } else {
//        NSLog(@"delete object failed, error: %@" , deleteTask.error);
        return NO;
        
    }
}

#pragma mark --- 删除某文件下的所有子文件
-(void)deleteObjectsByPrefix:(NSString *)prefix andSuccessUpload:(GetSuccessBlock )successDelete andFailUpload:(GetFailBlock )failDelete
{
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = _bucketName;
    getBucket.delimiter = @"";
    getBucket.prefix = prefix;
    
    OSSTask * getBucketTask = [client getBucket:getBucket];
    
    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
//            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSString *objectKey=objectInfo[@"Key"];
                BOOL deleteSuccess=[self deleteObjectByFileName:objectKey];
                if (!deleteSuccess) {
                    
                    if (failDelete)
                    {
                        failDelete();
                    }
                    break;
                }
            }
            if (successDelete) {
                
                successDelete();
            }
        }
        else{
//            NSLog(@"get bucket failed, error: %@", task.error);
            if (failDelete) {
                failDelete();
            }
        }
        return nil;
    }];

}



#pragma mark --- 同步上传voucher对象

- (BOOL )uploadVoucherSyncByFileName:(NSString *)fileName andFilePath:(NSString *)filePath {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = _bucketName_voucher;
    put.objectKey = fileName;
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    
    // optional fields
    //    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    //        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    //    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
//        NSLog(@"upload object success!");
        return YES;
        
    } else {
//        NSLog(@"upload object failed, error: %@" , putTask.error);
        return NO;
        
    }
}

#pragma mark --- 同步上传用户头像
- (BOOL )uploadIconSyncByFileName:(NSString *)fileName andFilePath:(NSString *)filePath {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = _bucketName;
    put.objectKey = fileName;
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    
    // optional fields
    //    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    //        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    //    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
//        NSLog(@"upload object success!");
        return YES;
        
    } else {
//        NSLog(@"upload object failed, error: %@" , putTask.error);
        return NO;
    }
}


@end
