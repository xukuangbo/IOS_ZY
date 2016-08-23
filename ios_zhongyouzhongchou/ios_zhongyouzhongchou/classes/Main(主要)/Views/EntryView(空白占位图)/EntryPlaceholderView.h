//
//  EntryPlaceholderView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EntryTypeCaogao = 1,
    EntryTypeHuibao,
    EntryTypeSixin,
    EntryTypeXiangquDest,
    EntryTypeGuanzhuDaren
} EntryType;

@interface EntryPlaceholderView : UIView

/**
 *  枚举值添加占位view
 */
+ (instancetype)viewWithSuperView:(UIView *)superView type:(EntryType)entryType;

/**
 *  直接提供一个view，无需提供父视图
 */
+ (instancetype)viewWithFrame:(CGRect)rect type:(EntryType)entryType;





/**
 *  自定义添加占位view
 */
+ (instancetype)viewWithSuperView:(UIView *)superView image:(UIImage *)image title:(NSString *)title;

/**
 *  删除占位view
 */
+ (void)hidePlaceholderForView:(UIView *)view;
@end
