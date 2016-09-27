//
//  LivePersonDataView.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MinePersonSetUpModel;
@interface LivePersonDataView : UIView
/** 空间 */
@property (nonatomic, strong) UIButton *roomButton;
/** 众筹 */
@property (nonatomic, strong) UIButton *zhongchouButton;
// 关注按钮
@property (nonatomic, strong) UIButton *attentionButton;
// 禁言
@property (nonatomic, strong) UIButton *bannedSpeakButton;
- (void)showPersonData;

- (void)hidePersonDataView;

@property (nonatomic, strong) MinePersonSetUpModel *minePersonModel;
@end
