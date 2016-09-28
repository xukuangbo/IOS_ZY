//
//  ZYWatchLiveViewController+LivePersonView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYWatchLiveViewController.h"
@interface ZYWatchLiveViewController (LivePersonView)
- (void)initLivePersonDataView;
/**
 *  展示个人头像
 */
- (void)showPersonData;
- (void)showPersonDataImage:(UIImageView *)sender;
- (void)requestData:(NSString *)userId;
@end
