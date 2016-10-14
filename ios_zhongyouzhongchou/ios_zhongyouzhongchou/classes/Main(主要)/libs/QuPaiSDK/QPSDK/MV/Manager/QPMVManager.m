//
//  QPMVManager.m
//  DevQPSDKCore
//
//  Created by Worthy on 16/9/18.
//  Copyright © 2016年 LYZ. All rights reserved.
//

#import "QPMVManager.h"
#import "AFNetworking.h"
#import "QPEffectMV.h"

@interface QPMVManager ()
@property (nonatomic, assign) NSInteger cursor;
@end

@implementation QPMVManager

- (void)fetchMVResourcesWithSuccess:(void (^)(NSArray *mvs))success failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@%@", kQPResourceHostUrl, @"api/res/type/3"];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSDictionary *param =@{
                           @"type":@(3),
                           @"cursor":@(_cursor),
                           @"bundleId":bundleId
                           };
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:param error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else {
            NSArray *items = [QPEffectMV arrayOfModelsFromDictionaries:responseObject error:nil];
            success(items);
        }
    }];
    
    [dataTask resume];
}

@end
