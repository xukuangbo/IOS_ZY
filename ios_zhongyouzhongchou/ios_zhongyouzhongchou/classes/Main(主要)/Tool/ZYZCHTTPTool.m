//
//  HTHTTPTool.m
//  ios-kuaihaitao
//
//  Created by liuliang on 16/1/28.
//  Copyright © 2016年 pqh. All rights reserved.
//

#import "ZYZCHTTPTool.h"
#import "LoginJudgeTool.h"
#import <CommonCrypto/CommonDigest.h>
@implementation ZYZCHTTPTool

#pragma mark --- get请求
+(void)getHttpDataByURL:(NSString *)url withSuccessGetBlock:(SuccessGetBlock)successGet  andFailBlock:(FailBlock)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

    NSString *newUrl=url;
    if ([url hasSuffix:@".action"]) {
        newUrl=[url stringByAppendingString:@"?from=ios"];
    }
    else
    {
        newUrl=[url stringByAppendingString:@"&from=ios"];
    }
    NSRange range=[url rangeOfString:@"userId"];
    if (!range.length) {
        newUrl=[newUrl stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[ZYZCAccountTool getUserId]]];
    }
    DDLog(@"newGetUrl:%@",newUrl);
    
    [manager GET:newUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (responseObject[@"code"]) {
            if ([responseObject[@"code"] isEqual:@0]) {
                successGet(responseObject,YES);
            }
            else
            {
                successGet(responseObject,NO);
            }
        }
        else
        {
            successGet(responseObject,YES);
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        fail(error.localizedDescription);
    }];
}

#pragma mark --- post请求
+(void)postHttpDataWithEncrypt:(BOOL)needLogin andURL:(NSString *)url andParameters:(NSDictionary *)parameters andSuccessGetBlock:(SuccessGetBlock)successGet andFailBlock:(FailBlock)fail
{
    //转换成json
//    NSData *data = [NSJSONSerialization dataWithJSONObject :parameters options : NSJSONWritingPrettyPrinted error:NULL];
//    
//    NSString *jsonStr = [[ NSString alloc ] initWithData :data encoding : NSUTF8StringEncoding];
//    
    
    NSMutableDictionary *newParameters=[NSMutableDictionary dictionaryWithDictionary:parameters];
    if (needLogin)
    {
        //此处添加需登录的操作
        NSDictionary *entryptParams=[self encryptParams];
        if (!entryptParams) {
            return;
        }
        [newParameters addEntriesFromDictionary:entryptParams];
    }
    else
    {
        //此处添加不需要登录的操作
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    DDLog(@"newParameters:%@",newParameters);
    
    NSString *newUrl=[url stringByAppendingString:[NSString stringWithFormat:@"?userId=%@&from=ios",[ZYZCAccountTool getUserId]]];
    DDLog(@"newPostUrl:%@",newUrl);
    [manager POST:newUrl parameters:newParameters progress:^(NSProgress * _Nonnull uploadProgress)
    {
        
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (responseObject[@"code"]) {
            if ([responseObject[@"code"] isEqual:@0]) {
                successGet(responseObject,YES);
            }
            else
            {
                successGet(responseObject,NO);
            }
        }
        else
        {
            successGet(responseObject,YES);
        }
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        fail(error.localizedDescription);
    }];
}

#pragma mark --- 需要登录权限才能调用的接口
+(NSDictionary *)loginPortNeedEncrypt
{
    NSMutableDictionary *strDic=[NSMutableDictionary dictionary];
    
    return strDic;
}

#pragma mark --- 不需要登录权限调用的接口
+(NSDictionary *)noneLoginPortNeedEncrypt
{
    NSMutableDictionary *strDic=[NSMutableDictionary dictionary];
    return strDic;
}

#pragma mark --- 加密参数
+(NSDictionary *)encryptParams
{
//    signature =Md5( timestamp+fix+ nonceStr+fix+ scret+fix+datatime)
    
    ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
    
    if (![ZYZCAccountTool getUserScret]) {
        [ZYZCAccountTool deleteAccount];
        [LoginJudgeTool judgeLogin];
        return nil;
    }
    
    NSMutableDictionary *strDic=[NSMutableDictionary dictionary];
    //时间戳
    NSString *timeStamp=[self getTimeStamp];
    DDLog(@"timeStamp:%@",timeStamp);
    DDLog(@"time:%@",[ZYZCTool turnTimeStampToDate:timeStamp]);
    [strDic setObject:timeStamp forKey:@"timestamp"];
    //随机数
    NSString *nonceStr=[NSString stringWithFormat:@"%d",100000+ arc4random_uniform(899999)];
    DDLog(@"nonceStr:%@",nonceStr);
    [strDic setObject:nonceStr forKey:@"nonceStr"];
    //fix
    NSArray *FIX =@[@"<",@">",@"(",@")",@"|",@"_",@"{",@"}",@"*",@"!"];
    int fixNum=arc4random_uniform((int)FIX.count-1);
    NSString *fix=FIX[fixNum];
    DDLog(@"fix:%@,fixNum:%d",fix,fixNum);
    [strDic setObject:[NSNumber numberWithInt:fixNum] forKey:@"fix"];
    //signature
    NSString *signature=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",timeStamp,fix,nonceStr,fix,[ZYZCAccountTool getUserScret],fix,[self getTime]];
    DDLog(@"signature:%@",signature);
    NSString *signature_md5=[self turnStrToMD5:signature];
     DDLog(@"signature_md5:%@",signature_md5);
    [strDic setObject:signature_md5 forKey:@"signature"];

    if ([ZYZCAccountTool getUserId]) {

        [strDic setObject:[ZYZCAccountTool getUserId] forKey:@"userId"];
    }else{
        
    }
    
    return strDic;
}

#pragma mark --- 将字符串转换成md5
+(NSString *)turnStrToMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    NSMutableString *newStr=[NSMutableString string];
    for (int i=0; i<16; i++) {
        [newStr appendString:[NSString stringWithFormat:@"%02x",result[i]]];
    }
    return newStr;
}

#pragma mark --- 获取时间戳
+(NSString *)getTimeStamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970];//(10位)
    NSString *timeStamp = [NSString stringWithFormat:@"%.f", time *1000];
    return timeStamp;
}


#pragma mark --- 获取本地时间
+(NSString *)getTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:[NSDate date]];
}

@end
