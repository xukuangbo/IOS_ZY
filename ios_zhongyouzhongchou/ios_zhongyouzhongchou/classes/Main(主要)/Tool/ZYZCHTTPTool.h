//
//  HTHTTPTool.h
//  ios-kuaihaitao
//
//  Created by liuliang on 16/1/28.
//  Copyright © 2016年 pqh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessGetBlock)(id result,BOOL isSuccess);
typedef void(^FailBlock)(id failResult);

@interface ZYZCHTTPTool : NSObject
#pragma mark --- 获取数据
// get请求
+(void)getHttpDataByURL:(NSString *)url withSuccessGetBlock:(SuccessGetBlock)successGet andFailBlock:(FailBlock)fail;
// 统一请求，get传参数
+ (void)GET:(NSString *)URLString parameters:(id)parameters withSuccessGetBlock:(SuccessGetBlock)successGet  andFailBlock:(FailBlock)fail;
// post请求
+(void)postHttpDataWithEncrypt:(BOOL)needLogin andURL:(NSString *)url andParameters:(NSDictionary *)parameters andSuccessGetBlock:(SuccessGetBlock)successGet andFailBlock:(FailBlock)fail;
// 添加head的post请求
+(void)addRongYunHeadPostHttpDataWithURL:(NSString *)url andParameters:(NSDictionary *)parameters andSuccessGetBlock:(SuccessGetBlock)successGet andFailBlock:(FailBlock)fail;

@end
