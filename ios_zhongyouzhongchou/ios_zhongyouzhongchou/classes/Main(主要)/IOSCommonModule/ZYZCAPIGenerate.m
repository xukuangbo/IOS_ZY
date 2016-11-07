//
//  ZYZCAPIGenerate.h
//
//  Created by yanming.huym on 16/10/27.
//
//

#import "ZYZCAPIGenerate.h"

static NSString* const apiFileName = @"ZhongYouAPIConfig";
static NSString* const apiFileExtension = @"json";

@implementation ZYZCAPIGenerate
{
    NSDictionary * cachedDictionary;
}

+(NSDictionary*)apiDictionary
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:apiFileName ofType:apiFileExtension];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSError *err = nil;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (err) {
        NSLog(@"--------------- Json文件有问题！---------------");
    }
    return dic;
}

+(ZYZCAPIGenerate*)sharedInstance
{
    static ZYZCAPIGenerate* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)defaultProtocol {
    if (!_defaultProtocol) {
        return @"https";
    }
    return _defaultProtocol;
}

-(NSString*)API:(NSString*)apiName
{
    if (!apiName) {
        return nil;
    }
    NSDictionary* d;
    if (!cachedDictionary) {
        d=[[self class] apiDictionary];
        if (d && d.count > 0) {
            cachedDictionary = d;
        }
    }
    else
    {
        d = cachedDictionary;
    }
    
    if (!d) {
        return nil;
    }
    
    NSDictionary * dic=[d objectForKey:apiName];
    NSString *apiProtocol = @"https";
    
    if (_serverType == kLinkServerTypeOfNormal) {
        apiProtocol=[dic objectForKey:@"protocol"]?[dic objectForKey:@"protocol"]:@"https";
    } else if (_serverType == kLinkServerTypeOfTest) {
        apiProtocol = @"http";
    } else {
        apiProtocol=[dic objectForKey:@"protocol"]?[dic objectForKey:@"protocol"]:@"http";
    }
    
    const NSString* host = [self serverHostWithType:self.serverType];
    NSString* control = nil, *action = nil;
    
    control  =  [dic objectForKey:@"control"] ? [dic objectForKey:@"control"] : @" ";
    action   =  [dic objectForKey:@"action"] ? [dic objectForKey:@"action"] : @" ";
    NSString* apiUrl = [NSString stringWithFormat:@"%@://%@/%@/%@",apiProtocol,host,control,action];
    return apiUrl;
}
// 获取baseUrl
- (NSString *)APIBaseUrl
{
    NSString *apiProtocol = @"http";
    const NSString* host = [self serverHostWithType:self.serverType];
    NSString* baseUrl = [NSString stringWithFormat:@"%@://%@/",apiProtocol,host];
    return baseUrl;
}

- (const NSString *)serverHostWithType:(kLinkServerType)type {
    switch (type) {
        case kLinkServerTypeOfNormal: {
            return @"www.sosona.com:8080";
        }
            break;
        case kLinkServerTypeOfTest: {
         //   return @"121.40.225.119:8080";
            return @"47.88.148.208:8080";
        }
            break;
        case kLinkServerTypeOfOverseas: {
            return @"47.88.148.208:8080";
        }
            break;
        case kLinkServerTypeOfHuaZi: {
//            return @"121.40.225.119:8080";
            return @"192.168.1.112:8086";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 是否开启内测模式模式
- (BOOL)isTestMode {     // 内测模式？ 如果开启，默认正式服务器，需要自己手动设置服务器
    BOOL isTestMode = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"IS_TEST_MODE"] boolValue];
    return isTestMode;
}

@end
