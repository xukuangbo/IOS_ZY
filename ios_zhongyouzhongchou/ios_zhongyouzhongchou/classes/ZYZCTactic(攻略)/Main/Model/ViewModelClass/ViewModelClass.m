//
//  ViewModelClass.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ViewModelClass.h"

@implementation ViewModelClass

+ (instancetype)viewModel
{
    return [[self alloc] init];
}

#pragma 获取网络可到达状态
-(void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock WithURlStr: (NSString *) strURl;
{
    // 状态栏是由当前控制器控制的，首先获取当前app。
    UIApplication *app = [UIApplication sharedApplication];
    
    // 遍历状态栏上的前景视图
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]){
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    // type数字对应的网络状态依次是：0：无网络；1：2G网络；2：3G网络；3：4G网络；5：WIFI信号
    //    NSLog(@"当前网络状态： '%d'.", type);
    netConnectBlock(type);
}

#pragma 接收穿过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}
@end
