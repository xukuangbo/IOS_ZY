//
//  ZCSupportTogetherView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportBaseView.h"
#import "ZCWSMView.h"
@interface ZCSupportTogetherView : ZCSupportBaseView

@property (nonatomic, strong) ZCWSMView *wsmView;

-(void)reloadDataByVideoImgUrl:(NSString *)videoImgUrl andPlayUrl:(NSString *)playUrl andVoiceUrl:(NSString *)voiceUrl andFaceImg:(NSString *)faceImg andDesc:(NSString *)desc andImgUrlStr:(NSString *)imgUrlStr;

@end
