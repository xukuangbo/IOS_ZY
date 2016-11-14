//
//  MyUserFollowCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define MyUserCornerRadius 5
#define MyUserTextMargin 5
#define MyUserFollowedCellNameLabelFont 16
#import "MyUserFollowCell.h"
#import "MyUserFollowedModel.h"
#import "UIView+ZYLayer.h"
@interface MyUserFollowCell ()
@property (weak, nonatomic) IBOutlet MyUserFollowCell *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@end
@implementation MyUserFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _mapView.userInteractionEnabled = NO;
    
    _bgImageView.layerCornerRadius = 5;
    _bgImageView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _bgImageView.userInteractionEnabled = YES;
    
    _iconView.layerCornerRadius = 5;
    _iconView.image = [UIImage imageNamed:@"icon_placeholder"];
    
    _nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _nameLabel.font = [UIFont systemFontOfSize:MyUserFollowedCellNameLabelFont];
    _nameLabel.text = @"昵称";
    
    
    
    _jobLabel.font = [UIFont systemFontOfSize:MyUserFollowedCellNameLabelFont];
    _jobLabel.textColor = [UIColor ZYZC_TextGrayColor];
}


- (void)setUserFollowModel:(MyUserFollowedModel *)userFollowModel
{
    _userFollowModel = userFollowModel;
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    //1.头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:userFollowModel.faceImg] placeholderImage:nil options:options];
    
    //2.名字
    NSString *showName = userFollowModel.realName.length > 0 ? userFollowModel.realName : userFollowModel.userName;
    
    _nameLabel.text = showName;
    
    //3.性别
    _sexImageView.image = [userFollowModel.sex integerValue] == 1?[UIImage imageNamed:@"btn_sex_mal"]:[UIImage imageNamed:@"btn_sex_fem"];
    
    //4.工作
    NSString *jobString = [NSString string];
    if (userFollowModel.company.length > 0) {
        jobString = [NSString stringWithFormat:@"%@",userFollowModel.company];
        
    }
    if (userFollowModel.title.length > 0) {
        if (jobString.length > 0) {
            jobString = [jobString stringByAppendingString:[NSString stringWithFormat:@" %@",userFollowModel.title]];
        }else{
            jobString = [jobString stringByAppendingString:[NSString stringWithFormat:@"%@",userFollowModel.title]];
        }
    }
    //展示数据
    if (jobString.length > 0) {
        
        _jobLabel.hidden = NO;
        _jobLabel.text = jobString;
    }else{
        _jobLabel.hidden = YES;
        _jobLabel.text = @"职业还没显示";
    }
    
}
@end
