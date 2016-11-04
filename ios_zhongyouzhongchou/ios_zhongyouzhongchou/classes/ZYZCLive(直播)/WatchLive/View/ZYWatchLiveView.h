//
//  ZYWatchLiveView.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYWatchLiveView : UIView
/**
 *  关闭直播按钮
 */
@property(nonatomic,strong) UIButton *closeLiveButton ;

/**
 *  鲜花按钮
 */
@property(nonatomic,strong)UIButton *flowerBtn;
/**
 *  评论按钮
 */
@property(nonatomic,strong)UIButton *feedBackBtn;
/**
 *  掌声按钮
 */
@property(nonatomic,strong)UIButton *clapBtn;
/**
 *  分享按钮
 */
@property(nonatomic,strong)UIButton *shareBtn;

#pragma mark ---私信按钮
@property (nonatomic, strong) UIButton *massageBtn;
@end
