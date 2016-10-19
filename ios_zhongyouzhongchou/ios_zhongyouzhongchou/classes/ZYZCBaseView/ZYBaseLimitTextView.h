//
//  ZYLimitTextBaseView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//


//编辑文字后首尾空字符已做删除处理

#import <UIKit/UIKit.h>

typedef void (^TextChangeBlock)(NSInteger leftNum);

@interface ZYBaseLimitTextView : UITextView

//剩余字符个数改变block
@property (nonatomic, copy  ) TextChangeBlock textChangeBlock;
//站位字符串
@property (nonatomic, strong) NSString        *placeholder;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame andMaxTextNum:(NSInteger)maxNum;

- (instancetype)initWithMaxTextNum:(NSInteger)maxNum;


@end
