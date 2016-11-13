//
//  MyUserFollowCell.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define MyUserFollowedCellHeight 80

#import <UIKit/UIKit.h>

@class MyUserFollowedModel;
@interface MyUserFollowCell : UITableViewCell

@property (nonatomic, strong) MyUserFollowedModel *userFollowModel;
@end
