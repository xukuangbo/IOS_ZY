//
//  ZYNewGuiView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideWindow : UIWindow

@property (assign, nonatomic) NSInteger clickAmnout; //点击次数

- (void)show;
- (void)dismiss;



@end
