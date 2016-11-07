//
//  ZYDownloadGiftImageModel.h
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/11/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface ZYDownloadGiftImageModel : MTLModel <MTLJSONSerializing>
// 标题
@property (nonatomic, strong) NSString *name;
// 价格
@property (nonatomic, strong) NSString *price;
// 单位（RMB，默认 分）
@property (nonatomic, strong) NSString *unit;
// 图片
@property (nonatomic, strong) NSString *icon;
// 下载地址
@property (nonatomic, strong) NSString *downUrl;
// 状态 1有效；0无效
@property (nonatomic, strong) NSString *status;
// 排序
@property (nonatomic, strong) NSString *px;
// 新增时间
@property (nonatomic, strong) NSString *creattime;
// 图片张数
@property (nonatomic, strong) NSString *picTotles;
// 图片数组
@property (nonatomic, strong) NSArray *imageArray;
@end
