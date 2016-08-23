//
//  ZYCustomIconView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define IMG_WIDTH  640
#import "ZYCustomIconView.h"
#import "JudgeAuthorityTool.h"
#import "ZYZCOSSManager.h"
#import "MBProgressHUD+MJ.h"
@interface ZYCustomIconView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy  ) NSString  *tmpPath;
@end

@implementation ZYCustomIconView

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
        self.contentMode=UIViewContentModeScaleAspectFill;
        [self addTarget:self action:@selector(chooseIcon)];
    }
    return self;
}

#pragma mark --- 选择头像
-(void)chooseIcon
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing=YES;
    __weak typeof (&*self)weakSelf=self;
    //创建UIAlertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //选择本地相册
    UIAlertAction *draftsAction = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断是否可以选择照片
        BOOL canChooseAlbum=[JudgeAuthorityTool judgeAlbumAuthority];
        if (!canChooseAlbum) {
            return ;
        }
        weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        weakSelf.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [weakSelf.viewController presentViewController:weakSelf.imagePicker animated:YES completion:nil];
    }];
    //选择拍照
    UIAlertAction *giftCardAction = [UIAlertAction actionWithTitle:@"拍照获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断是否可以拍照
        BOOL canUseMedia=[JudgeAuthorityTool judgeMediaAuthority];
        if (!canUseMedia) {
            return ;
        }
        
        weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        weakSelf.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [weakSelf.viewController presentViewController:weakSelf.imagePicker animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:draftsAction];
    [alertController addAction:giftCardAction];
    
    
    if (self.viewController) {
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        //更改图片尺寸
        UIImage *newImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(IMG_WIDTH, IMG_WIDTH)];
        self.image=newImage;
        if (_finishChoose) {
            _finishChoose(newImage);
        }
        //选择图片后的回调
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


//更改图片尺寸
- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize
{
    UIGraphicsBeginImageContext (newSize);
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}

#pragma mark --- 将图片上传到oss
 -(void)uploadImageToOSS:(UIImage *)image andResult:(UploadToOSSResult)uploadToOSSResult
{
    //将图片保存到本地tmp中
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *path =[tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[ZYZCTool getTimeStamp]]];
    _tmpPath=path;
    BOOL writeResult=[UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    
    //保存图片到本地tmp成功
    if (writeResult) {
        //将图片上传到oss
        ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
        __weak typeof (&*self)weakSelf=self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *userId=[ZYZCAccountTool getUserId];
            if (!userId) {
                userId=weakSelf.userId;
            }
            NSString *fileName=[NSString stringWithFormat:@"%@/%@",userId,KUSER_ICON];
            
            NSString *imgUrl=[NSString stringWithFormat:@"%@/%@",KHTTP_FILE_HEAD,fileName];
            
           BOOL result=[ossManager uploadIconSyncByFileName:fileName andFilePath:path];
            //操作完成，回到主线程
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
                //上传后操作
                if (uploadToOSSResult) {
                    uploadToOSSResult(result,imgUrl);
                }
            });
        });
    }
    else
    {
        if (uploadToOSSResult) {
            uploadToOSSResult(NO,nil);
        }
    }
    
}

#pragma mark --- 删除文件
-(void)deleteFileByPath:(NSString *)path{
    if (!path) {
        return;
    }
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fm fileExistsAtPath:path isDirectory:&isDir];
    
    NSError* error = nil;
    if (existed) {
        [fm removeItemAtPath:path error:&error];
//        NSLog(@"deleteError:%@", error);
    }
}


-(void)dealloc
{
    //删除tmp文件
    [self deleteFileByPath:_tmpPath];
    
//    NSLog(@"dealloc:%@",self.class);

}


@end
