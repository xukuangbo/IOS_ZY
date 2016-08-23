//
//  ZYZCNumberKeyBoard.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//键盘默认为：  UIKeyboardTypeDecimalPad

#import <UIKit/UIKit.h>
typedef void (^TapBgViewBlock)();

@protocol ZYZCCustomTextFieldDelegate <NSObject>

@optional

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

@end


@interface ZYZCCustomTextField : UITextField<UITextFieldDelegate>

/**
 *  需不需要给textfield添加inputAccessoryView，默认是添加
 */
@property (nonatomic, assign)BOOL needAccess;
/**
 *  在附加试图中展示textField中的内容，默认为no
 */
@property (nonatomic, assign) BOOL showTextInAccess;

/**
 *  需不需要背景黑，默认yes
 */
@property (nonatomic, assign) BOOL needBackgroudView;
/**
 *  小数点键盘中是否保留两位小数,默认为yes
 */
@property (nonatomic, assign) BOOL shouldLimitTwoDecimal;

/**
 *  点击背景黑操作
 */
@property (nonatomic, copy  ) TapBgViewBlock tapBgViewBlock;

/**
 *  代理
 */
@property (nonatomic, assign) id<ZYZCCustomTextFieldDelegate> customTextFieldDelegate;

@end
