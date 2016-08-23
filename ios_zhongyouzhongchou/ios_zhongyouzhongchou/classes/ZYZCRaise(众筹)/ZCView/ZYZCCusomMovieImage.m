//
//  ZYZCCusomMovieImage.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define IOS8 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0

#import "ZYZCCusomMovieImage.h"
#import "ZYZCPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZYZCAVPlayer.h"
#import "ZCWebViewController.h"
//#import "ZYVoicePlayer.h"

@interface ZYZCCusomMovieImage ()<UIAlertViewDelegate>
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic, strong) UIImageView *startImg;

@property (nonatomic, assign) BOOL hasNetworkAlert;

@end

@implementation ZYZCCusomMovieImage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode=UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds=YES;
        self.userInteractionEnabled=YES;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.layer.cornerRadius=KCORNERRADIUS;
    self.layer.masksToBounds=YES;
    self.backgroundColor=[UIColor ZYZC_BgGrayColor];
    
    _startImg=[[UIImageView alloc]init];
    _startImg.bounds=CGRectMake(0, 0, 60, 60);
    _startImg.center=CGPointMake(self.width/2, self.height/2);
    _startImg.image=[UIImage imageNamed:@"btn_v_on"];
    [self addSubview:_startImg];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playMovie:)];
    [self addGestureRecognizer:tap];
}

-(void)changeFrame
{
    _startImg.center=CGPointMake(self.width/2, self.height/2);;
}

-(void)playMovie:(UITapGestureRecognizer *)tap
{
    //如果播放视屏时有语音正在播放，通知语音停止
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopVoice" object:nil];
    
    if (_playUrl) {
//        NSLog(@"播放视频");
//        AVPlayer *player=[AVPlayer playerWithURL:[NSURL URLWithString:self.playUrl]];
//        [player play];
//        [ZYZCAVPlayer sharedZYZCAVPlayer].player = player;
//        [self addSubview:[ZYZCAVPlayer sharedZYZCAVPlayer].view];
//        [[ZYZCAVPlayer sharedZYZCAVPlayer].view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
        //这里尝试推送到一个新的控制器
        //如果是本地视屏
        NSRange range=[_playUrl rangeOfString:KMY_ZHONGCHOU_FILE];
        if (range.length){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            if (!_moviePlayer) {
                NSURL *url=[NSURL fileURLWithPath:self.playUrl];
                _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
                _moviePlayer.view.frame=CGRectMake(0, KSCREEN_H, KSCREEN_W, KSCREEN_H);
                 _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
                _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_moviePlayer.view];
            }
            __weak typeof (&*self)weakSelf=self;
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.moviePlayer.view.top=0;
            } completion:^(BOOL finished) {
                [_moviePlayer play];
            }];
        }
        //网络视屏
        else{
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
                [self playNetVideo];
            }
        }
    }
}

#pragma mark --- 播放网络视屏
-(void)playNetVideo
{
    NSRange range=[_playUrl rangeOfString:@".html"];
    if (range.length) {
        ZCWebViewController *webController=[[ZCWebViewController alloc]init];
        webController.requestUrl=_playUrl;
        webController.myTitle=@"视频播放";
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webController animated:YES completion:nil];
        return;
    }
    if (IOS8) {
        ZYZCPlayViewController *playVC = [[ZYZCPlayViewController alloc] init];
        playVC.urlString = self.playUrl;
        [self.viewController presentViewController:playVC animated:YES completion:nil];
        
    }
}

#pragma mark --- 播放结束
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    __weak typeof (&*self)weakSelf=self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.moviePlayer.view.top=KSCREEN_H ;
    } completion:^(BOOL finished) {
    }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1&&buttonIndex==1) {
        [self playNetVideo];
    }
}

-(void)dealloc{
//    NSLog(@"dealloc:%@",self.class);
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
