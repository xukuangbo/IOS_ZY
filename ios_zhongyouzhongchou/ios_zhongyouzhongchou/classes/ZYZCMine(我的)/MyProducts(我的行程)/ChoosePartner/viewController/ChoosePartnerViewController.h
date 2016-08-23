//
//  ChoosePartnerViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "TogetherUersModel.h"
typedef void (^AddPartnerSuccess)();
@interface ChoosePartnerViewController : ZYZCBaseViewController
@property (nonatomic, strong) NSNumber  *productId;
@property (nonatomic, copy  ) AddPartnerSuccess addPartnerSuccess;
@end
