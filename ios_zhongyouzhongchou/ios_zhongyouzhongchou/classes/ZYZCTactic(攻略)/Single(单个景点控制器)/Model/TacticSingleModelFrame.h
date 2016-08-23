//
//  TacticSingleModelFrame.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TacticSingleModel;
@interface TacticSingleModelFrame : NSObject

@property (nonatomic, strong) TacticSingleModel *tacticSingleModel;


//描述
@property (nonatomic, assign) CGRect descViewF;
@property (nonatomic, assign) CGRect descLabelF;
//动画
@property (nonatomic, assign) CGRect flashViewF;
@property (nonatomic, assign) CGRect flashPlayButtonF;
//图文
@property (nonatomic, assign) CGRect pictureViewF;
@property (nonatomic, assign) CGRect pictureShowButtonF;
//小贴士
@property (nonatomic, assign) CGRect tipsViewF;
@property (nonatomic, assign) CGRect tipsShowButtonF;

//必玩景点
@property (nonatomic, assign) CGRect mustPlayViewF;
@property (nonatomic, assign) CGRect mustPlayViewButtonF;

//特色美食
@property (nonatomic, assign) CGRect foodsViewF;
@property (nonatomic, assign) CGRect foodsPlayViewButtonF;

//目的地标题
@property (nonatomic, assign) CGRect destTitleViewF;
//真实cell高度
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, copy) NSString *allString;
@end
