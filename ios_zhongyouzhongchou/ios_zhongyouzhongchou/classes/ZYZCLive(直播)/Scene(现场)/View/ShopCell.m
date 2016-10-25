//
//  ShopCell.m
//  瀑布流
//
//  Created by 任玉飞 on 16/7/1.
//  Copyright © 2016年 任玉飞. All rights reserved.
//

#import "ShopCell.h"
#import "ZYFootprintListModel.h"
#import "UIImageView+WebCache.h"

@interface ShopCell ()
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;

@property (nonatomic, strong) UIButton             *playBtn;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentButtonTopLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *praiseButtonTopLayout;

@end

@implementation ShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 4;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 4;

    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0,4, 0, 0);
    self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0,5, 0, 9);//
    
    self.praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0,4, 0, 0);
    self.praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0,5, 0, 9);
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"videoImg-1"] forState:UIControlStateNormal];
//    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
    }];
}

- (void)setModel:(ZYFootprintListModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.videoimg] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@",_model.userName];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%zd", _model.commentTotles] forState:UIControlStateNormal];
    if ([_model.content length] != 0) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",_model.content];
    }

    if (model.hasZan) {
        [self.praiseButton setImage:[UIImage imageNamed:@"footprint-like-2"] forState:UIControlStateNormal];
    } else {
        [self.praiseButton setImage:[UIImage imageNamed:@"footprint-like"] forState:UIControlStateNormal];
    }
    NSDictionary *dict = [ZYZCTool dictionaryWithJsonString:_model.gpsData];
    if ([dict[@"GPS_Address"] length] == 0) {
        self.locationLabel.hidden = YES;
        self.locationImage.hidden = YES;
        self.commentButtonTopLayout.constant = -25;
        self.praiseButtonTopLayout.constant = -25;
    } else {
        self.locationLabel.hidden = NO;
        self.locationImage.hidden = NO;
        self.commentButtonTopLayout.constant = 5;
        self.praiseButtonTopLayout.constant = 5;
        self.locationLabel.text = dict[@"GPS_Address"];
    }
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd", _model.zanTotles] forState:UIControlStateNormal];
}

#pragma mark - event
//- (void)play:(UIButton *)sender {
//    if (self.playBlock) {
//        self.playBlock(sender);
//    }
//}

@end
