//
//  ZYFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFootprintController.h"
#import <objc/runtime.h>
#import "ZYPublishFootprintController.h"
#import "JudgeAuthorityTool.h"
#import "QupaiSDK.h"
#import "QPEffectMusic.h"
#import "XMNPhotoPickerFramework/XMNPhotoPickerFramework.h"
#import "MediaUtils.h"
#import "PromptController.h"
#import "MBProgressHUD+MJ.h"

#import "ZYFootprintListController.h"
@interface ZYFootprintController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QupaiSDKDelegate>
@property (nonatomic, strong) XMNPhotoPickerController *picker;
@property (nonatomic, strong) UIImage *videoImage;
@property (nonatomic, copy  ) NSString *videoPath;
@property (nonatomic, copy  ) NSString *thumbnailPath;
@end

@implementation ZYFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackItem];
    self.title=@"足迹";
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 80, 40);
    [btn setTitle:@"发布足迹" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    UIButton *btn01=[UIButton buttonWithType:UIButtonTypeCustom];
    btn01.frame=CGRectMake(0, 0, 80, 40);
    [btn01 setTitle:@"我的足迹" forState:UIControlStateNormal];
    btn01.backgroundColor=[UIColor orangeColor];
    btn01.center=self.view.center;
    [btn01 addTarget:self action:@selector(footprint:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn01];


}

-(void)footprint:(UIButton *)sender
{
    [self.navigationController pushViewController:[ZYFootprintListController new] animated:YES];
}

-(void)publish:(UIButton *)sender
{
    //创建UIAlertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    // 拍摄视频
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [QupaiSDK shared].minDurtaion = 2.0;
        [QupaiSDK shared].maxDuration = 15.0;
        UIViewController *controller = [[QupaiSDK shared] createRecordViewController];
        [QupaiSDK shared].delegte = self;
        UINavigationController *navCrl = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navCrl animated:YES completion:nil];
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
                ZYPublishFootprintController  *publishFootprintController=[[ZYPublishFootprintController alloc]init];
                publishFootprintController.images=images;
                publishFootprintController.footprintType=Footprint_AlbumType;
                [weakSelf presentViewController:publishFootprintController animated:YES completion:nil];
            }];
        }];
        
        //选择视频后的回调
        [_picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
            weakSelf.videoImage=[ZYZCTool compressImage:image scale:0.1];
            [weakSelf compressVideo:asset.asset];
        }];
        
        //点击取消
        [_picker setDidCancelPickingBlock:^{
            [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:_picker animated:YES completion:nil];
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
        [self presentViewController:imagePicker animated:YES completion:nil];
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
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 实现短视频代理方法
- (void)qupaiSDK:(id<QupaiSDKDelegate>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
    NSLog(@"Qupai SDK compelete:\n videoPath=%@ \n thumbnailPath=%@",videoPath,thumbnailPath);
    
    if (!videoPath) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (!thumbnailPath) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络错误，视频合成失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (videoPath) {
        
        NSFileManager *manager=[NSFileManager defaultManager];
        BOOL  exit= [manager fileExistsAtPath:videoPath];
        if (!exit) {
            DDLog(@"本地视频不存在");
        }
        else
        {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        }
    }
    if (thumbnailPath) {
        DDLog(@"thumbnailPath:%@",thumbnailPath);
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
    
    WEAKSELF;
    [self dismissViewControllerAnimated:YES completion:^{
        ZYPublishFootprintController *publishFootprintController=[[ZYPublishFootprintController alloc]init];
        publishFootprintController.footprintType=Footprint_VideoType;
        publishFootprintController.videoPath=videoPath;
        publishFootprintController.thumbnailPath=thumbnailPath;
        [weakSelf presentViewController:publishFootprintController animated:YES completion:nil];
    }];
    
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
           UIImage *photoImage = [ZYZCTool fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
            ZYPublishFootprintController  *publishFootprintController=[[ZYPublishFootprintController alloc]init];
            publishFootprintController.images=@[photoImage];
            publishFootprintController.footprintType=Footprint_PhotoType;
            [weakSelf presentViewController:publishFootprintController animated:YES completion:nil];
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
                        //将图片数据转换成png格式文件并存储
                        weakSelf.thumbnailPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"footprint%@.png"];
                        [MediaUtils deleteFileByPath:weakSelf.thumbnailPath];
                        if (weakSelf.videoImage){
                            [UIImagePNGRepresentation(weakSelf.videoImage) writeToFile:weakSelf.thumbnailPath atomically:YES];
                        }
                        
                        [weakSelf.picker dismissViewControllerAnimated:YES completion:^{
//                             [PromptManager showSuccessJPGHUDWithMessage:@"压缩成功" intView: weakSelf.view time:1];
                            ZYPublishFootprintController *publishFootprintController=[[ZYPublishFootprintController alloc]init];
                            publishFootprintController.footprintType=Footprint_VideoType;
                            publishFootprintController.videoPath=weakSelf.videoPath;
                            publishFootprintController.thumbnailPath=weakSelf.thumbnailPath;
                            [weakSelf presentViewController:publishFootprintController animated:YES completion:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
