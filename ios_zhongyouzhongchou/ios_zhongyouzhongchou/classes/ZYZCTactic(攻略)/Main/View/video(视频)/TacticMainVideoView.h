//
//  TacticMainVideoView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TacticMainVideoView : UIButton

/**
 *  名字
 */
@property (nonatomic, weak) UILabel *nameLabel;

/**
 *  播放
 */
@property (nonatomic, weak) UIImageView *startImg;

@property (nonatomic, copy) NSString *playURL;
@end
