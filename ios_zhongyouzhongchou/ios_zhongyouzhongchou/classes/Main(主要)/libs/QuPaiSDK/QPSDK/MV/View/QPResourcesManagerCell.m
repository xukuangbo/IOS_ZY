//
//  ResourcesManagerCell.m
//  qupai
//
//  Created by yly on 14/11/27.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import "QPResourcesManagerCell.h"

@implementation QPResourcesManagerCell

- (void)awakeFromNib {
    self.constraintsViewLine.constant = 1.0f/[[UIScreen mainScreen] scale];
    _imageViewIcon.layer.masksToBounds = YES;
    _imageViewIcon.layer.cornerRadius = 34.5;
    _buttonDelete.backgroundColor = [UIColor redColor];
    _buttonDelete.layer.masksToBounds = YES;
    _buttonDelete.layer.cornerRadius = 14;
}

-(void)setEffectMV:(QPEffectMV *)effectMV {
    _effectMV = effectMV;
    _imageViewIcon.image = [UIImage imageWithContentsOfFile:effectMV.icon];
    _labelTop.text = effectMV.name;
    if (effectMV.description) {
        _labelBotttom.text = effectMV.description;
    }
}


- (IBAction)buttonDeleteClick:(id)sender {
    [_delegate resourcesManagerCellDelete:self];
}

@end
