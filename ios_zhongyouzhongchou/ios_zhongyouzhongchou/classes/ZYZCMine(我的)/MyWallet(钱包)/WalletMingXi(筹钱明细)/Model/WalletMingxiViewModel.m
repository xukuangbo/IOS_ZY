//
//  WalletMingxiViewModel.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletMingxiViewModel.h"
#import "WalletMingXiModel.h"
#import "MBProgressHUD+MJ.h"
@interface WalletMingxiViewModel ()

@property (nonatomic, strong) NSMutableArray *oldArray;

@end

@implementation WalletMingxiViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark ---下拉刷新最新数据
- (void)headRefreshDataWithProductID:(NSNumber *)productID
{
    self.refreshType = WalletMingXiRefreshTypeHead;
    
    NSString *url = Get_RecordDetail([ZYZCAccountTool getUserId], productID, 1);
    
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在加载..."];
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            
            [weakSelf fetchHeadValueSuccessWithDic:result];
            [MBProgressHUD hideHUD];
        }else{
            weakSelf.errorBlock(result);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showShortMessage:@"没有更多数据"];
        }
    } andFailBlock:^(id failResult) {
        weakSelf.failureBlock();
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络出错"];
    }];
}

#pragma mark ---上啦刷新请求数据
- (void)footRefreshDataWithProductID:(NSNumber *)productID pageNo:(NSInteger )pageNO
{
    self.refreshType = WalletMingXiRefreshTypeFoot;
    
    NSString *url = Get_RecordDetail([ZYZCAccountTool getUserId], productID, pageNO);
    //访问网络
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在加载..."];
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功，转化为数组
            [weakSelf fetchValueSuccessWithDic:result];
            
        }else{
            weakSelf.errorBlock(result);
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showShortMessage:@"没有更多数据"];
        }
    } andFailBlock:^(id failResult) {
        weakSelf.failureBlock();
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络出错"];
    }];
    
}

#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSDictionary *) returnValue
{
    NSArray *dataArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"]];
    if (dataArray.count > 0) {//添加到老数组进去
        
        [MBProgressHUD hideHUD];
        
        if (self.refreshType == WalletMingXiRefreshTypeHead) {
            
            self.returnBlock(dataArray);
        }else{
            self.returnBlock(dataArray);
        }
    }else{//直接返回老数组
        
        [MBProgressHUD hideHUD];
        
        self.returnBlock(nil);
    }
    
}

#pragma 获取到下拉刷新的数据，对正确的数据进行处理
-(void)fetchHeadValueSuccessWithDic: (NSDictionary *) returnValue
{
    NSArray *dataArray = [WalletMingXiModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"]];
    
    self.returnBlock(dataArray);
   
}


@end
