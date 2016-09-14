//
//  MLPlayVoiceButton.m
//  CustomerPo
//
//  Created by molon on 8/15/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MLPlayVoiceButton.h"
#import "MLDataResponseSerializer.h"
#import "MBProgressHUD+MJ.h"
#define AMR_MAGIC_NUMBER "#!AMR\n"

@interface MLPlayVoiceButton()

@property (nonatomic, strong) AFURLSessionManager *af_URLSessionManager;

@property (nonatomic, strong) NSURL *voiceURL;

@property (nonatomic, assign) BOOL isVoicePlaying;

@property (nonatomic, strong) UIImageView *playingSignImageView;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) MLPlayVoiceButtonState voiceState;

@end

@implementation MLPlayVoiceButton

#pragma mark - cache
+ (MLDataCache*)sharedDataCache {
    return [MLDataCache shareInstance];
}

#pragma mark - cancel
- (void)cancelVoiceRequestOperation {
    self.af_URLSessionManager = nil;
}

#pragma mark - life
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    [self addSubview:self.playingSignImageView];
    [self addSubview:self.indicator];
    self.voiceState = MLPlayVoiceButtonStateNone;
    
    [self updatePlayingSignImage];
    
    //        [self setBackgroundImage:[UIImage imageWithPureColor:[UIColor colorWithWhite:0.253 alpha:0.650]] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReceiveStop:) name:MLAMRPLAYER_PLAY_RECEIVE_STOP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReceiveError:) name:MLAMRPLAYER_PLAY_RECEIVE_ERROR_NOTIFICATION object:nil];
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    DDLog(@"delloc:%@",[self class]);
    [[MLAmrPlayer shareInstance] stopPlaying];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - notification
- (void)playReceiveStop:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (![userInfo[@"filePath"] isEqual:self.filePath]) {
        return;
    }
//    DDLog(@"发现音频播放停止:%@,如果发现此处执行多次不用在意。那可能是因为tableView复用的关系",[self.filePath path]);
    
    [self updatePlayingSignImage];
    
    if (self.voiceStopPlayBlock) {
        self.voiceStopPlayBlock(self);
    }
    
}

- (void)playReceiveError:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (![userInfo[@"filePath"] isEqual:self.filePath]) {
        return;
    }
#warning 这里最好做下发现当前音频播放错误处理
    DDLog(@"发现音频播放错误:%@",[self.filePath path]);
    if ([[self.filePath path] isEqualToString:@"NONE_DATA"]) {
        [MBProgressHUD showShortMessage:@"播放出错,音频文件获取失败"];
    }
    else
    {
        [MBProgressHUD showShortMessage:@"播放出错"];
    }
    [self updatePlayingSignImage];
}

#pragma mark - event
- (void)click
{
    if (!self.filePath) {
        WEAKSELF;
        [self downVoiceWithUrl:self.downloadVoiceUrl withComplete:^(BOOL isSuccess) {
            if(isSuccess)
            {
                if (weakSelf.voiceWillPlayBlock) {
                    weakSelf.voiceWillPlayBlock(weakSelf);
                }
                [[MLAmrPlayer shareInstance]playWithFilePath:weakSelf.filePath];
                [weakSelf updatePlayingSignImage];
            }
        }];
        return;
    }
    
    if (!self.isVoicePlaying) {
        if (self.voiceWillPlayBlock) {
            self.voiceWillPlayBlock(self);
        }
        [[MLAmrPlayer shareInstance]playWithFilePath:self.filePath];
        [self updatePlayingSignImage];
    }else{
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

#pragma mark - getter
- (BOOL)isVoicePlaying
{
	if ([MLAmrPlayer shareInstance].isPlaying&&[[MLAmrPlayer shareInstance].filePath isEqual:self.filePath]) {
        return YES;
    }
    return NO;
}

- (UIImageView *)playingSignImageView
{
    if (!_playingSignImageView) {
		UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _playingSignImageView = imageView;
    }
    return _playingSignImageView;
}

- (UIActivityIndicatorView *)indicator
{
	if (!_indicator) {
		_indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
	}
	return _indicator;
}
#pragma mark - setter
- (void)setType:(MLPlayVoiceButtonType)type
{
    _type = type;
    
    [self updatePlayingSignImage];
    
    [self setNeedsLayout];
}

- (void)setFilePath:(NSURL *)filePath
{
    _filePath = filePath;
    
    if (filePath) {
        if (self.duration<=0) {
            _duration = [MLAmrPlayer durationOfAmrFilePath:filePath];
        }
        self.voiceState = MLPlayVoiceButtonStateNormal;
    }else{
        _duration = 0.0f;
        self.voiceState = MLPlayVoiceButtonStateNone;
    }
}

- (void)setVoiceState:(MLPlayVoiceButtonState)voiceState
{
    _voiceState = voiceState;
    
    //如果none啥都没，
    if (voiceState == MLPlayVoiceButtonStateNone) {
        [self.indicator stopAnimating];
        self.playingSignImageView.hidden = YES;
    }else if (voiceState == MLPlayVoiceButtonStateDownloading){
        [self.indicator startAnimating];
        self.playingSignImageView.hidden = YES;
    }else if (voiceState == MLPlayVoiceButtonStateNormal){
        self.playingSignImageView.hidden = NO;
        [self.indicator stopAnimating];
        [self updatePlayingSignImage];
    }
    
    if (self.preferredWidthChangedBlock) {
        self.preferredWidthChangedBlock(self,NO);
    }
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    
    if (self.preferredWidthChangedBlock) {
        self.preferredWidthChangedBlock(self,NO);
    }
}

#pragma mark - 图像
- (void)updatePlayingSignImage
{
    if (self.voiceState==MLPlayVoiceButtonStateDownloading) {
        self.playingSignImageView.image = nil;
        return;
    }
    
    NSString *prefix = self.type==MLPlayVoiceButtonTypeLeft?@"ReceiverVoiceNodePlaying00":@"SenderVoiceNodePlaying00";
    if ([self isVoicePlaying]) {
        self.playingSignImageView.image = [UIImage animatedImageNamed:prefix duration:1.0f];
    }else{
        self.playingSignImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@3",prefix]];
    }
}


#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
#define kVoicePlaySignSideLength 20.0f
    if (self.type == MLPlayVoiceButtonTypeRight) {
        self.playingSignImageView.frame = CGRectMake(self.frame.size.width-kVoicePlaySignSideLength-5.0f, (self.frame.size.height-kVoicePlaySignSideLength)/2, kVoicePlaySignSideLength, kVoicePlaySignSideLength);
    }else{
        self.playingSignImageView.frame = CGRectMake(5.0f, (self.frame.size.height-kVoicePlaySignSideLength)/2, kVoicePlaySignSideLength, kVoicePlaySignSideLength);
    }
    
    self.indicator.frame = self.playingSignImageView.frame;
}

#pragma mark - outcall
- (void)setVoiceWithURL:(NSURL*)url
{
    [self setVoiceWithURL:url withAutoPlay:NO];
}

- (void)setVoiceWithURL:(NSURL*)url withAutoPlay:(BOOL)autoPlay
{
    __weak __typeof(self)weakSelf = self;
    [self setVoiceWithURL:url success:^(NSURLRequest *request, NSURLResponse *response, NSURL *voicePath) {
        if (!voicePath) {
            weakSelf.filePath = voicePath;
            return;
        }
        
        DDLog(@"下载下来的音频路径：%@",voicePath);
        weakSelf.filePath = voicePath;
        if (autoPlay) {
            if (weakSelf.voiceWillPlayBlock) {
                weakSelf.voiceWillPlayBlock(weakSelf);
            }
            [[MLAmrPlayer shareInstance]playWithFilePath:weakSelf.filePath];
        }
    } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error) {
        DDLog(@"%@",error);
        weakSelf.filePath = nil;
    }];
}

- (void)setVoiceWithURL:(NSURL *)url success:(void (^)(NSURLRequest *request, NSURLResponse *response, NSURL* voicePath))success
                       failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    [self setVoiceWithURLRequest:request success:success failure:failure];
}

- (void)setVoiceWithURLRequest:(NSURLRequest *)urlRequest success:(void (^)(NSURLRequest *request, NSURLResponse *response, NSURL* voicePath))success
                       failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure
{
    self.voiceURL = [urlRequest URL];

    //无论如何，该去掉的就得去掉
//#warning 这里有个弊端，例如上一个设置了autoPlay，然后tableViewCell重用后，会取消，然后肯定上面那个就不能自动播放了，似乎也不适合处理这个情况。回头再考虑吧。不过有个应该考虑下，下一半还没下完，然后被重用了,这样之前的下载就被丢弃了！，AFNetworking的图片处理也有类似情况
    self.filePath = nil;
    [self cancelVoiceRequestOperation];
    
    if ([self.voiceURL isFileURL]) {
        if (success) {
            success(urlRequest, nil, self.voiceURL);
        } else if (self.voiceURL) {
            self.filePath = self.voiceURL;
        }
        return;
    }
    
    if (nil==self.voiceURL) {
        if (success) {
            success(urlRequest,nil,self.voiceURL);
        }
        return;
    }
    
    NSURL *filePath = [[[self class] sharedDataCache] cachedFilePathForRequest:urlRequest];
    if (filePath) {
        if (success) {
            success(nil, nil, filePath);
        } else {
            self.filePath = filePath;
        }
        self.af_URLSessionManager = nil;
    } else {
        self.voiceState = MLPlayVoiceButtonStateDownloading;
    }
}

- (void) downVoiceWithUrl:(NSURL *)url  withComplete:(DownloadBlock)downloadBlock
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    self.voiceURL = [urlRequest URL];
    
    self.filePath = nil;
    
    if ([self.voiceURL isFileURL]) {
        if (self.voiceURL) {
            self.filePath = self.voiceURL;
        }
        return;
    }
    if (nil==self.voiceURL) {
        return;
    }
    
    NSURL *filePath = [[[self class] sharedDataCache] cachedFilePathForRequest:urlRequest];
    if (filePath) {
         self.filePath = filePath;
        if (downloadBlock) {
            downloadBlock(YES);
        }
    }
    else {
        self.voiceState = MLPlayVoiceButtonStateDownloading;
        DDLog(@"下载音频:%@",[urlRequest URL]);
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLSessionDownloadTask *downloadTask=[manager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            //下载进度
//            NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
        destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
            NSString *cachesPath = NSTemporaryDirectory();
            NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        }
        completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            if (error) {
                DDLog(@"获取音频文件失败:%@",error);
                self.filePath=[NSURL URLWithString:@"NONE_DATA"];
                if (downloadBlock) {
                    downloadBlock(NO);
                }
                return ;
            }
            /**
             *  文件下载成功
             */
            //文件下载路径
            self.filePath=filePath;
            //将NSURL转成NSString
            NSString *imgFilePath = [filePath path];
            NSData *fileData=[NSData dataWithContentsOfFile:imgFilePath];
            
            //进行缓存
            [[[self class] sharedDataCache] cacheData:fileData forRequest:urlRequest afterCacheInFileSuccess:^(NSURL *filePath) {
                 if (filePath) {
                     //文件缓存路径
                    self.filePath = filePath;
                     [ZYZCTool removeExistfile:imgFilePath];
                     if (downloadBlock) {
                         downloadBlock(YES);
                     }
                }
            } failure:^{
                DDLog(@"缓存失败");
                //缓存失败，但是下载成功
                if (downloadBlock) {
                    downloadBlock(YES);
                }
            }];
        }];
        
        [downloadTask resume];
    }
}

-(void)setHiddenAnimation:(BOOL)hiddenAnimation
{
    _hiddenAnimation=hiddenAnimation;
    
    self.playingSignImageView.hidden=hiddenAnimation;
    
}



#pragma mark - preferredWidth
- (CGFloat)preferredWidth
{
#define kMinDefaultWidth 50.0f
#define kMaxWidth 120.0f
    if (self.voiceState != MLPlayVoiceButtonStateNormal) {
        return kMinDefaultWidth;
    }
    
    CGFloat width = kMinDefaultWidth + floor(self.duration+0.5f)*5.0f;
    if (width>kMaxWidth) {
        width = kMaxWidth;
    }
    return width;
}


@end
