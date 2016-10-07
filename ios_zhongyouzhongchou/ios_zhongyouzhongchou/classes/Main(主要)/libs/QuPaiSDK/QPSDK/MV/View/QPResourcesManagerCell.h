//
//  ResourcesManagerCell.h
//  qupai
//
//  Created by yly on 14/11/27.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPEffectMV.h"

@protocol QPResourcesManagerCellDelegate;

@interface QPResourcesManagerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTop;
@property (weak, nonatomic) IBOutlet UILabel *labelBotttom;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsViewLine;
@property (nonatomic, weak) IBOutlet UIImageView *imageLine;

@property (nonatomic, strong) QPEffectMV *effectMV;
@property (nonatomic, weak) id<QPResourcesManagerCellDelegate> delegate;

- (IBAction)buttonDeleteClick:(id)sender;

@end

@protocol QPResourcesManagerCellDelegate <NSObject>

- (void)resourcesManagerCellDelete:(QPResourcesManagerCell*)cell;

@end
