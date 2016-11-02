//
//  ZYZCCustomVioceView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCCustomVoiceView.h"
#import "RecordSoundObj.h"
#import <AVFoundation/AVFoundation.h>
#import "ZYVoicePlayer.h"

#import "MLPlayVoiceButton.h"
#import "MLAudioPlayer.h"

@interface ZYZCCustomVoiceView ()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UIImageView *voiceView;
@property (nonatomic, strong) UIImageView *voiceImg;
@property (nonatomic, strong) UILabel     *timeLab;
@property (nonatomic, assign) BOOL        getStop;
@property (nonatomic, strong) RecordSoundObj *soundObj;
@property (nonatomic, strong) ZYVoicePlayer *avPlayer;
@property (nonatomic, assign) BOOL        hasGetUI;

//==================
//播放amr格式音频
@property (nonatomic, strong) MLPlayVoiceButton *playVoiceBtn;
@property (nonatomic, strong) MLAudioPlayer *player;

@end

@implementation ZYZCCustomVoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.height=40;
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        _iconImg.image=[UIImage imageNamed:@"icon_placeholder"];
        _iconImg.layer.cornerRadius=KCORNERRADIUS;
        _iconImg.layer.masksToBounds=YES;
        [self addSubview:_iconImg];
    }
    return self;
}

-(void)configCAF_UI
{
    _hasGetUI=YES;
    _voiceView=[[UIImageView alloc]initWithFrame:CGRectMake(_iconImg.right +KEDGE_DISTANCE, self.height-38, 50, 38)];
    _voiceView.image=KPULLIMG(@"voiceIcon",0,10,0,5);
    [self addSubview:_voiceView];
    _voiceView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(listenVoice:)];
    [_voiceView addGestureRecognizer:tap];
    
    _voiceImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 14, _voiceView.height)];
    _voiceImg.image=[UIImage imageNamed:@"horn3"];
    [_voiceView addSubview:_voiceImg];
    //
    NSMutableArray *imgArr=[NSMutableArray array];
    for (int i=0; i<3; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"horn%d",i+1]];
        [imgArr addObject:image];
    }
    _voiceImg.animationImages=imgArr;
    _voiceImg.animationDuration = 0.6;
    _voiceImg.animationRepeatCount = 0;
    
    
    //    语音时长
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_voiceView.right+KEDGE_DISTANCE, self.height-30, self.width-_voiceView.right-KEDGE_DISTANCE, 30)];
    _timeLab.font=[UIFont systemFontOfSize:15];
    _timeLab.textColor=[UIColor ZYZC_TextGrayColor04];
    [self addSubview:_timeLab];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopVoice) name:@"stopVoice" object:nil];
}

-(void)configAMR_UI
{
    _hasGetUI=YES;
    _playVoiceBtn=[[MLPlayVoiceButton alloc]initWithFrame:CGRectMake(_iconImg.right +KEDGE_DISTANCE, self.height-38, 50, 38)];
    [_playVoiceBtn setBackgroundImage:KPULLIMG(@"voiceIcon",0,10,0,5) forState:UIControlStateNormal];
    [self addSubview:_playVoiceBtn];
    
    //语音时长
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_playVoiceBtn.right+KEDGE_DISTANCE, self.height-30, self.width-_playVoiceBtn.right-KEDGE_DISTANCE, 30)];
    _timeLab.font=[UIFont systemFontOfSize:13];
    _timeLab.textColor=[UIColor ZYZC_TextGrayColor04];
    [self addSubview:_timeLab];
}

-(void)setVoiceUrl:(NSString *)voiceUrl
{
    _voiceUrl=voiceUrl;
    //播放语音
    NSRange range=[_voiceUrl rangeOfString:KMY_ZHONGCHOU_FILE];
    if (range.length) {
        //本地
        self.playVoiceBtn.filePath=[NSURL fileURLWithPath:voiceUrl];
    }
    else
    {
        //网络(区分.caf和.amr格式)
         NSRange caf_range=[_voiceUrl rangeOfString:@".caf"];
        if (!_hasGetUI) {
            if (caf_range.length) {
                [self configCAF_UI];
            }
            else
            {
                [self configAMR_UI];
                [self.playVoiceBtn downVoiceWithUrl:[NSURL URLWithString:voiceUrl] withComplete:nil];
            }
        }
    }
}


-(void)setFaceImg:(NSString *)faceImg
{
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:faceImg] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
}

-(void)setVoiceLen:(float)voiceLen
{
    _voiceLen=voiceLen;
    CGFloat totalLength=self.width-self.iconImg.right-2*KEDGE_DISTANCE-100;
    CGFloat time_left=0.0;
    if (self.voiceView) {
         self.voiceView.width=50+((CGFloat)voiceLen/60.0)*totalLength;
        time_left=self.voiceView.right+KEDGE_DISTANCE;
    }
    if (self.playVoiceBtn) {
        self.playVoiceBtn.width=50+((CGFloat)voiceLen/60.0)*totalLength;
        time_left=self.playVoiceBtn.right+KEDGE_DISTANCE;
    }
    if (voiceLen!=50.0) {
        _timeLab.left=time_left;
        _timeLab.text=[NSString stringWithFormat:@"%.zd''",voiceLen];
        _timeLab.text=[NSString stringWithFormat:@"%.2f\"",voiceLen];
    }
    
    self.voiceView.top = self.height-self.voiceView.height;
    self.timeLab.top   = self.height-self.timeLab.height;
}


-(void)listenVoice:(UITapGestureRecognizer *)tap
{
    if (!_getStop) {
        [self playVoice];
    }
    else
    {
        [self stopVoice];
    }
    _getStop=!_getStop;
}

-(void)playVoice
{
    //播放语音
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopVoice" object:nil];
    
    NSRange range=[_voiceUrl rangeOfString:KMY_ZHONGCHOU_FILE];
    if (range.length) {
        //播放本地音频文件
        _soundObj=[[RecordSoundObj alloc]init];
        _soundObj.soundFileName=_voiceUrl;
        __weak typeof (&*self)weakSelf=self;
        _soundObj.soundPlayEnd=^()
        {
            [weakSelf.voiceImg stopAnimating];
        };
        [_voiceImg startAnimating];
        [_soundObj playSound];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        //播放网络音频文件
        _avPlayer=[ZYVoicePlayer  defaultAVPlayerWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_voiceUrl]]];
        [_voiceImg startAnimating];
        [_avPlayer play];
    }
}

-(void)stopVoice
{
    [_avPlayer pause];
    [_voiceImg stopAnimating];
}

-(void)playEnd
{
    [_voiceImg stopAnimating];
}

-(void)dealloc
{
    DDLog(@"delloc:%@",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_avPlayer pause];
    _avPlayer=nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
