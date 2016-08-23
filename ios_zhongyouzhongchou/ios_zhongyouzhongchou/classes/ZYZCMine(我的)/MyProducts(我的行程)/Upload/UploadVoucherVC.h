//
//  UploadVoucherVC.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

typedef void (^UploadVoucherSuccess)();
@interface UploadVoucherVC : ZYZCBaseViewController

@property (nonatomic, strong) NSNumber *productID;

/**
 *  成功上传凭证后的操作
 */
@property (nonatomic, copy  ) UploadVoucherSuccess uploadVoucherSuccess;

@end
