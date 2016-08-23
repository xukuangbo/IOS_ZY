//
//  UploadVoucherVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/1.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "UploadVoucherVC.h"
#import "CustomImagemapView.h"
#import "MBProgressHUD+MJ.h"
#import "MediaUtils.h"
#import "ZYZCOSSManager.h"
@interface UploadVoucherVC ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) CustomImagemapView *imageMapView;
/**
 *  保存本地判断
 */
//@property (nonatomic, assign) BOOL isSaveLocalImage;
/**
 *  上传oss判断
 */
@property (nonatomic, assign) BOOL isUploadImage;

@end

@implementation UploadVoucherVC

#pragma mark - system方法

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.productID = @1;
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        //设置导航栏颜色
        
        [self configUI];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
    
}
#pragma mark - configUI方法
- (void)configUI
{
    self.title = @"上传凭证";
    //    self.automaticallyAdjustsScrollViewInsets = YES;
    //设置右边取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.size = CGSizeMake(40, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pressBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    //添加背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE + KNAV_STATUS_HEIGHT, KSCREEN_W - KEDGE_DISTANCE * 2, 250 * KCOFFICIEMNT)];
    bgImageView.layer.cornerRadius = 5;
    bgImageView.layer.masksToBounds = YES;
    bgImageView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    bgImageView.userInteractionEnabled=YES;
    [self.view addSubview:bgImageView];
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, bgImageView.width - 2 * KEDGE_DISTANCE, 30)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    titleLabel.text = @"上传凭证的说明";
    [bgImageView addSubview:titleLabel];
    
    //添加说明
    UILabel  *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, titleLabel.bottom + KEDGE_DISTANCE, bgImageView.width - 2 * KEDGE_DISTANCE, 50)];
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.numberOfLines = 2;
    //    descLabel.backgroundColor = [UIColor redColor];
    descLabel.textColor = [UIColor ZYZC_TextGrayColor01];
    
    NSString *textString = @"旅行结束需要上传体现凭证，审核通过才可以将所筹的旅费提现到个人账户";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textString.length)];
    descLabel.attributedText = attributedString;
    [bgImageView addSubview:descLabel];
    
    //下面添加一个可添加图片的view
    CGFloat customImageMapViewW = bgImageView.width - 2 * KEDGE_DISTANCE;
    CGFloat customImageMapViewH = (customImageMapViewW - 2 * KEDGE_DISTANCE) / 3.0;
    _imageMapView = [[CustomImagemapView alloc] initWithFrame:CGRectMake(0, 0, customImageMapViewW, customImageMapViewH)];
    //    imageMapView.size = CGSizeMake(customImageMapViewW, customImageMapViewH);
    _imageMapView.bottom = bgImageView.height - KEDGE_DISTANCE;
    _imageMapView.left = KEDGE_DISTANCE;
    [bgImageView addSubview:_imageMapView];
    
    
    //提交按钮
    CGFloat btnHeight=60;
    UIButton  *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KEDGE_DISTANCE, self.view.height-btnHeight-20, self.view.width-2*KEDGE_DISTANCE, btnHeight);
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"上传凭证" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [sureBtn addTarget:self action:@selector(commitComplain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

#pragma mark - button点击的方法
- (void)pressBack
{
    
//    [_imageMapView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [super pressBack];
    
    
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *voucherPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,KVoucher_File_Path];
    [self clearCache:voucherPath];
}
#pragma mark ---提交凭证方法
- (void)commitComplain
{
    if (self.productID) {
        //没有保存过图片的话
        if (_imageMapView.imgArr.count <= 0) {
            //没有图片
            [MBProgressHUD showError:@"没有图片凭证"];
        }else{
            
            [MBProgressHUD showMessage:@"正在上传"];
            
            //先保存到本地
            for (int i = 0; i < _imageMapView.imgArr.count; i++) {
                UIButton *imageBtn = (UIButton *)_imageMapView.imgArr[i];
                UIImage *image = imageBtn.currentImage;
                NSString *filePath= KVoucher_ImageFile_Path(i);
//                NSLog(@"%@",filePath);
                //先去判断有没有本地图片，有就删除
                [MediaUtils deleteFileByPath:filePath];
                //再进行保存
                [UIImagePNGRepresentation(image)
                 writeToFile:filePath atomically:YES];
            }
            //上传oss
            [self uploadDataToOSS];
        }
    }
    

}

#pragma mark - requestData方法
- (void)uploadDataToOSS
{
    //上传oss
    
    NSString *userId = [ZYZCAccountTool getUserId];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //3次重复操作
        for (int i = 0; i < _imageMapView.imgArr.count; i++) {

        //图片本地路径
        NSString *filePath= KVoucher_ImageFile_Path(i);

        //图片名
        NSString *imageName = [NSString stringWithFormat:@"png%02d.png",i];

        //oss需要的图片名
        NSString *ossImageName = [NSString stringWithFormat:@"%@/%@/%@",userId,_productID,imageName];
       
            BOOL ossUploadJudge = [[ZYZCOSSManager defaultOSSManager] uploadVoucherSyncByFileName:ossImageName andFilePath:filePath];
            if (ossUploadJudge == YES) {//发布成功
                //成功的话就不做操作
                _isUploadImage = YES;
            }else{
                //失败需要弹出对话框
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"上传失败"];
                });
                _isUploadImage = NO;
                break;
            }
        
        }
        
        //判断是否全部上传成功
        if (_isUploadImage == YES) {//全部成功,进行接口访问操作
//            成功的话开始访问我们的接口
            [self uploadOurImage];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败去主线程先隐藏hud
                [MBProgressHUD hideHUD];
                //然后弹框判断是否继续上传
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络异常，发布失败，是否重新发布" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            });
            
        }
    });
    
}


#pragma mark ---上传到我们的服务器
- (void)uploadOurImage
{
    NSString *attachmentString = [NSString string];
    for (int i = 0; i < _imageMapView.imgArr.count; i++) {
        NSString *imageString = [NSString stringWithFormat:@"%@/%@/%@/png%02d.png",KHTTP_VOUCHER_HEAD,[ZYZCAccountTool getUserId],self.productID,i];
        if (attachmentString.length <= 0) {//长度小于0
            attachmentString = [attachmentString stringByAppendingString:imageString];
        }else{//长度大于0
            attachmentString = [attachmentString stringByAppendingString:[NSString stringWithFormat:@",%@",imageString]];
        }
        
    }
    
    NSDictionary *parameters = @{
                                 @"productId":self.productID,
                                 @"attachment":attachmentString
                                 };
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Upload_Voucher andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
//        NSLog(@"%@",result);
        //隐藏菊花
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"上传成功"];
            
            //清楚图片缓存
            NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *voucherPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,KVoucher_File_Path];
        
            [self clearCache:voucherPath];
            
            if (_uploadVoucherSuccess)
            {
                _uploadVoucherSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        //隐藏菊花
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"上传失败"];
        });
    }];
}
#pragma mark ---清楚文件方法
-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //删除文件
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }

}


#pragma mark - 代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (buttonIndex ==1) {
//         NSLog(@"确定继续上传");
         [self uploadDataToOSS];
     }else{
         //取消并不需要删除的操作
     }
}

//- (void)dealloc
//{
//    
//}
@end
