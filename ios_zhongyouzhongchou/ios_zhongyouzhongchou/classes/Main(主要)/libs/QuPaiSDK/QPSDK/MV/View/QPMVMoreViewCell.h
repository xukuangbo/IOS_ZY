//
//  MVMoreViewCell.h
//  qupai
//
//  Created by yly on 15/2/9.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPMusicMoreDownProgressView.h"
#import "QPEffectMV.h"
//#import "ShopItem.h"
//@class ShopItem;
@protocol QPMVMoreViewCellDelegate;

@interface QPMVMoreViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *useButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *playerView;
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewNew;
@property (weak, nonatomic) IBOutlet QPMusicMoreDownProgressView *downProgressView;
@property (weak, nonatomic) id<QPMVMoreViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) QPEffectMV *effectMV;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionConstraintVerticalSpace;

- (IBAction)playButtonClick:(id)sender;
- (IBAction)downButtonClick:(id)sender;
- (IBAction)useButtonClick:(id)sender;

- (void)showDetailView;
- (void)closeDetailView;

- (void)updateFrame;

@end

@protocol QPMVMoreViewCellDelegate <NSObject>

- (void)mvMoreViewCellPlay:(QPMVMoreViewCell *)cell;
- (void)mvMoreViewCellStop:(QPMVMoreViewCell *)cell;
- (void)mvMoreViewCellUse:(QPMVMoreViewCell *)cell;
- (void)mvMoreViewCellClose:(QPMVMoreViewCell *)cell;
- (void)mvMoreViewCellDown:(QPMVMoreViewCell *)cell;
//- (BOOL)mvMoreViewCellCanDown:(MVMoreViewCell *)cell;

@end