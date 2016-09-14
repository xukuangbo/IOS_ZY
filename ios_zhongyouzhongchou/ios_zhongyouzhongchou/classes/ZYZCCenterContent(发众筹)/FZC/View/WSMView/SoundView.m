//
//  SounceView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "SoundView.h"
#import "ZYZCTool+getLocalTime.h"
#import "JudgeAuthorityTool.h"

//============================
#import "MLAudioRecorder.h"
#import "CafRecordWriter.h"
#import "AmrRecordWriter.h"
#import "Mp3RecordWriter.h"
#import <AVFoundation/AVFoundation.h>
#import "MLAudioMeterObserver.h"

#import "MLAudioPlayer.h"
#import "AmrPlayerReader.h"
#import "MLPlayVoiceButton.h"

@interface SoundView ()
@property (nonatomic, strong)NSTimer        *timer;
@property (nonatomic, assign)BOOL           isRecord;
@property (nonatomic, assign)BOOL           hasPlaySound;
@property (nonatomic, assign)NSInteger      secRecord;
@property (nonatomic, assign)NSInteger      millisecRecord;

//==============================
@property (nonatomic, strong) MLAudioRecorder *recorder;
@property (nonatomic, strong) CafRecordWriter *cafWriter;
@property (nonatomic, strong) AmrRecordWriter *amrWriter;
@property (nonatomic, strong) Mp3RecordWriter *mp3Writer;

@property (nonatomic, strong) MLAudioPlayer *player;
@property (nonatomic, strong) AmrPlayerReader *amrReader;
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, copy  ) NSString *filePath;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong) MLPlayVoiceButton    *mlPlayButton;

@end

@implementation SoundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI
{
     CGFloat edgY=(self.height-155)/2;
    //计时显示lab
    _secLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width/2-50, edgY, 30, 20)];
    _secLab.font=[UIFont systemFontOfSize:16];
    _secLab.textColor=[UIColor ZYZC_MainColor];
    _secLab.textAlignment=NSTextAlignmentRight;
    [self addSubview:_secLab];
    
    _milliSecLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width/2-20, _secLab.top, 20, 20)];
    _milliSecLab.font=[UIFont systemFontOfSize:16];
    _milliSecLab.textColor=[UIColor ZYZC_MainColor];
    [self addSubview:_milliSecLab];
    
    [self changeTimeRecordLab];
    
    UILabel *timeRightLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width/2, _secLab.top, self.width/2, 20)];
    timeRightLab.font=[UIFont systemFontOfSize:16];
    timeRightLab.textColor=[UIColor ZYZC_TextGrayColor03];
    timeRightLab.attributedText=[self changeTextFontAndColorByString:@"/60.00"];
    [self addSubview:timeRightLab];
    
    //语音录制按钮
    _soundBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _soundBtn.frame=CGRectMake((self.width-90)/2, _secLab.bottom+10, 90, 90);
    [_soundBtn setBackgroundImage:[UIImage imageNamed:@"btn_yylr_p"] forState:UIControlStateNormal];
    [_soundBtn addTarget:self action:@selector(recordSound) forControlEvents:UIControlEventTouchDown];
    [_soundBtn addTarget:self action:@selector(stopRecordSound) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [self addSubview:_soundBtn];
    
    //语音播放按钮
    _playerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _playerBtn.frame=CGRectMake(0, 0, 68, 68);
    _playerBtn.center=_soundBtn.center;
    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
    [_playerBtn addTarget:self action:@selector(playerSound:) forControlEvents:UIControlEventTouchUpInside];
    _playerBtn.hidden=YES;
    [self addSubview:_playerBtn];
    
    //语音删除按钮
    _deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame=CGRectMake((self.width-80)/2, _soundBtn.bottom, 80, 40) ;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_deleteBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteSound) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    [_deleteBtn addSubview:[UIView lineViewWithFrame:CGRectMake((_deleteBtn.width-40)/2, _deleteBtn.height-10, 40, 1) andColor:[UIColor ZYZC_TextBlackColor]]];
    
    //圆环进度条
    [self createDrawCircle];
    
    //初始化语音
//     _soundObj=[[RecordSoundObj alloc]init];
//    __weak typeof (&*self)weakSelf=self;
//    _soundObj.soundPlayEnd=^()
//    {
//        //语音播放完成播放按钮切换成停止状态
//        [weakSelf.playerBtn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
//        weakSelf.hasPlaySound=NO;
//    };

}

#pragma mark --- 创建圆环进度条
-(void)createDrawCircle
{
    UIView *view=[[UIView alloc]init];
    view.center=_soundBtn.center;
    view.userInteractionEnabled=NO;
    view.bounds=CGRectMake(0, 0, 80, 80);
    [self addSubview:view];
    _circleView=[[DrawCircleView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _circleView.progressColor = [UIColor ZYZC_MainColor];
    _circleView.progressStrokeWidth = 3.f;
    _circleView.progressTrackColor = [UIColor whiteColor];
    [view addSubview:_circleView];
    [self insertSubview:_soundBtn aboveSubview:view];
}

//#pragma mark --- 语音录制
//-(void)recordSound
//{
//    BOOL canRecord=[JudgeAuthorityTool judgeRecordAuthority];
//    if (!canRecord) {
//        return;
//    }
//    //创建语音文件名
//    NSString *fileName=[NSString stringWithFormat:@"%@.caf",self.contentBelong];
//    self.soundFileName=KMY_ZC_FILE_PATH(fileName);
//    //删除已存在语音
//    [ZYZCTool removeExistfile:KMY_ZC_FILE_PATH(fileName)];
//    //进度条加载
//    if (!_timer) {
//        _timer=[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeProgressValue) userInfo:nil repeats:YES];
//    }
//    //开启语音录制
//    [_soundObj recordMySound];
//    
//    //保存语音文件名到单例中
//    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
//    if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
//        manager.raiseMoney_voiceUrl=self.soundFileName;
//    }
//    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
//    {
//        manager.return_voiceUrl=self.soundFileName;
//    }
//    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
//    {
//        manager.return_voiceUrl01=self.soundFileName;
//    }
//    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
//    {
//        manager.return_togtherVoice=self.soundFileName;
//    }
//    for (int i=0; i<manager.travelDetailDays.count; i++) {
//        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
//            MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
//            model.voiceUrl=self.soundFileName;
//            break;
//        }
//    }
//}
//
//#pragma mark --- 停止语音录制
//-(void)stopRecordSound
//{
//    [_timer invalidate];
//    _timer=nil;
//    if (!(_secRecord==0&&_millisecRecord==0)) {
//        _playerBtn.hidden=NO;
//        _soundBtn.hidden=YES;
//        [self insertSubview:_playerBtn aboveSubview:_soundBtn];
//        [_soundObj stopRecordSound];
//        
//        //保存语音时长保存到单例中
//        MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
//        float vioceLen=[[NSString stringWithFormat:@"%.2zd.%.2zd",_secRecord,_millisecRecord] floatValue];
//        
//        if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
//            manager.raiseMoney_voiceLen = vioceLen;
//        }
//        else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
//        {
//            manager.return_voiceLen = vioceLen;
//        }
//        else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
//        {
//            manager.return_voiceLen01=vioceLen;
//        }
//        else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
//        {
//            manager.return_togtherVoiceLen=vioceLen;
//        }
//        for (int i=0; i<manager.travelDetailDays.count; i++) {
//            if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
//                MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
//                model.voiceLen=vioceLen;
//                break;
//            }
//        }
//
//    }
//    else
//    {
//        [self deleteSound];
//    }
//}
//
//#pragma mark --- 播放语音
//-(void)playerSound:(UIButton *)btn
//{
//    BOOL canRecord=[JudgeAuthorityTool judgeRecordAuthority];
//    if (!canRecord) {
//        return;
//    }
//    
//    if (!_hasPlaySound) {
//        [_soundObj playSound];
//        [btn setBackgroundImage:[UIImage imageNamed:@"btn_yylr_pause"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_soundObj stopSound];
//        [btn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
//    }
//    _hasPlaySound=!_hasPlaySound;
//}
//
//#pragma mark --- 删除语音
//-(void)deleteSound
//{
//    _soundBtn.hidden=NO;
//    _playerBtn.hidden=YES;
//    _circleView.progressValue=0;
//    _millisecRecord=0;
//    _secRecord=0;
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
//    [self changeTimeRecordLab];
//    
//    [_soundObj deleteMySound];
//    
//    //删除单例中语音路径，赋值为空
//    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
//    if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
//        manager.raiseMoney_voiceUrl= nil;
//        manager.raiseMoney_voiceLen = 0.0;
//        
//    }
//    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
//    {
//        manager.return_voiceUrl= nil;
//        manager.return_voiceLen= 0.0;
//    }
//    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
//    {
//        manager.return_voiceUrl01= nil;
//        manager.return_voiceLen01=0.0;
//    }
//    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
//    {
//        manager.return_togtherVoice= nil;
//        manager.return_togtherVoiceLen=0.0;
//    }
//    for (int i=0; i<manager.travelDetailDays.count; i++) {
//        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
//            MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
//            model.voiceUrl=nil;
//            break;
//        }
//    }
//    
//    
//}

#pragma mark --- 进度条改变
- (void)changeProgressValue
{
    _circleView.progressValue += 0.01;
    if (_circleView.progressValue>=60.0) {
        [_timer invalidate];
        _timer=nil;
        [self.player stopPlaying];
    }
    else{
        _millisecRecord+=1;
        if (_millisecRecord==100) {
            _millisecRecord=0;
            _secRecord+=1;
        }
        [self changeTimeRecordLab];
    }
}

#pragma mark ---计时显示改变
-(void)changeTimeRecordLab
{
    _secLab.text=[NSString stringWithFormat:@"%.2zd.",_secRecord];
    _milliSecLab.text=[NSString stringWithFormat:@"%.2zd",_millisecRecord];
    
}

#pragma mark --- 字符串的字体更改
-(NSMutableAttributedString *)changeTextFontAndColorByString:(NSString *)str
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    if (str.length>1) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_MainColor] range:NSMakeRange(0, 1)];
    }
   
    return  attrStr;
}

-(void)setSoundProgress:(CGFloat )soundProgress
{
    _soundProgress=soundProgress;
    NSInteger number=(int )((soundProgress+0.009)*100);
    _secRecord=number/100;
    _millisecRecord=number%100;
    [self changeTimeRecordLab];
    _circleView.progressValue=soundProgress;
    _playerBtn.hidden=NO;
    _soundBtn.hidden=YES;
}

-(void)setSoundFileName:(NSString *)soundFileName
{
    _soundFileName=soundFileName;
    
}


-(void)setContentBelong:(NSString *)contentBelong
{
    [super setContentBelong:contentBelong];
    //初始化音频对象
    [self initAudioRecoder];
}

#pragma mark --- 初始化音频对象
-(void)initAudioRecoder
{
    //众筹存储路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:KMY_ZHONGCHOU_FILE];
    
    CafRecordWriter *writer = [[CafRecordWriter alloc]init];
    writer.filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",self.contentBelong]];
    self.cafWriter = writer;
    
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",self.contentBelong]];
    amrWriter.maxSecondCount = 60;
//    amrWriter.maxFileSize = 1024*1024;
    self.amrWriter = amrWriter;
    
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
    mp3Writer.filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.contentBelong]];
    mp3Writer.maxSecondCount = 60;
//    mp3Writer.maxFileSize = 1024*1024;
    self.mp3Writer = mp3Writer;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        //音量
        DDLog(@"volume:%f",[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]);
    };
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    self.meterObserver = meterObserver;
    
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakSelf = self;
    //录制结束
    recorder.receiveStoppedBlock = ^{
        weakSelf.meterObserver.audioQueue = nil;
    };
    //录制出错
    recorder.receiveErrorBlock = ^(NSError *error){
        [weakSelf.timer invalidate];
        weakSelf.timer=nil;
        if (!(weakSelf.secRecord==0&&weakSelf.millisecRecord==0)) {
            weakSelf.playerBtn.hidden=NO;
            weakSelf.soundBtn.hidden=YES;
            [weakSelf insertSubview:weakSelf.playerBtn aboveSubview:weakSelf.soundBtn];
            [weakSelf.soundObj stopRecordSound];
        }
        else
        {
            [weakSelf deleteSound];
        }
        weakSelf.meterObserver.audioQueue = nil;
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    
    //caf
    //        recorder.fileWriterDelegate = writer;
    //        self.filePath = writer.filePath;
    //mp3
    //    recorder.fileWriterDelegate = mp3Writer;
    //    self.filePath = mp3Writer.filePath;
    
    //amr
    recorder.bufferDurationSeconds = 0.25;
    recorder.fileWriterDelegate = self.amrWriter;
    
    self.recorder = recorder;
    
    MLAudioPlayer *player = [[MLAudioPlayer alloc]init];
    AmrPlayerReader *amrReader = [[AmrPlayerReader alloc]init];
    
    player.fileReaderDelegate = amrReader;
    //播放出错
    player.receiveErrorBlock = ^(NSError *error){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    
    //播放停止
    player.receiveStoppedBlock = ^{
        [weakSelf.playerBtn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
    };
    self.player = player;
    self.amrReader = amrReader;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidChangeInterruptionType:)
    name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}

- (void)audioSessionDidChangeInterruptionType:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo]
                                                        objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (AVAudioSessionInterruptionTypeBegan == interruptionType)
    {
        DDLog(@"begin");
    }
    else if (AVAudioSessionInterruptionTypeEnded == interruptionType)
    {
        DDLog(@"end");
    }
}

#pragma mark --- 删除语音
-(void)deleteSound
{
    _soundBtn.hidden=NO;
    _playerBtn.hidden=YES;
    _circleView.progressValue=0;
    _millisecRecord=0;
    _secRecord=0;
    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
    [self changeTimeRecordLab];
    
    //如果语音正在播放，则终止播放
    if (self.player.isPlaying) {
        [self.player stopPlaying];
    }
    //如果网络音频正在播放也终止掉
    if ([MLAmrPlayer shareInstance].isPlaying) {
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
    //如果有语音文件删除文件
    [ZYZCTool removeExistfile:self.soundFileName];
    
    //删除单例中语音路径，赋值为空
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
        manager.raiseMoney_voiceUrl= nil;
        manager.raiseMoney_voiceLen = 0.0;

    }
    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
    {
        manager.return_voiceUrl= nil;
        manager.return_voiceLen= 0.0;
    }
    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
    {
        manager.return_voiceUrl01= nil;
        manager.return_voiceLen01=0.0;
    }
    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
    {
        manager.return_togtherVoice= nil;
        manager.return_togtherVoiceLen=0.0;
    }
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
            MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
            model.voiceUrl=nil;
            break;
        }
    }
}

#pragma mark --- 语音录制
-(void)recordSound
{
    //判断app录音功能是否可用
    BOOL canRecord=[JudgeAuthorityTool judgeRecordAuthority];
    if (!canRecord) {
        return;
    }
    
    //创建语音文件名
    NSString *fileName=[NSString stringWithFormat:@"%@.amr",self.contentBelong];
    self.soundFileName=KMY_ZC_FILE_PATH(fileName);
    
    //删除已存在语音
    [ZYZCTool removeExistfile:self.soundFileName];
    
    if (self.recorder.isRecording) {
        //取消录音
        [self.recorder stopRecording];
        return;
    }
    else{
        //开始录音
        [self.recorder startRecording];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
    }

    //进度条加载
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeProgressValue) userInfo:nil repeats:YES];
    }
    
    //保存语音文件名到单例中
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
        manager.raiseMoney_voiceUrl=self.soundFileName;
    }
    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
    {
        manager.return_voiceUrl=self.soundFileName;
    }
    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
    {
        manager.return_voiceUrl01=self.soundFileName;
    }
    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
    {
        manager.return_togtherVoice=self.soundFileName;
    }
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
            MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
            model.voiceUrl=self.soundFileName;
            break;
        }
    }
}

#pragma mark --- 停止语音录制
-(void)stopRecordSound
{
    [_timer invalidate];
    _timer=nil;
    if (!(_secRecord==0&&_millisecRecord==0)) {
        _playerBtn.hidden=NO;
        _soundBtn.hidden=YES;
        [self insertSubview:_playerBtn aboveSubview:_soundBtn];
        [self.recorder stopRecording];
        
//        保存语音时长保存到单例中
        MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
        float vioceLen=[[NSString stringWithFormat:@"%.2zd.%.2zd",_secRecord,_millisecRecord] floatValue];

        if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
            manager.raiseMoney_voiceLen = vioceLen;
        }
        else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
        {
            manager.return_voiceLen = vioceLen;
        }
        else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
        {
            manager.return_voiceLen01=vioceLen;
        }
        else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
        {
            manager.return_togtherVoiceLen=vioceLen;
        }
        for (int i=0; i<manager.travelDetailDays.count; i++) {
            if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
                MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
                model.voiceLen=vioceLen;
                break;
            }
        }
    }
    else
    {
        [self deleteSound];
    }
}


#pragma mark --- 播放语音
-(void)playerSound:(UIButton *)btn
{
    BOOL canRecord=[JudgeAuthorityTool judgeRecordAuthority];
    if (!canRecord) {
        return;
    }
    
    NSRange range=[self.soundFileName rangeOfString:KMY_ZHONGCHOU_FILE];
    //播放网络音频文件
    if (!range.length) {
        if (!self.mlPlayButton) {
            self.mlPlayButton=[MLPlayVoiceButton new];
        }
        
        WEAKSELF;
        [self.mlPlayButton downVoiceWithUrl:[NSURL URLWithString:self.soundFileName ] withComplete:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.mlPlayButton click];
            }
        }];
    
        self.mlPlayButton.voiceWillPlayBlock=^(MLPlayVoiceButton *playBtn){
            [weakSelf.playerBtn setBackgroundImage:[UIImage imageNamed:@"btn_yylr_pause"] forState:UIControlStateNormal];
        };
        
        self.mlPlayButton.voiceStopPlayBlock=^(MLPlayVoiceButton *playBtn){
            [weakSelf.playerBtn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
        };
    }
    else
    {
        //播放本地语音
        self.amrReader.filePath = self.amrWriter.filePath;
        
        if (self.player.isPlaying) {
            [self.player stopPlaying];
            [btn setBackgroundImage:[UIImage imageNamed:@"ico_sto"] forState:UIControlStateNormal];
        }
        else
        {
            [self.player startPlaying];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_yylr_pause"] forState:UIControlStateNormal];
        }
    }
}

- (void)dealloc
{
    DDLog(@"delloc:%@",[self class]);
    [self.player stopPlaying];
    self.player=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
