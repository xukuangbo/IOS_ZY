//
//  ReturnThirdCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define ReturnThirdCellMargin 10
#import <UIKit/UIKit.h>
#import "ZYZCCustomTextField.h"
@class ReturnCellBaseBGView;

#import "FZCContentEntryView.h"
#define ReturnThirdCellHeight (347+CONTENTHEIGHT)
@interface ReturnThirdCell : UITableViewCell<ZYZCCustomTextFieldDelegate>
@property (nonatomic, weak) ReturnCellBaseBGView *bgImageView;
/**
 *  人数输入框
 */
@property (nonatomic, weak) ZYZCCustomTextField *peopleTextfiled;
/**
 *  金钱输入框
 */
@property (nonatomic, weak) ZYZCCustomTextField *moneyTextFiled;
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
@property (nonatomic, strong) FZCContentEntryView *entryView;

- (void)reloadManagerData;
@end
