//
//  MoreFZCViewController.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "MoreFZCToolBar.h"

typedef NS_ENUM(NSInteger, SaveBtnType)
{
    SkimType=KFZC_SAVE_TYPE,
    NextType,
    SaveType
};

@interface MoreFZCViewController : ZYZCBaseViewController

@property (nonatomic, weak) MoreFZCToolBar *toolBar;
/**
 *  承载4个tableview的view
 */
@property (nonatomic, weak) UIView *clearMapView;
/**
 *  承载3个底部button的view
 */
@property (nonatomic, strong) UIView *bottomView;

//是否来自草稿
@property (nonatomic, assign) BOOL editFromDraft;
//如果来自草稿，保存草稿项目编号
@property (nonatomic, strong) NSNumber *productId;

@end
