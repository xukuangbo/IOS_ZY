//
//  ZYZCBaseViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Background.h"
@interface ZYZCBaseViewController : UIViewController


-(UIBarButtonItem *)customItemByImgName:(NSString *)imgName andAction:(SEL)action;
/**
 *  只有返回键
 */
-(void)setBackItem;
/**
 *  自定义反回键返回操作
 */
-(void)pressBack;

-(void)customNavWithLeftBtnImgName:(NSString *)leftName andRightImgName:(NSString *)rightName  andLeftAction:(SEL)leftAction andRightAction:(SEL)rightAction;
// 隐藏navigationBar
- (void)setClearNavigationBar:(BOOL)isClear;
// 提示框方法
- (void)showHintWithText:(NSString *)text;
@end
