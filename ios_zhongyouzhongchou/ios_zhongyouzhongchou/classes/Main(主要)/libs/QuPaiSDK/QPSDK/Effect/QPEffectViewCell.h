//
//  QPEffectViewCell.h
//  QupaiSDK
//
//  Created by yly on 15/6/17.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ICON_WIDTH 30
@interface QPEffectViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFrame;

@end
