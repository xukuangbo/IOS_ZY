//
//  NetFailView.h
//  断网界面与刷新
//
//  Created by liuliang on 16/2/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NetworkState)
{
    UnNetWork=1, //网络断开连接
    UnService,   //服务器断开连接
    UnusualService,//服务器异常，后台报错
    Unknown      //未知错误
};

typedef void (^ReFrashBlock)();

@interface NetFailView : UIView

@property (nonatomic, copy  ) ReFrashBlock reFrashBlock;

@property (nonatomic, assign) NetworkState failType;

- (instancetype)initWithFailResult:(id)failResult;

@end
