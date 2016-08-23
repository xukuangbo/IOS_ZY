//
//  FZCBaseViewController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
typedef void(^ConfirmBlock)();
@interface FZCBaseViewController : ZYZCBaseViewController
-(void)createBottomView;
@property(nonatomic,copy)ConfirmBlock confirmBlock;
@property(nonatomic,strong)UIButton *sureBtn;
-(void)clickBtn;
@end
