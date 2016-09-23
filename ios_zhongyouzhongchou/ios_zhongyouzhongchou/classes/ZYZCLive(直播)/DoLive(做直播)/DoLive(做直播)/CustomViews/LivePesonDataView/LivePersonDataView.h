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

- (void)showPersonDataWithUserId:(NSString *)userId;

- (void)hidePersonDataView;

@property (nonatomic, strong) MinePersonSetUpModel *minePersonModel;
@end
