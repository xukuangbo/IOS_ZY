//
//  RaiseMoneySecondCellView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//
typedef enum {
    InitNameTypeWord = 55,
    InitNameTypeSound,
    InitNameTypeMovie
}InitNameType;
#import <UIKit/UIKit.h>

@interface RaiseMoneySecondCellView : UIView
/**
 *  tag值
 */
@property (nonatomic, assign) int flag;
- (instancetype)initWithName:(InitNameType)initNameType WithFrame:(CGRect)frame;
@end
