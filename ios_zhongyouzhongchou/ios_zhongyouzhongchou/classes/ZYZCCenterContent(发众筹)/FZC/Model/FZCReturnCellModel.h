//
//  FZCReturnCellModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZCReturnCellModel : NSObject

/**
 *  文字说明
 */
@property (nonatomic, copy) NSString *descString;

/**
 *  文字说明高度
 */
@property (nonatomic, assign) CGFloat descLabelHeight;

/**
 *  向下箭头是否隐藏
 */
@property (nonatomic, assign) BOOL downButtonHidden;

/**
 *  不打开时高度
 */
@property (nonatomic, assign) CGFloat noOpenHeight;
/**
 *  打开时高度
 */
@property (nonatomic, assign) CGFloat yesOpenHeight;

@end
