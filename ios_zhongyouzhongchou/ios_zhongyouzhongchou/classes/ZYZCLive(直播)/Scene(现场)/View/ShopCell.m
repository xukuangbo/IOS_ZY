//
//  ShopCell.m
//  瀑布流
//
//  Created by 任玉飞 on 16/7/1.
//  Copyright © 2016年 任玉飞. All rights reserved.
//

#import "ShopCell.h"
#import "ZYLiveSceneModel.h"
#import "UIImageView+WebCache.h"

@interface ShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ZYLiveSceneModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.videoimg] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.titleLab.text = [NSString stringWithFormat:@"%f",model.videosize];
    
}
@end
