//
//  MVMoreGroupViewCell.h
//  qupai
//
//  Created by yly on 15/4/14.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPMVMoreGroup.h"
#import "QPEffectMV.h"
@interface QPMVMoreGroupViewCell : UICollectionViewCell

@property (nonatomic, strong) QPMVMoreGroup *group;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id controller;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UILabel *offlineLabel;

- (void)cancelSelect;
- (void)checkReplay;
@end

@protocol QPMVMoreGroupViewCellDelegate <NSObject>

- (void)mvMoreGroupViewCell:(QPMVMoreGroupViewCell *)cell maskViewFrame:(CGRect)rect enable:(BOOL)enable;
- (void)mvMoreGroupScaleItem:(QPEffectMV *)shopItem;
@end