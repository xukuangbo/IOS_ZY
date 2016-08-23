//
//  FZCSingleTitleView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define singleTitleViewHeight 76
@interface FZCSingleTitleView : UIView
/**
 *  是否隐藏绿色的线
 */
//@property (nonatomic, assign) BOOL hiddenGreenLine;

- (instancetype)initWithTitle:(NSString *)title ContentView:(UIView *)contentView;


@end
