//
//  ZCOutHttpView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCNoneDataView : UIView
@property (nonatomic, weak ) IBOutlet UIImageView *iconView;
@property (nonatomic, weak)  IBOutlet UILabel *lab01;
@property (nonatomic, weak)  IBOutlet UILabel *lab02;

@property (nonatomic, assign) NSInteger myZCType;
@end
