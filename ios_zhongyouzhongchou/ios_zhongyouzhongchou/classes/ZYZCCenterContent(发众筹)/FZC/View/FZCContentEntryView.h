//
//  FZCContent FZCContentEntryView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordView.h"
#import "SoundView.h"
#import "MovieView.h"

#define CONTENTHEIGHT 175*KCOFFICIEMNT+45
typedef NS_ENUM(NSInteger, InputContentType)
{
    WordType=KFZC_INPUTCONTENT_TYPE,
    SoundType,
    MovieType
};
typedef NS_ENUM(NSInteger, ContentViewType)
{
    WordViewType=KFZC_INPUTCONTENTVIEW_TYPE,
    SoundViewType,
    MovieViewType
};
@interface FZCContentEntryView : UIView
@property (nonatomic, strong) UIButton *preClickBtn;
@property (nonatomic, strong) UIView   *selectLineView;
@property (nonatomic, copy  ) NSString *contentBelong;

@property (nonatomic, copy  ) NSString *placeHolderText;

@property (nonatomic, copy  ) NSString *videoAlertText;

/**
 *  加载数据
 *
 */
-(void)reloadDataByWord:(NSString *)word andImgUrlStr:(NSString *)imgUrlStr andVoiceUrl:(NSString *)voiceUrl andVoiceLen:(CGFloat)voiceLen andVideoUrl:(NSString *)videoUrl  andVideoImg:(NSString *)videoImg;

@end
