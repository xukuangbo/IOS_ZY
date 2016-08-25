//
//  ZYLiveListViewModel.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveListViewModel.h"
#import "ZYLiveListModel.h"
#import "MBProgressHUD+MJ.h"
@interface ZYLiveListViewModel ()

@end

@implementation ZYLiveListViewModel
#pragma mark ---下拉刷新最新数据
- (void)headRefreshData
{
    self.refreshType = RefreshTypeHead;
    
    NSString *url = Post_Live_List;
    NSDictionary *parameters = @{
                             @"pageNo" : @"1",
                             @"pageSize" : @"10"
                             };
    
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            
//            DDLog(@"%@",result);
            
            [weakSelf fetchHeadValueSuccessWithDic:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUD];
            });
        }else{
            weakSelf.errorBlock(result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showShortMessage:@"没有更多数据"];
            });
        }
    } andFailBlock:^(id failResult) {
        
        weakSelf.failureBlock();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showShortMessage:@"连接服务器失败,请检查你的网络"];
        });
    }];
}

#pragma mark ---上啦刷新请求数据
- (void)footRefreshDataWithPageNo:(NSInteger )pageNO
{
    self.refreshType = RefreshTypeFoot;
    
    NSString *url = Post_Live_List;
    NSDictionary *parameters = @{
                                 @"pageNo" : @(pageNO),
                                 @"pageSize" : @"10"
                                 };
    //访问网络
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在加载..."];
     [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock: ^(id result, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功，转化为数组
            [weakSelf fetchValueSuccessWithDic:result];
            
        }else{
            weakSelf.errorBlock(result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [MBProgressHUD hideHUD];
                [MBProgressHUD showShortMessage:@"没有更多数据"];
            });
        }
    } andFailBlock:^(id failResult) {
        weakSelf.failureBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络出错"];
        });
    }];
    
}


#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSDictionary *) returnValue
{
    NSArray *dataArray = [ZYLiveListModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"]];
    if (dataArray.count > 0) {//添加到老数组进去
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
        });
        
        if (self.refreshType == RefreshTypeHead) {
            
            self.returnBlock(dataArray);
        }else{
            self.returnBlock(dataArray);
        }
    }else{//直接返回老数组
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
        });
        
        self.returnBlock(nil);
    }
    
}

#pragma 获取到下拉刷新的数据，对正确的数据进行处理
-(void)fetchHeadValueSuccessWithDic: (NSDictionary *) returnValue
{
    NSArray *dataArray = [ZYLiveListModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"]];
    
    self.returnBlock(dataArray);
    
}
@end
