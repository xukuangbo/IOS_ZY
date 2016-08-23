//
//  TacticTableView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TacticModel;
@interface TacticTableView : UITableView

@property (nonatomic, weak) UIButton *searchBarBtn;

@property (nonatomic, strong) TacticModel *tacticModel;

- (void)changeNaviAction;
@end
