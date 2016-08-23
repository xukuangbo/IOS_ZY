//
//  ReturnSecondCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnCellBaseBGView.h"
#define ReturnSecondCellRowHeight 130
@interface ReturnSecondCell : UITableViewCell
@property (nonatomic, weak) ReturnCellBaseBGView *bgImageView;


@property (nonatomic, assign) BOOL open;
@end
