//
//  ZYZCTool.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCTool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "sys/utsname.h"

@implementation ZYZCTool
#pragma mark --- 文字长度计算
+(CGSize)calculateStrLengthByText:(NSString *)text andFont:(UIFont *)font andMaxWidth:(CGFloat )maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark --- 设置文字间距
+(NSMutableAttributedString *)setLineDistenceInText:(NSString *)text
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, text.length)];
    return attributedString;
}

#pragma mark --- 计算有间距的文字的长度
+ (CGSize)calculateStrByLineSpace:(CGFloat)lineSpace andString:(NSString *)str andFont:(UIFont *)font andMaxWidth:(CGFloat )maxW
{
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = lineSpace;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    attrs[NSParagraphStyleAttributeName] = pStyle;
    CGSize labelSize = [str boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    return labelSize;
}


#pragma mark --- 创建btn（文字在左图片在右）
+ (UIButton *)getCustomBtnByTilte:(NSString *)title andImageName:(NSString *)imageName andtitleFont:(UIFont *)titleFont
{
    CGSize rightButtonTitleSize = [self calculateStrLengthByText:title andFont:titleFont andMaxWidth:MAXFLOAT];
    CGFloat labelWidth = rightButtonTitleSize.width + 2;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    CGFloat imageWith = btn.currentImage.size.width + 2;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    return btn;
}

#pragma mark --- 获取本地日期
+(NSString *)getLocalDate
{
    NSDate *  sendDate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:sendDate];
    
    return locationString;
}

#pragma mark --- 将日期转化为自定义格式
+(NSString *)turnDateToCustomDate:(NSDate *)date
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY/MM/dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    
    return locationString;
}

#pragma mark --- 将jsonStr转nsarray
+ (NSArray *)turnJsonStrToArray:(NSString *)jsonStr
{
    NSError  *error=nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = (NSArray *)[NSJSONSerialization JSONObjectWithData:
                                jsonData options:NSJSONReadingAllowFragments
                                error:&error];
    return array;
}

#pragma mark --- 将jsonStr转dict
+ (NSDictionary *)turnJsonStrToDictionary:(NSString *)jsonStr
{
    NSError  *error=nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments
        error:&error];
    return dict;
}

#pragma mark --- 获取时间戳
+(NSString *)getTimeStamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970];//(10位)
    NSString *timeStamp = [NSString stringWithFormat:@"%.f", time*1000];
    return timeStamp;
}


#pragma mark --- 时间戳转时间
+(NSString *)turnTimeStampToDate:(NSString *)timeStamp
{
    if(timeStamp == nil)
    {
        return nil;
    }
    
    if(timeStamp.length>10)
    {
        timeStamp=[timeStamp substringToIndex:10];
    }
    
    NSString*str=timeStamp;//时间戳  @"1368082020"(十位)
    
    NSTimeInterval time=[str doubleValue];
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

#pragma mark --- 获取手机ip
+ (NSString *)getDeviceIp
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

#pragma mark --- 判断文件是否已存在,存在就清楚
+(void)removeExistfile:(NSString *)filePath
{
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL exist=[manager fileExistsAtPath:filePath];
    if (exist) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL successRemove=[manager removeItemAtPath:filePath error:nil];
//            if (successRemove) {
//                [ZYZCTool getZCDraftFiles];
//            }
        });
    }
}

#pragma mark --- 清空documents下zcDraft中的文件
+ (void)cleanZCDraftFile
{
    NSString *zcDraftPath=[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0],KMY_ZHONGCHOU_FILE];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL exist=[manager fileExistsAtPath:zcDraftPath];
    if (exist) {
        NSArray *fileArr=[manager subpathsAtPath:zcDraftPath];
        DDLog(@"fileArr:%@",fileArr);
        for (NSString *fileName in fileArr) {
            NSString *filePath = [zcDraftPath stringByAppendingPathComponent:fileName];
            dispatch_async(dispatch_get_global_queue(0, 0), ^
            {
                [manager removeItemAtPath:filePath error:nil];
            });
        }
    }
}

//+ (void) getZCDraftFiles
//{
//    NSString *zcDraftPath=[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0],KMY_ZHONGCHOU_FILE];
//    
//    NSFileManager *manager=[NSFileManager defaultManager];
//    BOOL exist=[manager fileExistsAtPath:zcDraftPath];
//    if (exist) {
//        NSArray *fileArr=[manager subpathsAtPath:zcDraftPath];
//        DDLog(@"fileArr:%@",fileArr);
//    }
//}

#pragma mark - 计算生日的月，日
/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
+(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

#pragma mark - 获取手机型号
/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+ (NSInteger)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone3,1"])    return 1;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return 1;
    if ([deviceString isEqualToString:@"iPhone4,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,3"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,4"])    return 2;
    if ([deviceString isEqualToString:@"iPhone6,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone6,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone7,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone7,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone8,1"])    return 3;
    if ([deviceString isEqualToString:@"iPhone8,2"])    return 3;
    
    return 0;
}
// 修正图片方向（正方向,上传服务器后避免图片方向错误）
+ (UIImage *)fixOrientation:(UIImage *)aImage {
//    NSLog(@"%@",aImage.imageOrientation);
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 判断是否是邮箱格式

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

#pragma mark --- 是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])options:NSStringEnumerationByComposedCharacterSequences
        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

//过滤表情
+ (NSString *)filterEmoji:(NSString *)string
{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 =malloc(sizeof(char)*len);
    int j = 0;
    for (int i =0; i < len; i++) {
        unsigned int c = utf8[i];
        BOOL isControlChar =NO;
        if (c==4294967280) {
            i = i+3;
            isControlChar = YES;
        }
        if (!isControlChar) {
            newUTF8[j] = utf8[i];
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [[NSString alloc]initWithCString:(const char *)newUTF8 encoding:NSUTF8StringEncoding];
    return encrypted;
}

#pragma mark - 邮箱判断
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark --- 压缩image
+(UIImage *)compressImage:(UIImage *)image scale:(CGFloat )scale
{
    if (!scale) {
        scale = 0.1;
    }
    NSData *imgData=UIImageJPEGRepresentation(image, scale);
    UIImage *newImage=[UIImage imageWithData:imgData];
    return newImage;
}

#pragma 获取当前网络状态
+ (int)getCurrentNetworkStatus
{
    // 状态栏是由当前控制器控制的，首先获取当前app。
    UIApplication *app = [UIApplication sharedApplication];
    
    // 遍历状态栏上的前景视图
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]){
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    // type数字对应的网络状态依次是：0：无网络；1：2G网络；2：3G网络；3：4G网络；5：WIFI信号
//    NSLog(@"当前网络状态： '%d'.", type);
    return type;
}

#pragma mark --- 判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

#pragma mark --- 存储app版本号，判断app是否是下载或更新后第一次进入
+(BOOL)firstEnterApp
{
    NSString *version=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *myVersion=[user objectForKey:KAPP_VERSION];
    //下载或更新后第一次进入
    if (!myVersion||![myVersion isEqualToString:version]) {
        //首次进入app
        [user setObject:version forKey:KAPP_VERSION];
        [user synchronize];
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark --- 是否是第一次发布行程
+ (BOOL)firstPublishOrSaveProduct
{
     NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *record=[user objectForKey:KFIRST_PUBLISH];
    if (!record) {
        [user setObject:@"getFirstTime" forKey:KFIRST_PUBLISH];
        [user synchronize];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
