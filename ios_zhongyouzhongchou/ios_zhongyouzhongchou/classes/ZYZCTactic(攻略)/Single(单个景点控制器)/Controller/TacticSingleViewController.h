//
//  TacticSingleViewController.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "TacticSingleModel.h"

#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#define TacticSingleHeadViewHeight (KSCREEN_W * 5 / 8.0)
@interface TacticSingleViewController : ZYZCBaseViewController

@property (nonatomic, strong) TacticSingleModel *tacticSingleModel;


/**
 *  用于网络请求的id
 */
@property (nonatomic, assign) NSInteger viewId;
/**
 *  初始化方法
 */
- (instancetype)initWithViewId:(NSInteger)viewId;
@end
