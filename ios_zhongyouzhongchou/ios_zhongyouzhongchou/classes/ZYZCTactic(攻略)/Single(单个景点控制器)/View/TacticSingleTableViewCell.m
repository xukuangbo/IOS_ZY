//
//  TacticSingleTableViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticSingleTableViewCell.h"
#import "TacticSingleModel.h"
#import "ZYZCCusomMovieImage.h"
#import "TacticSingleModelFrame.h"
#import "TacticCustomMapView.h"
#import "TacticThreeMapView.h"
#import "TacticSingleTipsModel.h"
#import "TacticSingleLongPicture.h"
#import "TacticSingleTipsController.h"
#import "TacticMoreVideosController.h"
#import "TacticSingleFoodVC.h"
#import "TacticSingleFoodModel.h"
#import "TacticMoreJieshaoVC.h"
@interface TacticSingleTableViewCell()<TacticCustomMapViewDelegate>
//描述
@property (nonatomic, weak) TacticCustomMapView *descView;
@property (nonatomic, weak) UILabel *descLabel;
//动画
@property (nonatomic, weak) TacticCustomMapView *flashView;
@property (nonatomic, weak) ZYZCCusomMovieImage *flashPlayButton;
//图文
@property (nonatomic, weak) TacticCustomMapView *pictureView;
@property (nonatomic, weak) TacticSingleLongPicture *pictureShowButton;
//小贴士
@property (nonatomic, weak) TacticCustomMapView *tipsView;
@property (nonatomic, weak) UIButton *tipsShowButton;

//必玩景点
@property (nonatomic, weak) TacticCustomMapView *mustPlayView;
@property (nonatomic, weak) TacticThreeMapView *mustPlayViewButton;

//特色美食
@property (nonatomic, weak) TacticCustomMapView *foodsView;
@property (nonatomic, weak) TacticThreeMapView *foodsPlayViewButton;
@end
@implementation TacticSingleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /**
         *  创建概况描述
         */
        [self createContentView];
        
    }
    return self;
}
/**
 *  创建概况描述
 */
- (void)createContentView
{
//    CGFloat textMargin = 4;
    //目的地概况
    TacticCustomMapView *descView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(0, 0,  KSCREEN_W - KEDGE_DISTANCE * 2, 120)];
    descView.titleLabel.text = @"目的地概况";
    descView.moreButton.hidden = NO;
    descView.delegate = self;
    descView.moreButton.tag = MoreVCTypeTypeMoreText;
    CGFloat descLabelH = descView.height - descLabelBottom - TacticTableViewCellTextMargin * 2;
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, descLabelBottom, descView.width - KEDGE_DISTANCE * 2, descLabelH)];
//    descLabel.backgroundColor = [UIColor ZYZC_BgGrayColor];
    descLabel.textColor = [UIColor ZYZC_TextGrayColor];
    descLabel.layer.cornerRadius = 5;
    descLabel.layer.masksToBounds = YES;
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.numberOfLines = 3;
    [self.contentView addSubview:descView];
    [descView addSubview:descLabel];
    self.descLabel = descLabel;
    self.descView = descView;
    //动画攻略
    CGFloat flashViewW = KSCREEN_W - KEDGE_DISTANCE * 2;
    CGFloat flashViewH = oneViewMapHeight;
    TacticCustomMapView *flashView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(0, 0,flashViewW, flashViewH)];
    flashView.titleLabel.text = @"视频攻略";
    [self.contentView addSubview:flashView];
    self.flashView = flashView;
    
    CGFloat flashPlayButtonW = flashViewW - KEDGE_DISTANCE * 2;
    CGFloat flashPlayButtonH = oneViewHeight;
    ZYZCCusomMovieImage *flashPlayButton = [[ZYZCCusomMovieImage alloc] initWithFrame:CGRectMake(0, 0, flashPlayButtonW, flashPlayButtonH)];
    flashPlayButton.layer.cornerRadius = 5;
    flashPlayButton.layer.masksToBounds = YES;
//    flashPlayButton.backgroundColor = [UIColor redColor];
    [flashView addSubview:flashPlayButton];
    self.flashPlayButton = flashPlayButton;
    
    //图文攻略
    CGFloat pictureViewW = KSCREEN_W - KEDGE_DISTANCE * 2;
    CGFloat pictureViewH = oneViewMapHeight;
    TacticCustomMapView *pictureView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(0, 0,pictureViewW, pictureViewH)];
    pictureView.titleLabel.text = @"图文攻略";
    [self.contentView addSubview:pictureView];
    self.pictureView = pictureView;
    
    TacticSingleLongPicture *pictureShowButton = [[TacticSingleLongPicture alloc] init];
    pictureShowButton.layer.cornerRadius = 5;
    pictureShowButton.layer.masksToBounds = YES;
//    pictureShowButton.backgroundColor = [UIColor redColor];
    [pictureView addSubview:pictureShowButton];
    self.pictureShowButton = pictureShowButton;
    
    //众游小贴士
    CGFloat tipsViewW = KSCREEN_W - KEDGE_DISTANCE * 2;
    CGFloat tipsViewH = oneViewMapHeight;
    TacticCustomMapView *tipsView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(0, 0,tipsViewW, tipsViewH)];
    tipsView.titleLabel.text = @"众游小贴士";
    tipsView.descLabel.text = @"最实用的旅行tips";
    [self.contentView addSubview:tipsView];
    self.tipsView = tipsView;
    
    UIButton *tipsShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipsShowButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    tipsShowButton.layer.cornerRadius = 5;
    tipsShowButton.layer.masksToBounds = YES;
//    tipsShowButton.backgroundColor = [UIColor redColor];
    [tipsView addSubview:tipsShowButton];
    [tipsShowButton addTarget:self action:@selector(tipsShowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tipsShowButton = tipsShowButton;
    
    //必玩景点
    CGFloat mustPlayViewW = KSCREEN_W - KEDGE_DISTANCE * 2;
    CGFloat mustPlayViewH = threeViewMapHeight;
    TacticCustomMapView *mustPlayView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(0, 0,mustPlayViewW, mustPlayViewH)];
    mustPlayView.titleLabel.text = @"必玩景点";
    [self.contentView addSubview:mustPlayView];
    self.mustPlayView = mustPlayView;
    
    CGFloat mustPlayViewButtonX = KEDGE_DISTANCE;
    CGFloat mustPlayViewButtonY = descLabelBottom + TacticTableViewCellTextMargin;
    CGFloat mustPlayViewButtonW = mustPlayView.width - KEDGE_DISTANCE * 2;
    CGFloat mustPlayViewButtonH = (KSCREEN_W - 10 * 6) / 3.0;
    TacticThreeMapView *mustPlayViewButton = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(mustPlayViewButtonX, mustPlayViewButtonY, mustPlayViewButtonW, mustPlayViewButtonH)];
    mustPlayView.moreButton.hidden = NO;
    mustPlayView.moreButton.tag = MoreVCTypeTypeCountryView;
    mustPlayView.delegate = self;
    mustPlayViewButton.layer.cornerRadius = 5;
    mustPlayViewButton.layer.masksToBounds = YES;
    [mustPlayView addSubview:mustPlayViewButton];
    self.mustPlayViewButton = mustPlayViewButton;
    
    //特色美食
    CGFloat foodsViewW = KSCREEN_W - KEDGE_DISTANCE * 2;
    CGFloat foodsViewH = threeViewMapHeight;
    TacticCustomMapView *foodsView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(0, 0,foodsViewW, foodsViewH)];
    foodsView.delegate = self;
//    foodsView.backgroundColor = [UIColor redColor];
    foodsView.titleLabel.text = @"特色美食";
    foodsView.descLabel.text = @"用味蕾探索世界";
    [self.contentView addSubview:foodsView];
    self.foodsView = foodsView;
    
    CGFloat foodsPlayViewButtonX = KEDGE_DISTANCE;
    CGFloat foodsPlayViewButtonY = descLabelBottom + TacticTableViewCellTextMargin;
    CGFloat foodsPlayViewButtonW = mustPlayView.width - KEDGE_DISTANCE * 2;
    CGFloat foodsPlayViewButtonH = (KSCREEN_W - 10 * 6) / 3.0;
    TacticThreeMapView *foodsPlayViewButton = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(foodsPlayViewButtonX, foodsPlayViewButtonY, foodsPlayViewButtonW, foodsPlayViewButtonH)];
    foodsPlayViewButton.threeMapViewType = threeMapViewTypeFood;
    foodsView.moreButton.hidden = NO;
    foodsView.moreButton.tag = MoreVCTypeTypeFood;
    foodsPlayViewButton.layer.cornerRadius = 5;
    foodsPlayViewButton.layer.masksToBounds = YES;
    [foodsView addSubview:foodsPlayViewButton];
    self.foodsPlayViewButton = foodsPlayViewButton;
}
#pragma mark - 点击跳转事件
/**
 *  小贴士播放
 */
- (void)tipsShowButtonAction:(UIButton *)button
{
    
    TacticSingleTipsController *tipsVC = [[TacticSingleTipsController alloc] init];
    tipsVC.tacticSingleTipsModel = self.tacticSingleModelFrame.tacticSingleModel.tips;
    [self.viewController.navigationController pushViewController:tipsVC animated:YES];
}
#pragma mark - 模型赋值
- (void)setTacticSingleModelFrame:(TacticSingleModelFrame *)tacticSingleModelFrame
{
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    _tacticSingleModelFrame = tacticSingleModelFrame;
    TacticSingleModel *tacticSingleModel = tacticSingleModelFrame.tacticSingleModel;
    TacticSingleTipsModel *tipsModel = tacticSingleModelFrame.tacticSingleModel.tips;
    self.descView.frame = tacticSingleModelFrame.descViewF;
    self.descView.descLabel.text = [NSString stringWithFormat:@"%@的小介绍哦",tacticSingleModel.name];
    self.descLabel.text = tacticSingleModel.viewText;
    
    
    self.flashView.frame = tacticSingleModelFrame.flashViewF;
    self.flashView.descLabel.text = [NSString stringWithFormat:@"%@最棒的旅行目的地",tacticSingleModel.name];
    self.flashPlayButton.frame = tacticSingleModelFrame.flashPlayButtonF;
    self.flashPlayButton.playUrl = tacticSingleModel.videoUrl;
    [self.flashPlayButton sd_setImageWithURL:[NSURL URLWithString:KWebImage(self.tacticSingleModelFrame.tacticSingleModel.videoImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    
    self.pictureView.frame = tacticSingleModelFrame.pictureViewF;
    self.pictureView.descLabel.text = [NSString stringWithFormat:@"一张图玩转%@",tacticSingleModel.name];
    self.pictureShowButton.frame = tacticSingleModelFrame.pictureShowButtonF;
    self.pictureShowButton.urlString = tacticSingleModel.glid;
    [self.pictureShowButton sd_setImageWithURL:[NSURL URLWithString:KWebImage(self.tacticSingleModelFrame.tacticSingleModel.glid)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    
    self.tipsView.frame = tacticSingleModelFrame.tipsViewF;
    //设置图片，跳转
    [self.tipsShowButton sd_setBackgroundImageWithURL:[NSURL URLWithString:KWebImage(tipsModel.tipsImg)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    self.tipsShowButton.frame = tacticSingleModelFrame.tipsShowButtonF;
    
    self.mustPlayView.frame = tacticSingleModelFrame.mustPlayViewF;
    self.mustPlayView.descLabel.text = [NSString stringWithFormat:@"%@最棒的旅行目的地",tacticSingleModel.name];
    self.mustPlayViewButton.singleViews = tacticSingleModel.mgViews;
    self.mustPlayViewButton.frame = tacticSingleModelFrame.mustPlayViewButtonF;
    
    self.foodsView.frame = tacticSingleModelFrame.foodsViewF;
    self.foodsPlayViewButton.foodsArray = tacticSingleModel.foods;
    self.foodsPlayViewButton.frame = tacticSingleModelFrame.foodsPlayViewButtonF;
}


#pragma mark - TacticCustomMapViewDelegate
- (void)pushToMoreVC:(UIButton *)button
{
    if (button.tag == MoreVCTypeTypeVideo) {
//        NSLog(@"我是更多视频");
    }else if (button.tag == MoreVCTypeTypeCountryView || button.tag == MoreVCTypeTypeCityView){
//        NSLog(@"我是更多景点");
        TacticMoreVideosController *moreVC = [[TacticMoreVideosController alloc] init];
        moreVC.title = @"更多景点";
        moreVC.moreArray = self.tacticSingleModelFrame.tacticSingleModel.mgViews;
        [self.viewController.navigationController pushViewController:moreVC animated:YES];
    }else if (button.tag == MoreVCTypeTypeFood){
//        NSLog(@"我是更多美食");
        TacticMoreVideosController *moreVC = [[TacticMoreVideosController alloc] init];
        moreVC.title = @"更多美食";
        moreVC.moreArray = self.tacticSingleModelFrame.tacticSingleModel.foods;
        [self.viewController.navigationController pushViewController:moreVC animated:YES];
    }else if (button.tag == MoreVCTypeTypeMoreText){
//        NSLog(@"我是更多介绍");
        
        TacticMoreJieshaoVC *jieshaoVC = [[TacticMoreJieshaoVC alloc] init];
        jieshaoVC.tacticSingleModel = self.tacticSingleModelFrame.tacticSingleModel;
        [self.viewController.navigationController pushViewController:jieshaoVC animated:YES];
        
    }
}
@end
