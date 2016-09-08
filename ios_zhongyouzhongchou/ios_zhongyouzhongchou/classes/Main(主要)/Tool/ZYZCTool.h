//
//  ZYZCTool.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZYZCTool : NSObject
/**
 *  计算文字长度
 *
 *  @param text 文字内容
 *  @param font 字体
 *
 *  @return 文字长度
 */
+(CGSize )calculateStrLengthByText:(NSString *)text andFont:(UIFont *)font andMaxWidth:(CGFloat )maxW;
/**
 *  设置文字间距
 */
+(NSMutableAttributedString *)setLineDistenceInText:(NSString *)text;

/**
 *  计算有间距的文字的长度
 */
+ (CGSize)calculateStrByLineSpace:(CGFloat)lineSpace andString:(NSString *)str andFont:(UIFont *)font andMaxWidth:(CGFloat )maxW;

/**
 *  创建btn（文字在左图片在右）
 *
 */
+ (UIButton *)getCustomBtnByTilte:(NSString *)title andImageName:(NSString *)imageName andtitleFont:(UIFont *)titleFont;

/**
 *  获取日期时间
 */
+(NSString *)getLocalDate;
/**
 *  转化为日期格式
 *
 */
+(NSString *)turnDateToCustomDate:(NSDate *)date;

/**
 *  json字符串转数组
 */
+(NSArray *)turnJsonStrToArray:(NSString *)jsonStr;

/**
 *  json字符串转数组
 */
+ (NSDictionary *)turnJsonStrToDictionary:(NSString *)jsonStr;

/**
 *  获取时间戳
 *
 *  @return 时间戳字符串
 */
+(NSString *)getTimeStamp;

/**
 *  时间戳转时间
 */
+(NSString *)turnTimeStampToDate:(NSString *)timeStamp;

/**
 *  获取ip
 */
+ (NSString *)getDeviceIp;

/**
 *  判断文件是否已存在,存在并清除
 */
+(void)removeExistfile:(NSString *)filePath;

/**
 *  清空documents下zcDraft中的文件
 */
+ (void)cleanZCDraftFile;

//+ (void) getZCDraftFiles;

/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
+(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;

/**
 *  设备版本
 */
+ (NSInteger)deviceVersion;
/**
 *  修正图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;
/**
 *  判断是否是邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 *  是否含有表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
/**
 *  过滤表情
 *
 */
+ (NSString *)filterEmoji:(NSString *)string;

/**
 *  邮箱判断
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 *  压缩uiimage，scale为0~1
 */
+(UIImage *)compressImage:(UIImage *)image scale:(CGFloat )scale;

/**
 *  获取当前wangl状态
 *
 *  @return 返回值 0：无网络；1：2G网络；2：3G网络；3：4G网络；5：WIFI信号
 */
+ (int)getCurrentNetworkStatus;

/**
 *  判断内容是否全部为空格  yes 全部为空格  no 不是
 *
 */
+ (BOOL) isEmpty:(NSString *) str;

/**
 *  判断是否是第一次进入app
 *
 */
+ (BOOL)firstEnterApp;

/**
 *  判断是否是第一次发布行程
 */
+ (BOOL)firstPublishOrSaveProduct;

@end
