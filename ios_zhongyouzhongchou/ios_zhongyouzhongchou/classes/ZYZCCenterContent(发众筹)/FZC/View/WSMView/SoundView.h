//
//  SounceView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WSMBaseView.h"
#import "DrawCircleView.h"
#import "RecordSoundObj.h"
@interface SoundView : WSMBaseView
/**
 *  时间显示
 */
@property (nonatomic, strong)  UILabel *secLab;
@property (nonatomic, strong)  UILabel *milliSecLab;
/**
 *  语音录制按钮
 */
@property (nonatomic, strong)  UIButton *soundBtn;
/**
 *  播放按钮
 */
@property (nonatomic, strong)  UIButton *playerBtn;

/**
 *  删除按钮
 */
@property (nonatomic, strong)  UIButton *deleteBtn;
/**
 *  圆环进度条
 */
@property (nonatomic, strong)  DrawCircleView *circleView;

@property (nonatomic, copy  )  NSString *soundFileName;

@property (nonatomic, assign)  CGFloat soundProgress;

@property (nonatomic, strong)RecordSoundObj *soundObj;


@end
