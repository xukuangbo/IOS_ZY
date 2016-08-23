//
//  UserIconButton.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserIconButton : UIButton

@property (nonatomic, strong) UserModel *partnerModel;

@property (nonatomic, assign) BOOL         isChoose;

//@property (nonatomic, assign) BOOL         enableChoose;

@end
