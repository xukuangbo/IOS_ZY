//
//  WordEditViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//
/**
 *  子多容纳字数
 */
#define CONTENT_CHARACTER_LIMIT 20

#import "ZYZCBaseViewController.h"
/**
 *  文本编辑内容
 */
typedef void(^TextBlock)(NSString *textStr);

@interface WordEditViewController : ZYZCBaseViewController
@property (nonatomic, strong )UITextView   *textView;
@property (nonatomic, copy   )NSString     *myTitle;
@property (nonatomic, copy   )TextBlock    textBlock;
@property (nonatomic, copy   )NSString     *preText;

@end
