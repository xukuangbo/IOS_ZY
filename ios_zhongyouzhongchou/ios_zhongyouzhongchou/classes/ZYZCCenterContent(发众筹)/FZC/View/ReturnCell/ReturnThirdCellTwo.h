//
//  ReturnThirdCellTwo.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ReturnThirdCellTwoMargin 10

#import <UIKit/UIKit.h>

#import "FZCContentEntryView.h"
#define ReturnThirdCellTwoHeight 355+CONTENTHEIGHT
@class ReturnCellBaseBGView;

@interface ReturnThirdCellTwo : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, weak) ReturnCellBaseBGView *bgImageView;
/**
 *  人数输入框
 */
@property (nonatomic, weak) UITextField *peopleTextfiled;
/**
 *  金钱输入框
 */
@property (nonatomic, weak) UITextField *moneyTextFiled;
/**
 *  展开
 */
@property (nonatomic, assign) BOOL open;

/**
 *  人数设置view
 */
@property (nonatomic, weak) UIView *peopleView;
/**
 *  语音输入view
 */
@property (nonatomic, weak) FZCContentEntryView *entryView;

- (void)reloadManagerData;

@end
