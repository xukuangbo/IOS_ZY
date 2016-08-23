//
//  TacticImageView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define IOS8 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0
#import "TacticImageView.h"
#import "TacticSingleViewController.h"
#import "TacticVideoModel.h"
#import "TacticSingleFoodModel.h"
#import "TacticSingleModel.h"
#import "ZYZCPlayViewController.h"
#import "TacticSingleViewController.h"
#import "TacticSingleFoodVC.h"
#import "TacticGeneralVC.h"
#import "ZCWebViewController.h"
#import "MineWantGoModel.h"
#import "TacticMoreCitiesModel.h"

@interface TacticImageView ()<UIAlertViewDelegate>

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIImageView *startImg;

@end

@implementation TacticImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //添加圆角
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        //给button提那家一个底部的透明图
        CGFloat greenBGViewW = frame.size.width;
        CGFloat greenBGViewH = 20;
        CGFloat greenBGViewX = 0;
        CGFloat greenBGViewY = frame.size.height - greenBGViewH;
        UIView *greenBGView = [[UIView alloc] initWithFrame:CGRectMake(greenBGViewX, greenBGViewY, greenBGViewW, greenBGViewH)];
        greenBGView.backgroundColor = [UIColor ZYZC_MainColor];
        greenBGView.alpha = 0.7;
        [self addSubview:greenBGView];
        
        //给button添加一个底部的label
        CGFloat labelW = frame.size.width;
        CGFloat labelH = 20;
        CGFloat labelX = 0;
        CGFloat labelY = frame.size.height - labelH;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        //创建一个播放按钮
        UIImageView *startImg=[[UIImageView alloc]init];
        startImg.bounds=CGRectMake(0, 0, self.width/3, self.height/3);
        startImg.center=CGPointMake(self.width/2, self.height/2);
        startImg.image=[UIImage imageNamed:@"btn_v_on"];
        startImg.hidden = YES;
        [self addSubview:startImg];
        self.startImg = startImg;
        
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTacticVideoModel:(TacticVideoModel *)tacticVideoModel
{
    
    _tacticVideoModel = tacticVideoModel;
    
    self.nameLabel.text = tacticVideoModel.name;
    self.viewType = tacticVideoModel.viewType;
    self.pushType = threeMapViewTypeVideo;
    self.startImg.hidden = NO;
    [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticVideoModel.videoImg)] forState:UIControlStateNormal];
}

- (void)setTacticSingleModel:(TacticSingleModel *)tacticSingleModel
{
    _tacticSingleModel = tacticSingleModel;
    
    self.nameLabel.text = tacticSingleModel.name;
    self.viewType = tacticSingleModel.viewType;
    if (tacticSingleModel.viewType == 1) {
        self.pushType = threeMapViewTypeCountryView;
        [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleModel.min_viewImg)] forState:UIControlStateNormal];
    }else if(tacticSingleModel.viewType == 2) {
        self.pushType = threeMapViewTypeCityView;
        [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleModel.min_viewImg)] forState:UIControlStateNormal];
    }else if(tacticSingleModel.viewType == 3) {
        self.pushType = threeMapViewTypeSingleView;
        [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleModel.min_viewImg)] forState:UIControlStateNormal];
    }
    
}

- (void)setTacticSingleFoodModel:(TacticSingleFoodModel *)tacticSingleFoodModel
{
    _tacticSingleFoodModel = tacticSingleFoodModel;
    self.pushType = threeMapViewTypeFood;
    self.nameLabel.text = tacticSingleFoodModel.name;
    [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleFoodModel.min_foodImg)] forState:UIControlStateNormal];
}

- (void)setTacticMoreCitiesModel:(TacticMoreCitiesModel *)tacticMoreCitiesModel
{
    _tacticMoreCitiesModel = tacticMoreCitiesModel;
    self.pushType = threeMapViewTypeCityView;
    self.nameLabel.text = tacticMoreCitiesModel.name;
    [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticMoreCitiesModel.min_viewImg)] forState:UIControlStateNormal];
}

- (void)setMineWantGoModel:(MineWantGoModel *)mineWantGoModel
{
    _mineWantGoModel = mineWantGoModel;
//    self.pushType = threeMapViewTypeFood;
    self.nameLabel.text = mineWantGoModel.name;
    [self sd_setImageWithURL:[NSURL URLWithString:KWebImage(mineWantGoModel.viewImg)] forState:UIControlStateNormal];
}

//这里写个跳转到单个景点
- (void)clickAction:(UIButton *)button
{
    if (self.pushType == threeMapViewTypeVideo) {
        //如果是视频播放
        [self judgeCurrentNetworkStatus];

    }else if(self.pushType == threeMapViewTypeCountryView || self.pushType == threeMapViewTypeCityView) {
        //说明是国家或者城市
        if (self.mineWantGoModel) {//想去
            TacticSingleViewController *singleVC = [[TacticSingleViewController alloc] initWithViewId:self.mineWantGoModel.ID];
            [self.viewController.navigationController pushViewController:singleVC animated:YES];
            return;
        }else if (self.tacticSingleModel){//国家或城市
            TacticSingleViewController *singleVC = [[TacticSingleViewController alloc] initWithViewId:self.tacticSingleModel.ID];
            [self.viewController.navigationController pushViewController:singleVC animated:YES];
            return;
        }else if (self.tacticMoreCitiesModel){//更多城市
            TacticSingleViewController *singleVC = [[TacticSingleViewController alloc] initWithViewId:self.tacticMoreCitiesModel.id];
            [self.viewController.navigationController pushViewController:singleVC animated:YES];
            return;
        }
    }else if(self.pushType == threeMapViewTypeSingleView) {
        //说明是一般景点
        TacticGeneralVC *generalVC = [[TacticGeneralVC alloc] initWithViewId:self.tacticSingleModel.ID];
        
        [self.viewController.navigationController pushViewController:generalVC animated:YES];
    }else if (self.pushType == threeMapViewTypeFood){
        //说明是食物
        TacticSingleFoodVC *foodVC = [[TacticSingleFoodVC alloc] init];
        
        foodVC.tacticSingleFoodModel = self.tacticSingleFoodModel;
        
        [self.viewController.navigationController pushViewController:foodVC animated:YES];
    }
}

#pragma mark --- 判断当前网络
-(void)judgeCurrentNetworkStatus
{
    //获取当前网络状态
    int networkType=[ZYZCTool getCurrentNetworkStatus];
    //无网络
    if (networkType==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"当前无网络" message:@"无法播放视屏,请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=0;
        [alert show];
        return;
    }
    //无Wi-Fi
    else if(networkType!=5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"【流量使用提示】" message:@"当前网络无Wi-Fi,继续播放可能会被运营商收取流量费用" delegate:self cancelButtonTitle:@"停止播放" otherButtonTitles:@"继续播放", nil];
        alert.tag=1;
        [alert show];
        return;
    }
    //有wifi
    else
    {
        [self playVideo];
    }
}

#pragma mark --- 点击继续播放网络视屏
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1&&buttonIndex==1) {
        [self playVideo];
    }
}

#pragma mark --- 播放视频
-(void)playVideo
{
    NSRange range=[self.tacticVideoModel.videoUrl rangeOfString:@".html"];
    if (range.length) {//网页
        ZCWebViewController *webController=[[ZCWebViewController alloc]init];
        webController.requestUrl=self.tacticVideoModel.videoUrl;
        webController.myTitle=@"视频播放";
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webController animated:YES completion:nil];
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {//视频
        ZYZCPlayViewController *playVC = [[ZYZCPlayViewController alloc] init];
        playVC.urlString = self.tacticVideoModel.videoUrl;
        [self.viewController presentViewController:playVC animated:YES completion:nil];
        return;
    }
}

@end
