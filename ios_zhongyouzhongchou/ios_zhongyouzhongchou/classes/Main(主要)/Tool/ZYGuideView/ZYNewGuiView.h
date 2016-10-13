//
//  ZYNewGuiView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCGContextView.h"
typedef enum : NSInteger {
    startHomeType,// 发起众筹主界面 0
    voiceType,    // 切换语音和视频  1
    skipType,     // 跳过按钮  2
    prevType     // 预览提示  3
} detailType;

@protocol ShowDoneDelegate <NSObject>

- (void)showDone;
//- (void)resetGuideSubviews;

@end
@interface ZYNewGuiView : UIView
@property (assign, nonatomic) CGFloat rectTypeOriginalY;//起始点纵坐标
@property (assign, nonatomic) CGFloat rectTypeOriginalX;//横坐标
@property (assign, nonatomic) id <ShowDoneDelegate> showDoneDelagate;


- (void)initSubViewWithTeacherGuideType:(detailType)type withContextViewType:(CGContextType)contextType;

@end
