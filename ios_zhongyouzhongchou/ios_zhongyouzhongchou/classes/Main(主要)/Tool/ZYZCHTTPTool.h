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
//get请求
+(void)getHttpDataByURL:(NSString *)url withSuccessGetBlock:(SuccessGetBlock)successGet andFailBlock:(FailBlock)fail;
//post请求
+(void)postHttpDataWithEncrypt:(BOOL)needLogin andURL:(NSString *)url andParameters:(NSDictionary *)parameters andSuccessGetBlock:(SuccessGetBlock)successGet andFailBlock:(FailBlock)fail;

#pragma mark --- 加密
//需要登录权限才能调用的接口
+(NSDictionary *)loginPortNeedEncrypt;
//不需要登录权限才能调用的接口
+(NSDictionary *)noneLoginPortNeedEncrypt;
//将字符串转换成md5
+(NSString *)turnStrToMD5:(NSString *)str;
//获取本地时间
+(NSString *)getTime ;
@end
