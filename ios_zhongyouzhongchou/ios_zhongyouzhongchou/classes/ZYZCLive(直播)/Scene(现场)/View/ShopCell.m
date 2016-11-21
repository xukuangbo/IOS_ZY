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
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;

@property (nonatomic, strong) UIButton             *playBtn;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentButtonTopLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *praiseButtonTopLayout;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLaoutHeight;

@end

@implementation ShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 4;
    CGColorRef cgColor = [UIColor whiteColor].CGColor;
    [self.headerImageView.layer setBorderColor:cgColor];
    [self.headerImageView.layer setBorderWidth:1];
    
    self.backgroundImage.image = KPULLIMG(@"scene_cell_background_image", 0, 0, 5, 0);
//    self.backgroundImage.layer.masksToBounds = YES;
//    self.backgroundImage.layer.cornerRadius = 4;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 4;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tap:)];
    [self.imageView addGestureRecognizer:tap];
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0,12, 0, 0);
    self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
    self.commentButton.userInteractionEnabled = YES;
    self.praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0,12, 0, 0);
    self.praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
    self.praiseButton.userInteractionEnabled = YES;
    
    [self.commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"scene_play"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
    }];
}

- (void)setModel:(ZYFootprintListModel *)model
{
    _model = model;
    if (model.footprintType == 1) {
        self.playBtn.hidden = YES;
        NSArray * imageUrlArray = [model.pics componentsSeparatedByString:@","];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[0]] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    } else {
        self.playBtn.hidden = NO;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.videoimg] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    if ([model.realName length] != 0) {
        self.titleLab.text = [NSString stringWithFormat:@"%@",model.realName];
    } else {
        self.titleLab.text = model.realName;
    }
    [self.commentButton setTitle:[NSString stringWithFormat:@"%zd", model.commentTotles] forState:UIControlStateNormal];
    CGFloat cellWidth = (KSCREEN_W - 30) / 2.0 - 20.0;

    CGSize sceneSize = [model.content boundingRectWithSize:CGSizeMake(cellWidth, 1000.0f)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}
                                                   context:nil].size;
    self.contentLabelLaoutHeight.constant = (floorf(sceneSize.height));
    if ([model.content length] != 0) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    } else {
        self.contentLabel.text = @"";
    }

    if (model.hasZan) {
        [self.praiseButton setImage:[UIImage imageNamed:@"footprint-like-2"] forState:UIControlStateNormal];
    } else {
        [self.praiseButton setImage:[UIImage imageNamed:@"footprint-like"] forState:UIControlStateNormal];
    }
    self.praiseButton.tag = [model.userId integerValue];
    NSDictionary *dict = [ZYZCTool dictionaryWithJsonString:model.gpsData];
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
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd", model.zanTotles] forState:UIControlStateNormal];
}

#pragma mark - event
- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock();
    }
}

- (void)comment:(UIButton *)sender
{
    if (self.commentBlock) {
        self.commentBlock();
    }
}

-(void)praise:(UIButton *)sender
{
    if (self.praiseBlock) {
        self.praiseBlock(sender);
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.playBlock) {
        self.playBlock();
    }
}

@end
