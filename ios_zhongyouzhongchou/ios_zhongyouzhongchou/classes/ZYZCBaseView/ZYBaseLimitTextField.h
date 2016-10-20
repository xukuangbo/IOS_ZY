//
//  ZYBaseLimitTextField.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextChangeBlock)(NSInteger leftNum);

@protocol ZYBaseLimitTextFieldDelegate <NSObject>

@optional

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;

- (void)textFieldDidEndEditing:(UITextField *)textField;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)textFieldShouldClear:(UITextField *)textField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

@interface ZYBaseLimitTextField : UITextField

//代理
@property (nonatomic, assign) id<ZYBaseLimitTextFieldDelegate> limitTextFieldDelegate;

//剩余字符个数改变block
@property (nonatomic, copy  ) TextChangeBlock textChangeBlock;
//站位字符串
@property (nonatomic, strong) NSString       *placeholderText;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame andMaxTextNum:(NSInteger)maxNum;

- (instancetype)initWithMaxTextNum:(NSInteger)maxNum;

@end
