//
//  ZYZCWebViewController.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

@interface ZYZCWebViewController : ZYZCBaseViewController
- (instancetype)initWithUrlString:(NSString *)urlString;

//// 添加返回事件
//- (void)setWillBackBlock:(void (^)(void))willBackBlock;
@end
