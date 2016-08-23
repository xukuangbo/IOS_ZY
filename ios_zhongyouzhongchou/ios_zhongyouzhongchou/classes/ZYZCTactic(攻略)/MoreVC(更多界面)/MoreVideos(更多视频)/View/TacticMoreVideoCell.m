//
//  TacticMoreVideoCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMoreVideoCell.h"
#import "TacticVideoModel.h"
#import "ZYZCCusomMovieImage.h"
@interface TacticMoreVideoCell()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) ZYZCCusomMovieImage *videoImgView;
@property (nonatomic, strong) UIImageView *playButton;
@property (nonatomic, strong) UIImageView *greenBgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nameTextLabel;
@property (nonatomic, strong) UILabel *descTextLabel;
@end
@implementation TacticMoreVideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat bgViewX = KEDGE_DISTANCE;
        CGFloat bgViewY = 0;
        CGFloat bgViewW = KSCREEN_W - 2 * bgViewX;
        CGFloat bgViewH = TacticMoreVideoRowHeight;
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
        _bgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgView];
        _bgView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        
        CGFloat videoImgViewW = bgViewW;
        CGFloat videoImgViewH = videoImgViewW / 16.0 * 10;
        _videoImgView = [[ZYZCCusomMovieImage alloc] initWithFrame:CGRectMake(0, 0,videoImgViewW,videoImgViewH)];
        [_bgView addSubview:_videoImgView];
        
//        //播放按钮
//        CGFloat playButtonWH = 50 * KCOFFICIEMNT;
//        _playButton = [[UIImageView alloc] init];
//        _playButton.size = CGSizeMake(playButtonWH, playButtonWH);
//        _playButton.center = _videoImgView.center;
//        _playButton.image = [UIImage imageNamed:@"videoImg-1"];
//        _playButton.userInteractionEnabled = YES;
//        [_videoImgView addSubview:_playButton];
        //绿色背景
        _greenBgView=[[UIImageView alloc]initWithFrame:CGRectMake(-KEDGE_DISTANCE+2, KEDGE_DISTANCE, 50, 30)];
        _greenBgView.image=KPULLIMG(@"xjj_fuc", 0, 10, 0, 10);
        _greenBgView.alpha=0.7;
        [_bgView  addSubview:_greenBgView];
        //视频名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( KEDGE_DISTANCE, _greenBgView.top + 5, 0, 20)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:20];
//        _nameLabel.backgroundColor = [UIColor redColor];
        [_bgView addSubview:_nameLabel];
        
        //视屏名字
        _nameTextLabel = [[UILabel alloc] init];
        _nameTextLabel.origin = CGPointMake(KEDGE_DISTANCE, _videoImgView.bottom + 5);
        _nameTextLabel.width = _bgView.width - _nameTextLabel.left * 2;
        _nameTextLabel.height = 20;
//        _nameTextLabel.backgroundColor = [UIColor redColor];
        _nameTextLabel.font = [UIFont systemFontOfSize:15];
        _nameTextLabel.textColor = [UIColor ZYZC_TextBlackColor];
        [_bgView addSubview:_nameTextLabel];
        //视屏描述
        _descTextLabel = [[UILabel alloc] init];
        _descTextLabel.origin = CGPointMake(KEDGE_DISTANCE, _nameTextLabel.bottom + 2);
        _descTextLabel.size = CGSizeMake(_bgView.width - 20, 15);
        _descTextLabel.textColor = [UIColor lightGrayColor];
//        _descTextLabel.backgroundColor = [UIColor redColor];
        _descTextLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_descTextLabel];
}
    return self;
}


- (void)setTacticVideoModel:(TacticVideoModel *)tacticVideoModel
{
    _tacticVideoModel = tacticVideoModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    if (tacticVideoModel.videoImg) {
        [_videoImgView sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticVideoModel.videoImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        _videoImgView.playUrl=tacticVideoModel.videoUrl;
    }
    
    if (tacticVideoModel.name.length > 0) {
        CGSize textSize = [ZYZCTool calculateStrLengthByText:tacticVideoModel.name andFont:_nameLabel.font andMaxWidth:MAXFLOAT];
        _nameLabel.size = textSize;
        _nameLabel.text = tacticVideoModel.name;
        
        _greenBgView.width = textSize.width + 30;
        
        _nameTextLabel.text = tacticVideoModel.name;
    }
    
    if (tacticVideoModel.viewText.length > 0) {
        
        _descTextLabel.text = [tacticVideoModel.viewText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
}
@end
