//
//  LiveFunctionView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QPLiveSession;

@interface LiveFunctionView : UIView

@property (nonatomic, weak) QPLiveSession *liveSession;

- (instancetype)initWithSession:(QPLiveSession *)liveSession;
@end
