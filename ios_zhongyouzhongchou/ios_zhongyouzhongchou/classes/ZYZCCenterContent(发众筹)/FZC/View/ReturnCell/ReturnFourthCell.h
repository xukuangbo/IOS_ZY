//
//  ReturnFourthCell.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ReturnFourthCellHeight 367+175*KCOFFICIEMNT+45
#import <UIKit/UIKit.h>
#import "ReturnCellBaseBGView.h"
#define ReturnFourthCellMargin 10

@interface ReturnFourthCell : UITableViewCell
@property (nonatomic, weak) ReturnCellBaseBGView *bgImageView;


/**
 *  金额选取的view
 */
@property (nonatomic, weak) UIImageView *peopleMoneyView;
/**
 *  金钱label
 */
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, assign) BOOL open;

- (void)reloadManagerData;
@end
