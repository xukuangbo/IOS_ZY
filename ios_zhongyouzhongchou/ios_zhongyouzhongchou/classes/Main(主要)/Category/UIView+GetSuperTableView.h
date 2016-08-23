//
//  UIView+GetSuperTableView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetSuperTableView)
/**
 *  如果该View在tableView上，可获取到tableView
 */
-(UITableView *)getSuperTableView;
@end
