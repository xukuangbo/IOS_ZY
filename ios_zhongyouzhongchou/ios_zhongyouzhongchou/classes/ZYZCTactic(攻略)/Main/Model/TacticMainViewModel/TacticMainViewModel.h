//
//  TacticMainViewModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ViewModelClass.h"

@interface TacticMainViewModel : ViewModelClass

/**
 *  请求主页面数据
 */
- (void)requestMainData;


/**
 *  轮播图跳转到活动界面
 */
-(void) pushWebVCWithURLString: (NSString *)urlString WithViewController: (UIViewController *)superController;

/**
 *  推送到视频播放控制器
 */
-(void) pushVideoVCWithURLString: (NSString *)urlString WithViewController: (UIViewController *)superController;

/**
 *  推送到国家详情控制器
 */
-(void) pushCountryVCWithViewid: (NSNumber *)viewid WithViewController: (UIViewController *)superController;

/**
 *  推送到城市详情控制器
 */
-(void) pushCityVCWithViewid: (NSNumber *)viewid WithViewController: (UIViewController *)superController;

/**
 *  推送到更多视频控制器
 */
-(void) pushMoreVideosWithViewController: (UIViewController *)superController;

/**
 *  推送到更多国家或者城市控制器
 */
-(void) pushMoreCountryCityVCWithViewtype:(NSInteger )viewtype WithViewController: (UIViewController *)superController;
@end
