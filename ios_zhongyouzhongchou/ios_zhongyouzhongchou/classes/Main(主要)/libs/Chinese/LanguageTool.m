//
//  LanguageTool.m
//  汉字转拼音
//
//  Created by Aaron on 15/7/7.
//  Copyright (c) 2015年 Aaron. All rights reserved.
//

#import "LanguageTool.h"

@implementation LanguageTool

+(NSString *)chineseChangeToPinYin:(NSString *)chinese
{
    //NSString转换为CFStringRef
    CFStringRef strRef = (CFStringRef)CFBridgingRetain(chinese);
    //汉字转换为拼音
    CFMutableStringRef mutableStrRef = CFStringCreateMutableCopy(NULL, 0, strRef);
    //带声调符号的拼音
    CFStringTransform(mutableStrRef, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉声调符号
    CFStringTransform(mutableStrRef, NULL, kCFStringTransformStripDiacritics, NO);
    //CFStringRef转换为NSString
    NSString *pinYinTemp = (NSString *)CFBridgingRelease(mutableStrRef);
    //去掉空格
    NSString *pinYin = [pinYinTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return pinYin;
}
@end
