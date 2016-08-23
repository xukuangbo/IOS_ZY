//
//  MoreFZCToolBarType.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    MoreFZCToolBarTypeGoal = KFZC_MOREFZCTABLEVIEW_TYPE,
    MoreFZCToolBarTypeRaiseMoney,
    MoreFZCToolBarTypeTravel,
    MoreFZCToolBarTypeReturn
}MoreFZCToolBarType;

@protocol MoreFZCToolBarDelegate <NSObject>

- (void)toolBarWithButton:(NSInteger )buttonTag;
@end


@interface MoreFZCToolBar : UIView
@property (nonatomic, strong) UIButton *preClickBtn;
@property (nonatomic, weak) id<MoreFZCToolBarDelegate> delegate;
- (void)buttonClickAction:(UIButton *)button;
@end
