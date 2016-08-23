//
//  WSMBaseView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

//筹旅费模块WSM（文字，语音，视屏录入）的归属标示
#define RAISEMONEY_CONTENTBELONG @"raiseMoney"
//行程模块WSM（文字，语音，视屏录入）的归属标示
#define TRAVEL_CONTENTBELONG(day)  [NSString stringWithFormat:@"travel%.2zd",day]
//回报模块WSM（文字，语音，视屏录入）的归属标示
#define RETURN_01_CONTENTBELONG @"return01"

#define RETURN_02_CONTENTBELONG @"return02"

#define TOGTHER_CONTENTBELONG   @"togther"

#import <UIKit/UIKit.h>
@interface WSMBaseView : UIView
@property (nonatomic, copy ) NSString *contentBelong;
-(void)configUI;
@end
