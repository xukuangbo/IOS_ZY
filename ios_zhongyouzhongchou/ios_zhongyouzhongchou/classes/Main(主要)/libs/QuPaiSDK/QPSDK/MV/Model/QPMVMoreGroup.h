//
//  MVMoreGroup.h
//  qupai
//
//  Created by yly on 15/3/23.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import "JSONModel.h"
//#import "MVMoreManager.h"
//#import "ShopItem.h"
#import "QPEffectMV.h"
@class QPMVMoreGroup;
typedef void(^MVMoreGroupBlock)(QPMVMoreGroup *group, NSError *error);

@protocol MVMoreGroup
@end

@interface QPMVMoreGroup : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger gid;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSMutableArray< QPEffectMV *> *mvs;
//@property (nonatomic, assign) CGPoint scrollOffset;

- (void)loadData:(MVMoreGroupBlock)block;
- (void)loadNext:(MVMoreGroupBlock)block;

- (void)refreshAlreadyDownload;

- (QPEffectMV *)itemAtIndex:(NSUInteger)index;
- (NSUInteger)mvCount;
@end
