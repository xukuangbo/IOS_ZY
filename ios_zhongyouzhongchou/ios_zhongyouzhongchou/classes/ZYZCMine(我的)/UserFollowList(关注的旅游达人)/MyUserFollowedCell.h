//
//  MyUserFollowedCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define MyUserFollowedCellHeight 80
#import <UIKit/UIKit.h>

//@protocol MyUserFollowedCellDelegate <NSObject>
///**
// *  删除button点击事件
// */
//- (void)userFollowedCellDelegate:(UIButton *)button;
//@end
@class MyUserFollowedModel;
@interface MyUserFollowedCell : UITableViewCell


@property (nonatomic, strong) MyUserFollowedModel *userFollowModel;



@end
