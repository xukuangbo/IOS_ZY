//
//  ReturnCellBaseBGView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BgDescLabelFont [UIFont systemFontOfSize:14]
#define BgDescLabelWidth (KSCREEN_W - 30 - KEDGE_DISTANCE * 4)
#define BgDescLabelNormalHeight 71

typedef void(^DescLabelClickBlock)();
typedef void(^IconButtonClickBlock)();
@interface ReturnCellBaseBGView : UIImageView
/**
 *  用来告诉自己是在第几个cell
 */
@property (nonatomic, assign) NSInteger index;

/**
 *  空心小图标
 */
@property (nonatomic, weak) UIButton *iconButton;

/**
 *  空心点击用按钮
 */
//@property (nonatomic, weak) UIButton *iconClickButton;

/**
 *  小标题
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  回报描述内容
 */
@property (nonatomic, weak) UILabel *descLabel;

/**
 *  灰色虚线
 */
@property (nonatomic, weak) UIView *lineView;

/**
 *  向下的按钮
 */
@property (nonatomic, weak) UIButton *downButton;


/**
 *  真实的高度
 */
@property (nonatomic, assign) CGFloat realHeight;

/**
 *  初始化的方法
 */
- (instancetype)initWithRect:(CGRect )frame title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage desc:(NSString *)desc;

/**
 *  初始化的方法
 */
+ (instancetype)viewWithRect:(CGRect )frame title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage desc:(NSString *)desc;

@property (nonatomic, copy) DescLabelClickBlock descLabelClickBlock;
@property (nonatomic, copy) IconButtonClickBlock iconButtonClickBlock;

@end
