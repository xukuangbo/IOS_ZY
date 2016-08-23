//
//  ChooseStarView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock)(NSInteger num);
@interface ChooseStarView : UIView
@property (nonatomic, strong) NSNumber *star;
@property (nonatomic, copy  ) ClickBlock clickBlock;
@end
