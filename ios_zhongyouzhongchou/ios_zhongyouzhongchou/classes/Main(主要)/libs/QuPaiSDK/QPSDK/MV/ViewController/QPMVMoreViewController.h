//
//  MVMoreViewController.h
//  qupai
//
//  Created by yly on 15/2/9.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//


#import "QPMVMoreViewCell.h"
#import "QPMVMoreGroupViewCell.h"
#import "QPMVMoreDownView.h"

@protocol QPMVMoreViewControllerDelegate;

@interface QPMVMoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet QPMVMoreGroupViewCell *moreGroupCell;
@property (weak, nonatomic) id<QPMVMoreViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *maskViewUp;
@property (weak, nonatomic) IBOutlet UIView *maskViewDown;
@property (weak, nonatomic) IBOutlet UILabel *offlineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewUpHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewDownHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeightConst;

@property (weak, nonatomic) IBOutlet UIButton *closeCellButton;
@property (weak, nonatomic) IBOutlet QPMVMoreDownView *downView;

- (IBAction)buttonCloseClick:(id)sender;
- (IBAction)buttonManagerClick:(id)sender;

- (IBAction)maskViewUpClick:(id)sender;
- (IBAction)maskViewDownClick:(id)sender;

- (IBAction)buttonCellCloseClick:(id)sender;
@end

@protocol QPMVMoreViewControllerDelegate <NSObject>

- (void)mvMoreViewController:(QPMVMoreViewController *)controler useItem:(QPEffectMV *)item;
- (void)mvMoreViewControllerClose:(QPMVMoreViewController *)controler downID:(NSArray *)downID isNew:(BOOL)isNew;

@end