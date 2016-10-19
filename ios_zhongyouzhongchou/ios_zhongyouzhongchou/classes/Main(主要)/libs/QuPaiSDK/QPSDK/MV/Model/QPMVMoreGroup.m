//
//  MVMoreGroup.m
//  qupai
//
//  Created by yly on 15/3/23.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//
//#import "VideoConfig.h"
#import "QPMVMoreGroup.h"
#import "QPEffectManager.h"
#import "AFNetworking.h"

@implementation QPMVMoreGroup
{
    NSInteger _curPage;
    NSInteger _totalPage;
    BOOL _loading;
    BOOL _finishInit;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"id":@"gid"}];
}

//+(BOOL)propertyIsIgnored:(NSString*)propertyName
//{
//    return [propertyName isEqual:@"scrollOffset"];
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _mvs = (NSMutableArray<QPEffectMV *> *)[NSMutableArray arrayWithCapacity:4];
         _mvs = (NSMutableArray<QPEffectMV *> *)[NSMutableArray array];
        return self;
    }
    return nil;
}

- (void)loadData:(MVMoreGroupBlock)block
{
    if (_finishInit) {
        block(self, nil);
    }else{
        [self loadNext:block];
    }
}

- (void)loadNext:(MVMoreGroupBlock)block
{
    if (_loading) {
        return;
    }
    if (_totalPage != 0 && _curPage >= _totalPage) {
        block(self, nil);
        return;
    }
    _loading = YES;
    _curPage = _curPage + 1;
    NSDictionary *param =@{
                           @"token":@"a45a7bdc91731ed205f971f1eb8d7922",
                           @"typeId":@(_gid),
                           @"mvVersion":@(1),
                           @"page":@(_curPage)
                           };
    
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@", kHostUrl, @"mv/list"] parameters:param error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        if (error) {
            
        }else {
            NSArray *data = responseObject[@"data"];
            _totalPage = [responseObject[@"pages"] integerValue];
            NSArray *items = [QPEffectMV arrayOfModelsFromDictionaries:data error:nil];
            if (_curPage == 1) {
                [_mvs removeAllObjects];
            }
            [_mvs addObjectsFromArray:items];
//            [self updateMVStatus:_mvs];
            _finishInit = YES;
            block(self, nil);
            _loading = NO;
        }
    }];
    
    [dataTask resume];
    
//    [[DQHttpClient sharedClient] getWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHostUrl, @"mv/list"]] params:param success:^(id JSON) {
//        NSArray *data = JSON[@"data"];
//        _totalPage = [JSON[@"pages"] integerValue];
//        NSArray *items = [QPEffectMV arrayOfModelsFromDictionaries:data error:nil];
//        for (QPEffectMV *mv in items) {
//            mv.type = QPEffectTypeMV;
//        }
//        
//        if (_curPage == 1) {
//            [_mvs removeAllObjects];
//        }
//        [_mvs addObjectsFromArray:items];
//        [self refreshAlreadyDownload];
//        _finishInit = YES;
//        block(self, nil);
//        _loading = NO;
//    } failure:^(NSError *error) {
//        _curPage = _curPage - 1;
//        block(self, error);
//        _loading = NO;
//    }];
    
    
//    
//    [[DQHttpClient sharedClient] mvListTypeID:_gid mvVersion:MVVersion page: withBlock:^(NSDictionary *json, NSError *error) {
//        if (error) {
//            _curPage = _curPage - 1;
//            block(self, error);
//            _loading = NO;
//        }else{
//            NSArray *data = json[@"data"];
//            _totalPage = [json[@"pages"] integerValue];
//            NSArray *items = [ShopItem createShopItemByArray:data type:PasterMV];
//            if (_curPage == 1) {
//                [_mvs removeAllObjects];
//            }
//            [_mvs addObjectsFromArray:items];
//            [self refreshAlreadyDownload];
//            _finishInit = YES;
//            block(self, nil);
//            _loading = NO;
//        }
//    }];
}

//- (void)updateMVStatus:(NSArray *)mvs {
//    for (QPEffectMV *mv in mvs) {
//        mv.type = QPEffectTypeMV;
//        NSInteger index = [[QPEffectManager sharedManager] effectIndexByID:mv.eid type:QPEffectTypeMV];
//        if (index) {
//            mv.downStatus = QPEffectItemDownStatusFinish;
//        }
//    }
//}

- (QPEffectMV *)itemAtIndex:(NSUInteger)index
{
    if (_mvs.count > index) {
        return _mvs[index];
    }
    return nil;
}

- (NSUInteger)mvCount
{
    return [_mvs count] + (_totalPage > _curPage ? 1 : 0);
}

@end
