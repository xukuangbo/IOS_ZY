//
//  LanguageTool.h
//  汉字转拼音
//
//  Created by Aaron on 15/7/7.
//  Copyright (c) 2015年 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageTool : NSObject
+(NSString *)chineseChangeToPinYin:(NSString *)chinese;
@end
