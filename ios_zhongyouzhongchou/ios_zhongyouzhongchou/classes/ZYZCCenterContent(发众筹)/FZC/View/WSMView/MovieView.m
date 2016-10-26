//
//  MovieView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define TEXT_01 @"点击上传美美的自拍更能吸引人哦"
#define TEXT_02 @"提示：视频文件请小于5分钟"

#define TEXT_01_01 @"点击上传手机视频"

#import "MovieView.h"
#import "XMNPhotoPickerFramework/XMNPhotoPickerFramework.h"
#import "MediaUtils.h"
#import "PromptController.h"
#import "MBProgressHUD+MJ.h"
#import "JudgeAuthorityTool.h"

#import "QupaiSDK.h"
#import "QPEffectMusic.h"
#import "ChooseThumbController.h"

@interface MovieView ()<QupaiSDKDelegate>
@property (nonatomic, assign) BOOL isRecordResoure;
@property (nonatomic, strong) UIImage *preMovImg;
@property (nonatomic, assign) BOOL isBigFile;

@property (nonatomic, strong) XMNPhotoPickerController* picker;
@property (nonatomic, strong) UIImage *movImage;
@property (nonatomic, strong) NSURL *originMovUrl;

@property (nonatomic, strong) UILabel *alertLab01;

@property (nonatomic, strong) NSMutableArray<XMNAssetModel*>* models;

@end

@implementation MovieView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)configUI{
    
    CGFloat edgY=(self.height-130)/2;
    UIButton *addMovieBtn=[UIButton buttonWithType:UIButtonTypeCustom ];
    addMovieBtn.frame=CGRectMake((self.width-60)/2, edgY, 60, 60);
    [addMovieBtn setImage:[UIImage imageNamed:@"ico_scspi"] forState:UIControlStateNormal];
    addMovieBtn.userInteractionEnabled=NO;
    [self addSubview:addMovieBtn];
    
    _alertLab01=[[UILabel alloc]initWithFrame:CGRectMake(0, addMovieBtn.bottom+10, self.width, 20)];
    _alertLab01.text=TEXT_01;
    _alertLab01.textAlignment=NSTextAlignmentCenter;
    _alertLab01.font=[UIFont systemFontOfSize:17];
    _alertLab01.adjustsFontSizeToFitWidth=YES;
    _alertLab01.textColor=[UIColor ZYZC_TextGrayColor01];
    [self addSubview:_alertLab01];
    
    UILabel *alertLab02=[[UILabel alloc]initWithFrame:CGRectMake(0, _alertLab01.bottom+10, self.width, 20)];
    alertLab02.text=TEXT_02;
    alertLab02.textColor=[UIColor ZYZC_MainColor];
    alertLab02.textAlignment=NSTextAlignmentCenter;
    alertLab02.font=[UIFont systemFontOfSize:15];
    [self addSubview:alertLab02];
    
    _movieImg=[[UIImageView alloc]initWithFrame:self.bounds];
    _movieImg.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:_movieImg];
        
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addMyMovie:)];
    [self addGestureRecognizer:tap];
    
    _turnImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_movieImg.width-50, _movieImg.height-50, 40, 40)];
    _turnImageView.image=[UIImage imageNamed:@"icon_change_video"];
    _turnImageView.hidden=YES;
    _turnImageView.userInteractionEnabled=NO;
    [_movieImg addSubview:_turnImageView];
}

-(void)addMyMovie:(UIGestureRecognizer *)tap
{
    _isRecordResoure=NO;
    _isBigFile=NO;
#pragma mark --- 选择本地视屏
    //相册是否允许访问
    BOOL canChooseAlbum =[JudgeAuthorityTool judgeAlbumAuthority];
    if (!canChooseAlbum) {
        return;
    }
    
    [self enterShortVideo];
    return;
    
    /*
    
    _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    _picker.autoPushToPhotoCollection=NO;
    _picker.autoPushToVideoCollection=YES;
    __weak typeof(self) weakSelf = self;
    
//    选择视频后回调
    [_picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        weakSelf.movImage=[ZYZCTool imageByScalingAndCroppingWithSourceImage:image];
        [weakSelf compressVideo:asset.asset];
    }];
//    点击取消
    [_picker setDidCancelPickingBlock:^{
        [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.viewController presentViewController:_picker animated:YES completion:nil];
     
     */
}

//#pragma mark --- 压缩image
//-(UIImage *)compressImage:(UIImage *)image
//{
//    NSData *imgData=UIImageJPEGRepresentation(image, 0.1);
//    UIImage *newImage=[UIImage imageWithData:imgData];
//    return newImage;
//}
//

-(void)compressVideo:(PHAsset *)asset
{
    
     __weak typeof (&*self)weakSelf=self;
     weakSelf.movieFileName= [NSString stringWithFormat:@"%@.mp4",KMY_ZC_FILE_PATH(weakSelf.contentBelong)];
     [PromptManager showJPGHUDWithMessage:@"视频压缩中…" inView:weakSelf.picker.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [MediaUtils compressVideo:asset completeHandler:^(AVAssetExportSession *exportSession, NSURL *compressedOutputURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PromptManager dismissJPGHUD];
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    /******* 压缩成功*******/
                    long long fileSize=[MediaUtils getFileSize:compressedOutputURL.path];
//                    CGFloat M_Size=fileSize/(1024.0 * 1024.0);
//                    NSLog(@"+++++压缩后文件大小:%fM",M_Size);
                    /******* 判断压缩后文件大小*******/
                    if (fileSize > 1024 * 1024 * 20) {
                        /******* 压缩后文件较大，删除文件*******/
                        [MediaUtils deleteFileByPath:[compressedOutputURL path]];
                        [weakSelf.viewController dismissViewControllerAnimated:YES completion:^{
                            [MBProgressHUD showError:@"视频过大,获取失败"];
                            weakSelf.movImage=nil;
                        }];
                        return ;
                    }
                    /******* 压缩后文件满足要求*******/
                    //复制文件到指定位置
                    [MediaUtils deleteFileByPath:weakSelf.movieFileName];
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    BOOL copySuccess=
                    [fileManager copyItemAtPath:[compressedOutputURL path]  toPath:weakSelf.movieFileName error:nil];
                    if (copySuccess) {
                        //删除源视频
                        [MediaUtils deleteFileByPath:[compressedOutputURL path]];
                        //将图片数据转换成png格式文件并存储
                        weakSelf.movieImgFileName=[NSString stringWithFormat:@"%@.png",KMY_ZC_FILE_PATH(weakSelf.contentBelong)];
                        [MediaUtils deleteFileByPath:weakSelf.movieImgFileName];
                        if (weakSelf.movImage){
                            [UIImagePNGRepresentation(weakSelf.movImage) writeToFile:weakSelf.movieImgFileName atomically:YES];
                        }
                        [weakSelf.viewController dismissViewControllerAnimated:YES completion:^{
                            weakSelf.movieImg.image=weakSelf.movImage;
                            weakSelf.turnImageView.hidden=NO;
                            [PromptManager showSuccessJPGHUDWithMessage:@"压缩成功" intView: weakSelf.viewController.view time:1];
                            [weakSelf saveDataInDataManager];
                        }];
                    }
                }
                else{
                    /******* 压缩失败*******/
                    [MBProgressHUD showError:@"数据异常,压缩失败"];
                    weakSelf.movImage=nil;
                    [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    });
}

#pragma mark  --- 保存数据到单例中
-(void)saveDataInDataManager
{
    //将video文件和第一帧图片路径保存到单例中
    MoreFZCDataManager *dataManager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if ([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG]) {
        dataManager.raiseMoney_movieUrl=self.movieFileName;
        dataManager.raiseMoney_movieImg=self.movieImgFileName;
    }
    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
    {
        dataManager.return_movieUrl=self.movieFileName;
        dataManager.return_movieImg=self.movieImgFileName;
    }
    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
    {
        dataManager.return_movieUrl01=self.movieFileName;
        dataManager.return_movieImg01=self.movieImgFileName;
    }
    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
    {
        dataManager.return_togtherVideo=self.movieFileName;
        dataManager.return_togtherVideoImg=self.movieImgFileName;
    }

    for (int i=0; i<dataManager.travelDetailDays.count; i++) {
        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
            MoreFZCTravelOneDayDetailMdel *model=dataManager.travelDetailDays[i];
            model.movieUrl=self.movieFileName;
            model.movieImg=self.movieImgFileName;
            break;
        }
    }
}

/**
 *  获取视屏时长
 */
-(int )getMovieTimeByMovieStr:(NSString *)movieStr
{
    NSURL    *movieURL = [NSURL URLWithString:movieStr];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          [NSNumber numberWithBool:NO]
                                                     forKey:
                          AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
    int second = 0;
    second = (int)urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    return second;
}

-(void)setVideoAlertText:(NSString *)videoAlertText
{
    _videoAlertText=videoAlertText;
    _alertLab01.text=TEXT_01_01;
    
}




#pragma mark --- 短视频
-(void)enterShortVideo
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *auth_result=[user objectForKey:Auth_QuPai_Result];
    if ([auth_result isEqualToString:@"no"]) {
        if ([ZYZCAccountTool getUserId]) {
            //鉴权
            [[QPAuth shared] registerAppWithKey:kQPAppKey secret:kQPAppSecret space:[ZYZCAccountTool getUserId] success:^(NSString *accessToken) {
                //鉴权成功
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setObject:@"yes" forKey:Auth_QuPai_Result];
                [user synchronize];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self createQuPai];
                               });
            } failure:^(NSError *error) {
                //鉴权失败
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [MBProgressHUD showShortMessage:@"网络错误，鉴权失败"];
                               });
            }];
        }
    }
    else if ([auth_result isEqualToString:@"yes"])
    {
        [self createQuPai];
    }
}

-(void)createQuPai
{
    //创建趣拍对象
    [QupaiSDK shared].minDuration = 2.0;
    [QupaiSDK shared].maxDuration = 5*60.0;
    [QupaiSDK shared].enableBeauty=YES;
    [QupaiSDK shared].zy_VideoSceneType=ZY_GetProduct;
    //    [QupaiSDK shared].enableWatermark=YES;
    //    [QupaiSDK shared].watermarkImage=[UIImage imageNamed:@"watermark"];
    [QupaiSDK shared].cameraPosition=QupaiSDKCameraPositionFront;
    UIViewController *viewController = [[QupaiSDK shared] createRecordViewController];
    [QupaiSDK shared].delegte = self;
    [QupaiSDK shared].videoSize = CGSizeMake(360, 640);
    UINavigationController *navCrl = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.viewController presentViewController:navCrl animated:YES completion:nil];
}

#pragma mark --- 实现短视频代理方法
- (void)qupaiSDK:(id<QupaiSDKDelegate>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
    NSLog(@"Qupai SDK compelete %@----thumbnailPath:%@",videoPath,thumbnailPath);
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL  exit= [manager fileExistsAtPath:videoPath];
    if (!exit) {
        if (videoPath) {
            [MBProgressHUD showShortMessage:@"网络错误,视频导出失败"];
        }
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    else
    {
        if (videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        }
            //复制视频文件
            self.movieFileName= [NSString stringWithFormat:@"%@.mp4",KMY_ZC_FILE_PATH(self.contentBelong)];
            [MediaUtils deleteFileByPath:self.movieFileName];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            BOOL copyVideo=
            [fileManager copyItemAtPath:videoPath  toPath:self.movieFileName error:nil];
            if (copyVideo) {
                [MediaUtils deleteFileByPath:videoPath];
                //复制图片
                self.movieImgFileName=[NSString stringWithFormat:@"%@.png",KMY_ZC_FILE_PATH(self.contentBelong)];
                [MediaUtils deleteFileByPath:self.movieImgFileName];
                 BOOL copyImg = [fileManager copyItemAtPath:thumbnailPath  toPath:self.movieImgFileName error:nil];
                if (copyImg) {
                    [MediaUtils deleteFileByPath:thumbnailPath];
                    self.movieImg.image=[UIImage imageWithContentsOfFile:self.movieImgFileName];
                    self.turnImageView.hidden=NO;
                    WEAKSELF
                    [self.viewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf saveDataInDataManager];
                        //进入图片编辑页
                        ChooseThumbController *chooseThumbController = [[ChooseThumbController alloc]initWithVideoPath:weakSelf.movieFileName andImgSizeRate:[QupaiSDK shared].zy_VideoSizeRate WHScale:(16.0 / 10.0)];
                        [self.viewController presentViewController:chooseThumbController animated:YES completion:nil];
                        //选择切图后操作
                        chooseThumbController.imageBlock=^(UIImage *chooseImg)
                        {
                            self.movieImg.image=chooseImg;
                            UIImage *compressImg=[ZYZCTool imageByScalingAndCroppingWithSourceImage:chooseImg];
                            // 将图片保存为png格式到documents中
                            [MediaUtils deleteFileByPath:weakSelf.movieImgFileName];
                            [UIImagePNGRepresentation(compressImg)
                             writeToFile:weakSelf.movieImgFileName atomically:YES];
                            [weakSelf saveDataInDataManager];
                        } ;
                    }];
                }
                else{
                    [self.viewController dismissViewControllerAnimated:YES completion:^{
                        [MBProgressHUD showShortMessage:@"视频保存失败"];
                    }];
                }
            }
            else
            {
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                    [MBProgressHUD showShortMessage:@"视频保存失败"];
                }];
            }
    }
}

- (NSArray *)qupaiSDKMusics:(id<QupaiSDKDelegate>)sdk
{
    NSMutableArray *array = [NSMutableArray array];
    QPEffectMusic *effect = [[QPEffectMusic alloc] init];
    effect.name = @"audio";
    effect.eid = 1;
    effect.musicName = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"mp3"];
    effect.icon = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    [array addObject:effect];
    
    return array;
}

@end
