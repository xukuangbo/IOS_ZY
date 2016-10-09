//
//  HotCommentCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCCommentModel.h"
@interface HotCommentCell : UITableViewCell
@property (nonatomic, strong) ZCCommentModel *commentModel;
@property (nonatomic, strong) UIView   *lineView;
@end
