//
//  ZYLiveListCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void (^PushWatchLiveBlock)(void);
@class ZYLiveListModel;
@interface ZYLiveListCell : UITableViewCell
@property (nonatomic, strong) ZYLiveListModel *model;
//@property (nonatomic, copy) PushWatchLiveBlock pushWatchLiveBlock;
@end
