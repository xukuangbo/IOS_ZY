//
//  MoreFZCChooseSceneController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "ZYZCViewSpotModel.h"
typedef void(^GetOneScenceBlock)(NSString *scence);
typedef void(^GetOneSpotModel) (OneSpotModel *model);

@interface MoreFZCChooseSceneController : ZYZCBaseViewController
@property (nonatomic, copy  ) GetOneScenceBlock getOneScene;
@property (nonatomic, copy  ) GetOneSpotModel   getOneSpotModel;
@property (nonatomic, strong) NSArray *mySceneArr;

@property (nonatomic, assign) BOOL isHomeSearch;

@property (nonatomic, assign) BOOL isStartDest;

@end
