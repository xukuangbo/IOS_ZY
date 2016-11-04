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
- (void)initPersonData;
/**
 *  展示个人头像
 */
- (void)showPersonData;
// 点击每个看直播头像
- (void)showPersonDataImage:(UITapGestureRecognizer *)sender;
// 请求个人数据
- (void)requestData:(NSString *)userId;
// 进入众筹详情
- (void)clickZhongchouButton;
// 打赏一起去金额
- (void)togetherGoUserContribution;
// 打赏回报金额
- (void)rewardUserContribution;
// 获取关联行程打赏结果
- (void)getUserContributionResultHttpUrl;

// 显示动画
- (void)showAnimtion:(NSString *)payType imageNumber:(NSInteger)number;
@end
