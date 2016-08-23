//
//  MoreFZCRaiseMoneySecondCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZCContentEntryView.h"
#define RAISECECONDHEIGHT 60+CONTENTHEIGHT
typedef enum{
    recordButtonTypeWord = 55,//语言描述
    recordButtonTypeSound,//声音录入
    recordButtonTypeMovie//录制视频
}recordButtonType;
@class FZCContentEntryView;
@interface MoreFZCRaiseMoneySecondCell : UITableViewCell


@property (nonatomic, weak) UIImageView *bgImageView;
/**
 *  用于该位置的view
 */
@property (nonatomic, weak) UIView *changeView;

@property (nonatomic, weak) UILabel *discLab;

@property (nonatomic, strong) FZCContentEntryView *contentEntryView;
@end
