//
//  ZCSupportBaseView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define HAS_SUPPORT_PEOPLE(numberPeople) [NSString stringWithFormat:@"已支持:%d位",numberPeople]

#define LIMIT_SUPPORT_PEOPLE(numberPeople) [NSString stringWithFormat:@"限额:%d位",numberPeople]

#import <UIKit/UIKit.h>
#import "UIView+GetSuperTableView.h"
#import "ZCTotalPeopleView.h"
#import "ZCTotalPeopleView.h"
#import "MBProgressHUD+MJ.h"
typedef void (^SupportBlock)();

@interface ZCSupportBaseView : UIView
@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UILabel  *titleLab;   //标题
@property (nonatomic, strong) UILabel  *textLab;    //玩法解释
@property (nonatomic, strong) UIButton *supportBtn;  //支持
@property (nonatomic, strong) UIButton *moreTextBtn;//展开更多人物按钮
@property (nonatomic, strong) UIView   *otherViews;
@property (nonatomic, strong) UILabel  *hasSupportLab;//已支持标签
@property (nonatomic, strong) UILabel  *limitLab;   //限额标签
@property (nonatomic, strong) UIView   *supportPeople;//支持的人
@property (nonatomic, strong) UIButton *morePeopleBtn;//更多支持的人

@property (nonatomic, assign) CGFloat  textNormalHeight;//文字为正常高度
@property (nonatomic, assign) CGFloat  textOpenHeight;  //文字展开高度
@property (nonatomic, assign) BOOL     isOpenText;      //是否展开文字
@property (nonatomic, strong) NSArray  *users;          //已支持的人

@property (nonatomic, assign) int limitNumber;

@property (nonatomic, assign) BOOL chooseSupport;//   是否可以支持
@property (nonatomic, assign) BOOL sureSupport;   //  是否支持

@property (nonatomic, copy  ) SupportBlock supportBlock;

@property (nonatomic, assign) BOOL     mySelf;//是否是我的项目
//判断项目是否截止
@property (nonatomic, assign) BOOL   productEndTime;

- (instancetype)initSupportViewByTop:(CGFloat   )top
                            andTitle:(NSString *)title
                             andText:(NSString *)text;

-(void)configUI;


-(NSAttributedString *)customStringByString:(NSString *)str;

/**
 *  点击支持按钮
 */
-(void)supportMoney;

@end
