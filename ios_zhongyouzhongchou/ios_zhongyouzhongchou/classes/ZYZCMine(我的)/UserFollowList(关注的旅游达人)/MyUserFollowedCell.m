//
//  MyUserFollowedCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//


#define MyUserCornerRadius 5
#define MyUserTextMargin 5
#define MyUserFollowedCellNameLabelFont 16
#import "MyUserFollowedCell.h"
#import "MyUserFollowedModel.h"
@interface MyUserFollowedCell()

@property (nonatomic, weak) UIView *mapView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  名字
 */
@property (nonatomic, weak) UILabel *nameLabel;

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *sexImageView;
/**
 *  认证
 */
@property (nonatomic, weak) UIImageView *vipView;
/**
 *  工作
 */
@property (nonatomic, weak) UILabel *jobLabel;

@end

@implementation MyUserFollowedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor ZYZC_BgGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //这里写创建的代码,固定高度的cell，所以位置可以直接写
        CGFloat mapViewX = KEDGE_DISTANCE;
        CGFloat mapViewY = MyUserTextMargin;
        CGFloat mapViewW = KSCREEN_W - KEDGE_DISTANCE * 2;
        CGFloat mapViewH = MyUserFollowedCellHeight - MyUserTextMargin * 2;
        UIView * mapView = [[UIView alloc] initWithFrame:CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH)];
        mapView.layer.cornerRadius = MyUserCornerRadius;
        mapView.layer.masksToBounds = YES;
        [self.contentView addSubview:mapView];
        mapView.backgroundColor = [UIColor whiteColor];
        self.mapView = mapView;
        
        //头像
        CGFloat iconViewX = KEDGE_DISTANCE;
        CGFloat iconViewY = KEDGE_DISTANCE;
        CGFloat iconViewWH = MyUserFollowedCellHeight - 2 * (MyUserTextMargin + KEDGE_DISTANCE);
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH)];
        iconView.layer.cornerRadius = MyUserCornerRadius;
        iconView.layer.masksToBounds = YES;
        iconView.image = [UIImage imageNamed:@"icon_placeholder"];
        [self.mapView addSubview:iconView];
        self.iconView = iconView;
        
        //名字
        CGFloat nameLabelX = iconView.right + 10;
        CGFloat nameLabelY = iconView.top;
        CGFloat nameLabelW = 100;
        CGFloat nameLabelH = 20;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
        nameLabel.textColor = [UIColor ZYZC_TextBlackColor];
        [self.mapView addSubview:nameLabel];
        nameLabel.font = [UIFont systemFontOfSize:MyUserFollowedCellNameLabelFont];
        nameLabel.text = @"名字呢";
        self.nameLabel = nameLabel;
        
        //性别
        CGFloat sexImageViewX = nameLabel.right + MyUserTextMargin;
        CGFloat sexImageViewY = iconView.top;
        CGFloat sexImageViewWH = 20;
        UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sexImageViewX, sexImageViewY, sexImageViewWH, sexImageViewWH)];
        sexImageView.image = [UIImage imageNamed:@"btn_sex_fem"];
        [self.mapView addSubview:sexImageView];
        self.sexImageView = sexImageView;
        
        //认证
//        CGFloat vipViewX = sexImageView.right;
//        CGFloat vipViewY = iconView.top;
//        CGFloat vipViewWH = 20;
//        UIImageView *vipView = [[UIImageView alloc] initWithFrame:CGRectMake(vipViewX, vipViewY, vipViewWH, vipViewWH)];
//        [self.mapView addSubview:vipView];
//        vipView.image = [UIImage imageNamed:@"ico_renzheng"];
//        self.vipView = vipView;
        
        //工作
        CGFloat jobLabelX = nameLabel.left;
        CGFloat jobLabelW = KSCREEN_W - nameLabel.left - KEDGE_DISTANCE * 3;
        CGFloat jobLabelH = 20;
        CGFloat jobLabelY = iconView.bottom - jobLabelH;
        UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(jobLabelX, jobLabelY, jobLabelW, jobLabelH)];
        jobLabel.font = [UIFont systemFontOfSize:MyUserFollowedCellNameLabelFont];
        jobLabel.textColor = [UIColor ZYZC_TextGrayColor];
//        descLabel.text = @"这是一个很牛逼的应用";
        [self.mapView addSubview:jobLabel];
        self.jobLabel = jobLabel;
        
    }
    return self;
}

- (void)setUserFollowModel:(MyUserFollowedModel *)userFollowModel
{
    _userFollowModel = userFollowModel;
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:userFollowModel.faceImg] placeholderImage:nil options:options];
    CGSize nameSize = [ZYZCTool calculateStrLengthByText:userFollowModel.userName andFont:_nameLabel.font andMaxWidth:MAXFLOAT];
    _nameLabel.text = userFollowModel.userName;
    _nameLabel.size = nameSize;
    
    _sexImageView.image = [userFollowModel.sex integerValue] == 1?[UIImage imageNamed:@"btn_sex_mal"]:[UIImage imageNamed:@"btn_sex_fem"];
    _sexImageView.left = _nameLabel.right + MyUserTextMargin;
    
//    _vipView.left = _sexImageView.right;
//    _vipView.size = CGSizeMake(nameSize.height, nameSize.height);
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
    //如果有数据的话
    if (jobString.length > 0) {
        
        _jobLabel.hidden = NO;
        _jobLabel.text = jobString;
    }else{
        _jobLabel.hidden = YES;
    }
    
}
@end
