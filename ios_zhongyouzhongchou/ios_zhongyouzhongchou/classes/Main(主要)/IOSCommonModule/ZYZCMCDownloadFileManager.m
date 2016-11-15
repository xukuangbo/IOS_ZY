//
//  DownloadFile.m
//  Pods
//
//  Created by 李灿 on 16/11/04.
//
//

#import "ZYZCMCDownloadFileManager.h"
#import "AFNetworking.h"

@implementation ZYZCMCDownloadFileManager
- (void)downloadRecordFile:(NSURL *)fileUrl price:(NSString *)price
{
    NSString *urlPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[fileUrl.path substringFromIndex:[fileUrl.path length] - 5]];
    NSArray *blockParArray = [NSArray arrayWithObjects:urlPath, price,nil];
    // 判断文件是否本地存在
    if ([self is_file_exist:urlPath]) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.success) {
                self.success(blockParArray);
            }
        });
        return;
    }
    WEAKSELF
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileUrl];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    //创建下载任务
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        NSLog(@"downloadProgress%@", downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载complectedHandler");
        NSString *path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),response.suggestedFilename];
        if (error) {
            NSLog(@"下载complectedHandler Error");
            [response.suggestedFilename writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [weakSelf remove_file_exist:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.failureError) {
                    weakSelf.failureError();
                }
            });
        } else {
            NSArray *blockParArray = [NSArray arrayWithObjects:path, price,nil];

            if (weakSelf.success) {
                NSLog(@"下载complectedHandler Success");
                weakSelf.success(blockParArray);
            }
        }
    }];
    //开始任务
    [downloadTask resume];
//    // 利用KVO监听下载变化值
//    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (BOOL)isExistedWithFileUrl:(NSURL *)fileUrl {
    NSString *urlPath=[NSString stringWithFormat:@"%@/Documents%@",NSHomeDirectory(),fileUrl.path];
    
    if ([self is_file_exist:urlPath]) {
        return YES;
    }
    return NO;
}

//#pragma mark - KVO
//// 监测下载进度
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    float fractionCompleted = [[object valueForKey:@"fractionCompleted"] floatValue];
//    NSLog(@"下载进度为 = %f%%",fractionCompleted*100);
//    if ([keyPath isEqualToString:@"fractionCompleted"]) {
//        NSProgress *progress = (NSProgress *)object;
//        NSLog(@"Progress… %f", progress.fractionCompleted);
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.fractionCompleted) {
//            self.fractionCompleted(fractionCompleted);
//        }
//    });
//    
//}


#pragma mark 
// 判断文件是否存在
-(BOOL)is_file_exist:(NSString *)fileName
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:fileName];
}

-(BOOL)remove_file_exist:(NSString *)fileName
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager removeItemAtPath:fileName error:nil];
}
@end
