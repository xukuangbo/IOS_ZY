//
//  ChatComplainController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
typedef NS_ENUM(NSInteger, ComplainType)
{
    SexyType=1,//色情低俗
    GambleType,//赌博
    PolityType,//政治敏感
    FraudType,//欺诈骗钱
    IrregularityType//违法（暴力恐怖，违禁品等）
};

@interface ChatComplainController : ZYZCBaseViewController
@property (nonatomic, copy )   NSString    *targetId;//被投诉者
@property (nonatomic, assign) ComplainType complainType;//投诉类型
@end
