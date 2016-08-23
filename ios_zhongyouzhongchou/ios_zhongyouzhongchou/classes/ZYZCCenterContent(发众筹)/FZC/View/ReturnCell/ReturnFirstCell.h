//
//  ReturnFirstCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnCellBaseBGView.h"
#define ReturnFirstCellRowHeight 130
@interface ReturnFirstCell : UITableViewCell
@property (nonatomic, weak) ReturnCellBaseBGView *bgImageView;

@property (nonatomic, assign) BOOL open;
@end
