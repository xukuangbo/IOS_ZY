//
//  ZYSystemCommon.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYSystemCommon.h"
#import "ZYZCHTTPTool.h"
#import "ZYLiveListModel.h"
@implementation ZYSystemCommon
- (void)cleanNewMessageRedDot:(NSString *)systemID
{
    NSDictionary *parameters= @{
                                @"id":systemID
                                };
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:SYSTEM_MSG_READ andParameters:parameters
                       andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         DDLog(@"%@",result);
         
     }andFailBlock:^(id failResult){
         DDLog(@"%@",failResult);
     }];

}

- (void)getLiveContent:(NSDictionary *)parameters
{
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:GET_LIVE_CONTENT andParameters:parameters
                       andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         DDLog(@"%@",result);
         // block 回调执行
         NSDictionary *data = result[@"data"];
         if (data.count != 0) {
             ZYLiveListModel *liveModel = [[ZYLiveListModel alloc]mj_setKeyValues:result[@"data"][0]];
             [self block:liveModel];
         } else {
             [self block:nil];
         }
     }andFailBlock:^(id failResult){
         DDLog(@"%@",failResult);
         [self block:nil];
     }];
}

- (void)block:(ZYLiveListModel *)liveModel
{
    if (_getLiveDataSuccess) {
        _getLiveDataSuccess(liveModel);
    }
}

@end
