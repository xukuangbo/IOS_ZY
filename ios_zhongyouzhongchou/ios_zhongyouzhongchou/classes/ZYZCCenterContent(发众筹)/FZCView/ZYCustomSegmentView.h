//
//  ZYCustomSegmentView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChangeSelectIndex)(NSInteger index);
@interface ZYCustomSegmentView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy  ) ChangeSelectIndex changeSelectIndex;

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

@end
