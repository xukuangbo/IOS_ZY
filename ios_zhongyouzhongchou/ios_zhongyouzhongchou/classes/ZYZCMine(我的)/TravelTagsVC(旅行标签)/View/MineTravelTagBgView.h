//
//  MineTravelTagBgView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MineTravelTagButtonH 30

@interface MineTravelTagBgView : UIImageView

@property (nonatomic, assign) NSInteger maxCount;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DetailTitle:(NSString *)detailTitle TitleArray:(NSArray *)titleArray PesonTitleArray:(NSArray *)personTitleArray;
@end
