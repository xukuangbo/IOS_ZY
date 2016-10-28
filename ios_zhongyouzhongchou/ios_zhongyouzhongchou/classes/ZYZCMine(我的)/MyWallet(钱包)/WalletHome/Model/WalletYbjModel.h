//
//  WalletYbjModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletYbjModel : NSObject
//id 主键（字符串）
@property (nonatomic, copy) NSString *id;
//zhibotitle  标题
@property (nonatomic, copy) NSString *zhibotitle;
//totles 总额（分为单位）
@property (nonatomic, assign) CGFloat totles;
//status 状态(0是未使用,1是已使用,2是已锁定)
@property (nonatomic, assign) NSInteger status;
//img封面
@property (nonatomic, copy) NSString *img;
@end
