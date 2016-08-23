//
//  ChooseSceneImgController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
typedef void (^ChooseImageBolck)(NSString *imgUrl);
@interface ChooseSceneImgController : ZYZCBaseViewController

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) NSArray *viewIds;
@property (nonatomic, strong) ChooseImageBolck chooseImageBolck;

@end
