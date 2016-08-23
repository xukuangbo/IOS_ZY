//
//  ZYZCBaseTableViewController.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Background.h"

@interface ZYZCBaseTableViewController : UIViewController
/**
 *  tableView
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 *  封面图高度
 */
@property (nonatomic, assign) CGFloat imageViewHeight;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *titleName;

/**
 *  改变颜色
 */
- (void)changeNaviColorWithScroll:(UIScrollView *)scrollView;

/**
 *  只有返回键
 */
-(void)setBackItem;
/**
 *  自定义反回键返回操作
 */
-(void)pressBack;
/**
 *  设置导航栏背景颜色
 */
- (void)setNavi;
/**
 *  设置为空白的导航栏背景色
 */
- (void)setClearNavi;

-(void)customNavWithLeftBtnImgName:(NSString *)leftName andRightImgName:(NSString *)rightName  andLeftAction:(SEL)leftAction andRightAction:(SEL)rightAction;
@end
