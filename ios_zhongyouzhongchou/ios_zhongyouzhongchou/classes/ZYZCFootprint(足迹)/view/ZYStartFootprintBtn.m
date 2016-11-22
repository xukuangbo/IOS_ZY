//
//  ZYStartFootprintBtn.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYStartFootprintBtn.h"
#import "ZYPublishFootprintController.h"
#import "ZYShortVideoPublish.h"

#import "JudgeAuthorityTool.h"
#import "QupaiSDK.h"
#import "QPEffectMusic.h"
#import "XMNPhotoPickerFramework/XMNPhotoPickerFramework.h"
#import "MediaUtils.h"
#import "PromptController.h"
#import "MBProgressHUD+MJ.h"
#import "FCIMChatGetImage.h"
#import "VideoService.h"
#define kcMaxThumbnailSize 720*1024

@interface ZYStartFootprintBtn ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QupaiSDKDelegate>
@property (nonatomic, strong) XMNPhotoPickerController *picker;
@property (nonatomic, strong) UIImage *videoImage;
@property (nonatomic, copy  ) NSString *videoPath;
@property (nonatomic, copy  ) NSString *thumbnailPath;
@end

@implementation ZYStartFootprintBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(startEditfootprint) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark --- 开始编辑足迹
-(void)startEditfootprint
{
    //创建UIAlertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    // 拍摄视频
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
//        [ZYZCAccountTool getQuPaiAuthWithResultBlock:^(BOOL result) {
//            if (result==YES) {
//                [self createQuPai];
//            }
//            else
//            {
//                [MBProgressHUD showShortMessage:@"网络错误，鉴权失败"];
//            }
//        }];
        //无需鉴权即可登陆
        [self createQuPai];
    }];
    //选择本地相册
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断是否可以选择照片
        BOOL canChooseAlbum=[JudgeAuthorityTool judgeAlbumAuthority];
        if (!canChooseAlbum) {
            return ;
        }
        
        _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
        _picker.pickingVideoEnable=YES;
        _picker.autoPushToPhotoCollection=NO;
        
        WEAKSELF;
        // 选择图片后回调
        [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable asset) {
            [weakSelf.picker dismissViewControllerAnimated:NO completion:^{
                NSMutableArray *newImgs=[NSMutableArray array];
                for (NSInteger i=0; i<images.count; i++) {
                    [newImgs addObject:[ZYZCTool imageByScalingAndCroppingWithSourceImage:images[i]]];
                }
                ZYPublishFootprintController  *publishFootprintController=[[ZYPublishFootprintController alloc]init];
                publishFootprintController.images=newImgs;
                publishFootprintController.footprintType=Footprint_AlbumType;
                [weakSelf.viewController presentViewController:publishFootprintController animated:YES completion:nil];
            }];
        }];
        
        //选择视频后的回调
        [_picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
            [weakSelf compressVideo:asset.asset];
        }];
        
        //点击取消
        [_picker setDidCancelPickingBlock:^{
            [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.viewController presentViewController:_picker animated:YES completion:nil];
    }];
    //选择拍照
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController  *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        //判断是否可以拍照
        BOOL canUseMedia=[JudgeAuthorityTool judgeMediaAuthority];
        if (!canUseMedia) {
            return ;
        }
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    [cancelAction setValue:[UIColor ZYZC_MainColor]
                    forKey:@"_titleTextColor"];
    [videoAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    [albumAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    [photoAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    
    [alertController addAction:cancelAction];
    [alertController addAction:videoAction];
    [alertController addAction:albumAction];
    [alertController addAction:photoAction];
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}



-(void)createQuPai
{
    //创建趣拍对象
    [QupaiSDK shared].minDuration = 2.0;
    [QupaiSDK shared].maxDuration = 30.0;
    [QupaiSDK shared].enableBeauty=YES;
    [QupaiSDK shared].zy_VideoSceneType=ZY_GetFootprint;
    //    [QupaiSDK shared].enableWatermark=YES;
    //    [QupaiSDK shared].watermarkImage=[UIImage imageNamed:@"LOGO"];
    [QupaiSDK shared].cameraPosition=QupaiSDKCameraPositionFront;
    UIViewController *viewController = [[QupaiSDK shared] createRecordViewController];
    [QupaiSDK shared].delegte = self;
    [QupaiSDK shared].videoSize = CGSizeMake(360, 640);
    UINavigationController *navCrl = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.viewController presentViewController:navCrl animated:YES completion:nil];
}

#pragma mark --- 实现短视频代理方法
- (void)qupaiSDK:(id<QupaiSDKDelegate>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
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
            _videoPath=videoPath;
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        }
    
        WEAKSELF;
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            if ([QupaiSDK shared].zy_VideoHandleType==ZY_QupaiVideoPublish) {
                ZYShortVideoPublish *videoPublish=[ZYShortVideoPublish new];
                videoPublish.videoPath=videoPath;
                videoPublish.img_rate=[QupaiSDK shared].zy_VideoSizeRate;
                [weakSelf.viewController presentViewController:videoPublish animated:YES completion:nil];
            }
        }];
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


#pragma mark --- 获取本地照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage])
    {
        __weak typeof (&*self)weakSelf=self;
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *photoImage=[ZYZCTool fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
            UIImage *compressImage=[ZYZCTool imageByScalingAndCroppingWithSourceImage:photoImage];
            ZYPublishFootprintController  *publishFootprintController=[[ZYPublishFootprintController alloc]init];
            publishFootprintController.images=@[compressImage];
            publishFootprintController.footprintType=Footprint_PhotoType;
            [weakSelf.viewController presentViewController:publishFootprintController animated:YES completion:nil];
        }];
    }
}

-(void)compressVideo:(PHAsset *)asset
{
    
    WEAKSELF;
    NSString *tmpDir = NSTemporaryDirectory();
    self.videoPath=[tmpDir stringByAppendingPathComponent:@"footprint.mp4"];
    [PromptManager showJPGHUDWithMessage:@"视频压缩中…" inView:self.picker.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [MediaUtils compressVideo:asset completeHandler:^(AVAssetExportSession *exportSession, NSURL *compressedOutputURL) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [PromptManager dismissJPGHUD];
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    /******* 压缩成功*******/
                    long long fileSize=[MediaUtils getFileSize:compressedOutputURL.path];
                    //  CGFloat M_Size=fileSize/(1024.0 * 1024.0);
                    //  NSLog(@"+++++压缩后文件大小:%fM",M_Size);
                    /******* 判断压缩后文件大小*******/
                    if (fileSize > 1024 * 1024 * 20) {
                        /******* 压缩后文件较大，删除文件*******/
                        [MediaUtils deleteFileByPath:[compressedOutputURL path]];
                        [weakSelf.picker dismissViewControllerAnimated:YES completion:^{
                            [MBProgressHUD showError:@"视频超过20M,获取失败"];
                            weakSelf.videoImage=nil;
                        }];
                        return ;
                    }
                    /******* 压缩后文件满足要求*******/
                    //复制文件到指定位置
                    [MediaUtils deleteFileByPath:weakSelf.videoPath];
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    BOOL copySuccess=
                    [fileManager copyItemAtPath:[compressedOutputURL path]  toPath:weakSelf.videoPath error:nil];
                    if (copySuccess) {
                        //删除源视频
                        [MediaUtils deleteFileByPath:[compressedOutputURL path]];
                        
                        CGFloat sizeRate=weakSelf.videoImage.size.width/weakSelf.videoImage.size.height;

                        [weakSelf.picker dismissViewControllerAnimated:YES completion:^{
                            
                            ZYShortVideoPublish *shortVideoPublish=[ZYShortVideoPublish new];
                            shortVideoPublish.videoPath=weakSelf.videoPath;
                            shortVideoPublish.img_rate=sizeRate;
                            [weakSelf.viewController presentViewController:shortVideoPublish animated:YES completion:nil];
                        }];
                    }
                }
                else{
                    /******* 压缩失败*******/
                    [MBProgressHUD showError:@"数据异常,压缩失败"];
                    weakSelf.videoImage=nil;
                    [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    });
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",[self class]);
}

@end
