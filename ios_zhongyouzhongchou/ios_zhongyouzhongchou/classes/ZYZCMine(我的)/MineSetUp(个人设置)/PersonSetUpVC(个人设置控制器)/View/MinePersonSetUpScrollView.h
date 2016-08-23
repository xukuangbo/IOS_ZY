//
//  MinePersonSetUpScrollView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYZCCustomTextField.h"

@class MinePersonSetUpHeadView;
@class MinePersonSetUpModel;

@interface MinePersonSetUpScrollView : UIScrollView

@property (nonatomic, assign) BOOL wantFZC;

@property (nonatomic, weak) MinePersonSetUpHeadView *headView;


/**
 *  姓名标题
 */
@property (nonatomic, weak) UILabel *nameTitle;


/**
 *  姓名输入框星星
 */
@property (nonatomic, strong) UIImageView *nameTextFieldXX;
/**
 *  姓名点击输入框
 */
@property (nonatomic, weak) ZYZCCustomTextField *nameTextField;

/**
 *  性别输入框星星
 */
@property (nonatomic, strong) UIImageView *sexButtonXX;
/**
 *  性别点击输入框
 */
@property (nonatomic, weak) ZYZCCustomTextField *sexButton;


/**
 *  生日输入框星星
 */
@property (nonatomic, strong) UIImageView *birthButtonXX;
/**
 *  生日点击选择框
 */
@property (nonatomic, weak) ZYZCCustomTextField *birthButton;

/**
 *  星座输入框星星
 */
@property (nonatomic, strong) UIImageView *constellationButtonXX;
/**
 *  星座点击选择框
 */
@property (nonatomic, weak) ZYZCCustomTextField *constellationButton;


/**
 *  婚姻状况输入框星星
 */
@property (nonatomic, strong) UIImageView *marryButtonXX;
/**
 *  婚姻状况选择框
 */
@property (nonatomic, weak) ZYZCCustomTextField *marryButton;

/**
 *  省会点击选择框
 */
@property (nonatomic, weak) UIButton *proviceButton;

/**
 *  身高输入框星星
 */
@property (nonatomic, strong) UIImageView *heightButtonXX;
/**
 *  身高点击选择框
 */
@property (nonatomic, weak) ZYZCCustomTextField *heightButton;

/**
 *  体重输入框星星
 */
@property (nonatomic, strong) UIImageView *weightButtonXX;
/**
 *  体重点击选择框
 */
@property (nonatomic, weak) ZYZCCustomTextField *weightButton;

/**
 *  公司输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *companyButton;

/**
 *  职位输入框星星
 */
@property (nonatomic, strong) UIImageView *jobButtonXX;
/**
 *  职位输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *jobButton;
/**
 *  学校输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *schoolButton;
/**
 *  专业输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *departmentButton;

/**
 *  所在地输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *locationButton;
/**
 *  邮箱输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *emailButton;
/**
 *  手机输入
 */
@property (nonatomic, weak) ZYZCCustomTextField *phoneButton;



@property (nonatomic, strong) MinePersonSetUpModel *minePersonSetUpModel;
@end
