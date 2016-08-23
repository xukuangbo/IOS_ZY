//
//  RecordSoundObj.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#import "ZYZCOSSManager.h"
#import "RecordSoundObj.h"
@implementation RecordSoundObj

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(44100) forKey:AVSampleRateKey];
    //设置通道,这里采用双声道
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    _audioRecorder=nil;
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[NSURL fileURLWithPath:self.soundFileName];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
//            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

#pragma mark --- 语音录制
-(void)recordMySound
{
    [self setAudioSession];
    
    [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    
}

#pragma mark --- 停止录制
-(void)stopRecordSound
{
    [self.audioRecorder stop];
//    [self turnSoundToMP3AndPlay];
}

#pragma mark --- 语音播放
-(void)playSound
{
    NSRange range=[self.soundFileName rangeOfString:KMY_ZHONGCHOU_FILE];
     //播放网络音频文件
    if (!range.length) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        _avPlayer=[ZYVoicePlayer  defaultAVPlayerWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.soundFileName]]];
        [_avPlayer play];
        return;
    }
    
    //播放本地语音
    _audioPlayer=nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (!_audioPlayer) {
        NSURL *url=[NSURL fileURLWithPath:self.soundFileName];
//        NSLog(@"%@",url);
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.delegate=self;
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
//            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        }
    }
    if([_audioPlayer isPlaying])
    {
        [_audioPlayer pause];
    }
    else
    {
        [_audioPlayer play];
    }
}

#pragma mark --- 停止播放
-(void)stopSound
{
    //停止网络语音
    NSRange range=[self.soundFileName rangeOfString:KMY_ZHONGCHOU_FILE];
    if (!range.length) {
        [_avPlayer pause];
        return;
    }
    //停止本地语音
    [_audioPlayer stop];
}

#pragma mark --- 删除语音
-(void)deleteMySound
{
    [_audioPlayer stop];
    
    NSString *urlStr=self.soundFileName;
    if ([[NSFileManager defaultManager] fileExistsAtPath:urlStr]) {
        [[NSFileManager defaultManager] removeItemAtPath:urlStr error:nil];
    }
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
//        NSLog(@"录音完成!");
}

#pragma mark --- 本地语音播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_soundPlayEnd) {
        _soundPlayEnd();
    }
}

#pragma mark --- 网络语音播放结束
-(void)playEnd
{
    if (_soundPlayEnd) {
        _soundPlayEnd();
    }
}


#pragma mark --- 存储MP3格式文件路径
-(NSString *)saveMP3Path
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path =[documentDir stringByAppendingPathComponent:@"soundFile.mp3"];
//    NSLog(@"kMP3AudioFile:%@",path);
    return path;
}


/*
#pragma mark --- 将音频转换为MP3格式并播放
-(void)turnSoundToMP3AndPlay
{
    //转换mp3文件路径
    NSString *mp3AudioPath=[self saveMP3Path];
    NSLog(@"mp3AudioPath:%@",mp3AudioPath);
    //原文件路径
    NSString *cafFilePath=self.soundFileName;
    NSLog(@"cafFilePath:%@",cafFilePath);
    //进入转换
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3AudioPath error:nil])
    {
        NSLog(@"删除");
    }
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3AudioPath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);     
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSError *playerError;
        if(!_audioPlayer)
        {
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:mp3AudioPath]error:&playerError];
            _audioPlayer.volume = 1.0f;
            if (_audioPlayer == nil)
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
            _audioPlayer.delegate = self;
        }
        [self playing];
    }
}
- (void)playing
{
    if([_audioPlayer isPlaying])
    {
        [_audioPlayer pause];
        NSLog(@"播放。。");
    }
    
    else
    {
        [_audioPlayer play];
        NSLog(@"正在播放录音。。");
    }
    
}
*/

@end
