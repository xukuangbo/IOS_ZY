//
//  ZYZCCusomMovieImage.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlayType)
{
    Local_Video=1,
    Net_Video,
    Unsure_Video
};

@interface ZYZCCusomMovieImage : UIImageView

@property (nonatomic, copy ) NSString *playUrl;

@property (nonatomic, strong) UIImageView *startImg;

@property (nonatomic, assign) PlayType playType;//默认为Unsure_Video

-(void)changeFrame;

@end
