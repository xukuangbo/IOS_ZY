//
//  ComplainViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
typedef void (^ComplainSuccess)();
@interface ComplainViewController : ZYZCBaseViewController

@property (nonatomic, strong) NSNumber       *productId;

@property (nonatomic, strong) NSNumber       *type;//1：一起游；2回报

@property (nonatomic, strong) NSNumber       *role;//1：参与人投诉发起人；2发起人投诉参与人
@property (nonatomic, copy  ) ComplainSuccess  complainSuccess;

@end
