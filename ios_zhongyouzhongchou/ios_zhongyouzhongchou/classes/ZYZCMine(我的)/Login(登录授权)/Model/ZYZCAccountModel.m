//
//  ZYZCAccountModel.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCAccountModel.h"
#import "ZYZCAccountTool.h"
@implementation ZYZCAccountModel
MJCodingImplementation

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"access_token":@"accessToken",@"openidapp":@"openid",@"openid":@"unionid"};
}

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    ZYZCAccountModel *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.unionid = dict[@"unionid"];
    account.expires_in = dict[@"expires_in"];
    // 获得账号存储的时间（accessToken的产生时间）
    account.created_time = [NSDate date];
    return account;
}


/**
 *  获取微信的个人信息，再存到本地
 */
+ (instancetype)accountWithPersonalMessage:(NSDictionary *)dict
{
    ZYZCAccountModel *accountModel = [ZYZCAccountTool account];
    /**
     *  openid
     */
    accountModel.openid = dict[@"openid"];
    
    /** 用户的昵称 */
    accountModel.nickname = dict[@"nickname"];
    /**
     *  性别
     */
    accountModel.sex = dict[@"sex"];
    /**
     *  语言
     */
    accountModel.language = dict[@"language"];
    /**
     *  城市
     */
    accountModel.city = dict[@"city"];
    /**
     *  省
     */
    accountModel.province = dict[@"province"];
    /**
     *  国家
     */
    accountModel.country = dict[@"country"];
    /**
     *  头像
     */
    accountModel.headimgurl = dict[@"headimgurl"];
    
    return accountModel;
    
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.access_token forKey:@"access_token"];
//    [encoder encodeObject:self.access_token forKey:@"refresh_token"];
//    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
//    [encoder encodeObject:self.unionid forKey:@"unionid"];
//    [encoder encodeObject:self.created_time forKey:@"created_time"];
//    [encoder encodeObject:self.nickname forKey:@"nickname"];
//    [encoder encodeObject:self.sex forKey:@"sex"];
//    [encoder encodeObject:self.language forKey:@"language"];
//    [encoder encodeObject:self.city forKey:@"city"];
//    
//    
//}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.access_token = [decoder decodeObjectForKey:@"access_token"];
//        self.refresh_token = [decoder decodeObjectForKey:@"refresh_token"];
//        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
//        self.unionid = [decoder decodeObjectForKey:@"unionid"];
//        self.created_time = [decoder decodeObjectForKey:@"created_time"];
//        self.nickname = [decoder decodeObjectForKey:@"nickname"];
//        self.sex = [decoder decodeObjectForKey:@"sex"];
//        self.language = [decoder decodeObjectForKey:@"language"];
//        self.city = [decoder decodeObjectForKey:@"city"];
//    }
//    return self;
//}
@end
