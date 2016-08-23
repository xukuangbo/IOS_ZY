//
//  ZCSupportReturnView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportBaseView.h"
#import "ZCWSMView.h"
@interface ZCSupportReturnView : ZCSupportBaseView

@property (nonatomic, strong) ZCWSMView *wsmView;

@property (nonatomic, assign) BOOL     getLimit;//是否达到上限

-(void)reloadDataByVideoImgUrl:(NSString *)videoImgUrl andPlayUrl:(NSString *)playUrl andVoiceUrl:(NSString *)voiceUrl andFaceImg:(NSString *)faceImg andDesc:(NSString *)desc andImgUrlStr:(NSString *)imgUrlStr;

@end
