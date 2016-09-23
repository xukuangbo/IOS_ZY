//
//  ZYLiveViewController+EVENT.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveViewController.h"

@interface ZYLiveViewController (EVENT) <RCTKInputBarControlDelegate, UIGestureRecognizerDelegate>

- (void)initUISubView;
- (void)setUpBottomViews;
/**
 *  展示个人头像
 */
- (void)showPersonData;

- (void)messageBtnAction:(UIButton *)sender;

- (void)shareBtnAction:(UIButton *)sender;

-(void)showInputBar:(id)sender;
@end
