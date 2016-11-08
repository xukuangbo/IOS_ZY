//
//  ZYLiveViewController+EVENT.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveViewController.h"

@interface ZYLiveViewController (EVENT) <RCTKInputBarControlDelegate, UIGestureRecognizerDelegate, NSURLConnectionDelegate>

- (void)initLivePersonDataView;
- (void)setUpBottomViews;
/**
 *  展示个人头像
 */
- (void)showPersonData;

- (void)showPersonDataImage:(UITapGestureRecognizer *)sender;

- (void)messageBtnAction:(UIButton *)sender;

- (void)shareBtnAction:(UIButton *)sender;

-(void)showInputBar:(id)sender;
// 显示动画
- (void)showAnimtion:(NSString *)payType;
// 获取动画版本号
- (void)getPayVersion;

@end
