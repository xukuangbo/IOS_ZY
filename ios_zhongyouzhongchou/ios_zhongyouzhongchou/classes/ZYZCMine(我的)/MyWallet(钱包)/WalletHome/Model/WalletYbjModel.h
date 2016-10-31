//
//  WalletYbjModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletYbjModel : NSObject
//creattime = 1477623886000;
//id = "ZB_13595d30-4fab-4d52-a077-5b5618365a02";
//img = "http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/45/icon/1477623837596.png";
//spaceName = zhongyoutest01;
//status = 1;
//streamName = "zhongyoutest01-20SFO";
//totles = 10;
//userId = 45;
//zhibotitle = "";
//id 主键（字符串）
@property (nonatomic, copy) NSString *id;
//img封面
@property (nonatomic, copy) NSString *img;
//zhibotitle  标题
@property (nonatomic, copy) NSString *zhibotitle;
//totles 总额（分为单位）
@property (nonatomic, assign) NSInteger totles;
//status 状态(0是未使用,1是已使用,2是已锁定,3是自己已选择)
@property (nonatomic, assign) NSInteger status;


@end
