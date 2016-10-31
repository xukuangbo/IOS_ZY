//
//  ZYZCAPIGenerate.h
//
//  Created by yanming.huym on 16/10/27.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, kLinkServerType) {
    kLinkServerTypeOfNormal,    // 连接正式服务器
    kLinkServerTypeOfTest,      // 连接测试服务器
    kLinkServerTypeOfOverseas,  // 连接海外服务器
    kLinkServerTypeOfHuaZi,     // 连接华子服务器
};

@interface ZYZCAPIGenerate : NSObject

@property (nonatomic, assign) kLinkServerType serverType;

/**
 *  设置默认的协议类型，买家这边是通过访问接口来设置默认协议的
 */
@property (nonatomic, strong) NSString *defaultProtocol;


+(ZYZCAPIGenerate*)sharedInstance;
-(NSString*)API:(NSString*)apiName;
- (NSString *)APIBaseUrl;

// 是否开启内测模式
- (BOOL)isTestMode;

@end
