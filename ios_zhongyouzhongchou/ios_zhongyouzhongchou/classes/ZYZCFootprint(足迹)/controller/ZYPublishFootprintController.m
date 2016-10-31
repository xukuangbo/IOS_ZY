//
//  ZYPublishFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define PLACEHOLDER_TEXT  @"分享此刻的心情"
#define LOCATION_TEXT     @"显示当前位置"
#define Max_Limit_Num     100

#define PIC_HEIGHT     (KSCREEN_W-60)/3.0
#define BGIMAGE_HEIGHT PIC_HEIGHT*2+80

#import "ZYPublishFootprintController.h"
#import <objc/runtime.h>
#import "HUImagePickerViewController.h"
#import "HUPhotoBrowser.h"
#import "XMNPhotoPickerController.h"
#import "JudgeAuthorityTool.h"
#import "ZYLocationManager.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCOSSManager.h"
#import "ZYZCCusomMovieImage.h"
#import "ZYBaseLimitTextView.h"
@interface ZYPublishFootprintController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton     *publishBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *bgImageView;
@property (nonatomic, strong) ZYBaseLimitTextView *textView;//文字
//@property (nonatomic, strong) UILabel      *placeHolderLab;

@property (nonatomic, strong) UIView       *contentView;//图片，视频。。。
@property (nonatomic, strong) UIView       *locationView;//显示位置
@property (nonatomic, strong) UIButton     *addBtn;
@property (nonatomic, strong) XMNPhotoPickerController *picker;
@property (nonatomic, strong) UIImageView  *locationIcon;
@property (nonatomic, strong) UILabel      *locationLab;
@property (nonatomic, assign) BOOL         showLocation;
@property (nonatomic, copy  ) NSString     *currentAddress;
@property (nonatomic, copy  ) NSString     *coordinateStr;
@property (nonatomic, strong) ZYLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *fileTmpPathArr;
@property (nonatomic, strong) NSMutableArray *imgUrlArr;
@property (nonatomic, copy  ) NSString       *video;
@property (nonatomic, copy  ) NSString       *videoImg;
@property (nonatomic, assign) BOOL         uploadSuccess;

@end

@implementation ZYPublishFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self configNavUI];
    [self configBodyUI];
    [self reloadDataByType:self.footprintType];
    //监听文本改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)configNavUI
{
    //navUI
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    navView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:navView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleLab.text=@"添加足迹";
    titleLab.textColor=[UIColor ZYZC_TextBlackColor];
    titleLab.font=[UIFont systemFontOfSize:20];
    titleLab.centerX=navView.centerX;
    [navView addSubview:titleLab];
    
    //退出按钮
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 20, 50, 44);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [backBtn  addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //发布按钮
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(KSCREEN_W-60, 20, 50, 44);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(publishMyFootprint) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:publishBtn];
    _publishBtn=publishBtn;
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, navView.height-0.5, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]];
    [navView addSubview:lineView];
}

-(void)configBodyUI
{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_W, KSCREEN_H-64)];
    _scrollView.contentSize=CGSizeMake(0, _scrollView.height+1);
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    
    //卡片
    _bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, _scrollView.width-2*KEDGE_DISTANCE, BGIMAGE_HEIGHT)];
    _bgImageView.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _bgImageView.userInteractionEnabled=YES;
    [_scrollView addSubview:_bgImageView];
    
    //文字框
    _textView=[[ZYBaseLimitTextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, _bgImageView.width-2*KEDGE_DISTANCE, PIC_HEIGHT) andMaxTextNum:Max_Limit_Num];
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.placeholder=PLACEHOLDER_TEXT;
    [_bgImageView addSubview:_textView];
    
    
    //放图片，视频的控件
    _contentView=[[UIView alloc]initWithFrame:CGRectMake(0,_textView.bottom+KEDGE_DISTANCE , _bgImageView.width, PIC_HEIGHT)];
//    _contentView.backgroundColor=[UIColor orangeColor];
    [_bgImageView addSubview:_contentView];
    
    //添加按钮
    _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame=CGRectMake(KEDGE_DISTANCE, 0, PIC_HEIGHT, PIC_HEIGHT);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"footprint-add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.hidden=YES;
    [_contentView addSubview:_addBtn];
    
    //显示位置
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentView.bottom+KEDGE_DISTANCE,_bgImageView.width , 40)];
    [_bgImageView addSubview:_locationView];
    
    [_locationView addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, _locationView.width, 0.5) andColor:[UIColor lightGrayColor]]];
    
    UIImageView  *locationIcon=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, (_locationView.height-23)/2.0, 19, 23)];
    locationIcon.image=[UIImage imageNamed:@"footprint-coordinate-2"];
    [_locationView addSubview:locationIcon];
    _locationIcon=locationIcon;
    
    
    UILabel *locationLab=[[UILabel alloc]initWithFrame:CGRectMake(locationIcon.right+KEDGE_DISTANCE, 0, 200, _locationView.height)];
    locationLab.text=LOCATION_TEXT;
    locationLab.font=[UIFont systemFontOfSize:15];
    locationLab.textColor=[UIColor ZYZC_TextGrayColor01];
    [_locationView addSubview:locationLab];
    _locationLab=locationLab;
    
    UISwitch *locationSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(_locationView.width-60, (_locationView.height-30)/2, 50, 30)];
    locationSwitch.on=NO;
    [locationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_locationView addSubview:locationSwitch];
    
    _showLocation=locationSwitch.on;
}

#pragma mark --- 文字改变
-(void)textChange:(NSNotification *)notify
{
    
    NSString *text=[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isEmptyStr=[ZYZCTool isEmpty:text];
    if (isEmptyStr) {
        _publishBtn.enabled=NO;
        [_publishBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        _publishBtn.enabled=YES;
        [_publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    }
}


#pragma mark --- 是否显示当前位置
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    _showLocation=switchButton.on;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        BOOL allowLocation=[JudgeAuthorityTool judgeLocationAuthority];
        if (allowLocation) {
            
            if (self.currentAddress) {
                self.locationIcon.image=[UIImage imageNamed:@"footprint-coordinate"];
                self.locationLab.textColor=[UIColor ZYZC_MainColor];
                self.locationLab.text=self.currentAddress;
                return;
            }
            [MBProgressHUD showMessage:@"正在获取当前位置"];
            WEAKSELF;
            _locationManager=[ZYLocationManager new];
            _locationManager.getCurrentLocationResult=^(BOOL isSuccess,NSString *currentCity,NSString *currentAddress,NSString *coordinateStr)
            {
                
                if (isSuccess) {
                    weakSelf.currentAddress=currentAddress;
                    weakSelf.coordinateStr=coordinateStr;
                    
                    weakSelf.locationIcon.image=[UIImage imageNamed:@"footprint-coordinate"];
                    weakSelf.locationLab.textColor=[UIColor ZYZC_MainColor];
                    weakSelf.locationLab.text=weakSelf.currentAddress;

                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [MBProgressHUD hideHUD];
                                   });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [MBProgressHUD hideHUD];
                                       [MBProgressHUD showShortMessage:@"当前位置获取失败"];
                                       switchButton.on=NO;
                                   });
                }
            };
            [_locationManager getCurrentLocation];
        }
        else
        {
            switchButton.on=NO;
        }
    }else {
        _locationIcon.image=[UIImage imageNamed:@"footprint-coordinate-2"];
        _locationLab.textColor=[UIColor ZYZC_TextGrayColor01];
        _locationLab.text=LOCATION_TEXT;
    }
    DDLog(@"showLocation:%d",_showLocation);
}


#pragma mark --- 加载图片
-(void)reloadDataByType:(FootprintType)footprintType
{
    NSArray *views=[_contentView subviews];
    for (NSInteger i=views.count-1; i>=0; i-- ) {
        if ([views[i] isKindOfClass:[UIImageView class]]) {
            [views[i] removeFromSuperview];
        }
    }
    
    //加载图片
    if (footprintType==Footprint_AlbumType||footprintType==Footprint_PhotoType) {
        if (_images.count) {
            NSInteger count=_images.count;
            CGFloat lastBottom=0.0;
            for (NSInteger i=0; i<count; i++) {
                UIImageView *pic= [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE+(i%3)*(PIC_HEIGHT+KEDGE_DISTANCE), (i/3)*(PIC_HEIGHT+KEDGE_DISTANCE), PIC_HEIGHT, PIC_HEIGHT)];
                pic.image=_images[i];
                pic.tag=i;
                pic.contentMode=UIViewContentModeScaleAspectFill;
                pic.layer.masksToBounds=YES;
                lastBottom=pic.bottom;
                [pic addTarget:self action:@selector(tapPic:)];
                [_contentView addSubview:pic];
                
                if(i==count-1&&i<8)
                {
                    _addBtn.frame=CGRectMake(KEDGE_DISTANCE+((i+1)%3)*(PIC_HEIGHT+KEDGE_DISTANCE), ((i+1)/3)*(PIC_HEIGHT+KEDGE_DISTANCE),PIC_HEIGHT,PIC_HEIGHT);
                    lastBottom=_addBtn.bottom;
                    _addBtn.hidden=NO;
                }
                if (i==8) {
                    _addBtn.hidden=YES;
                }
            }
            _contentView.height=lastBottom;
        }
        else
        {
            _addBtn.hidden=NO;
            _contentView.height=PIC_HEIGHT;
            _addBtn.frame=CGRectMake(KEDGE_DISTANCE, 0, PIC_HEIGHT, PIC_HEIGHT);
        }
    }
    else if(self.footprintType==Footprint_VideoType)
    {
        ZYZCCusomMovieImage *videoImage=[[ZYZCCusomMovieImage alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, PIC_HEIGHT*71/40, PIC_HEIGHT)];
        videoImage.image=[UIImage imageWithContentsOfFile:self.thumbnailPath];
        CGFloat start_width=PIC_HEIGHT/2.0;
        videoImage.startImg.frame=CGRectMake((videoImage.width-start_width)/2, (videoImage.height-start_width)/2, start_width, start_width);
        videoImage.startImg.image=[UIImage imageNamed:@"footprint-play"];
        videoImage.playUrl=self.videoPath;
        videoImage.playType=Local_Video;
        [_contentView addSubview:videoImage];
        }
    
    _locationView.top= _contentView.bottom+KEDGE_DISTANCE;
    _bgImageView.height=_locationView.bottom+KEDGE_DISTANCE;
    _bgImageView.height=MAX(_bgImageView.height, BGIMAGE_HEIGHT);
    _scrollView.contentSize=CGSizeMake(0, MAX(_scrollView.contentSize.height, _bgImageView.bottom+KEDGE_DISTANCE));
    
}

#pragma mark --- 点击浏览和编辑图片
-(void)tapPic:(UITapGestureRecognizer *)tap
{
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
    
    UIImageView *pic=(UIImageView *)tap.view;
    
    WEAKSELF;
    HUPhotoBrowser *browser=[HUPhotoBrowser showFromImageView:pic withImages:_images atIndex:pic.tag dismissWithImages:^(NSArray * _Nullable images) {
            weakSelf.images=images;
            [self reloadDataByType:Footprint_AlbumType];
        if(!weakSelf.images.count&&!weakSelf.textView.text.length)
        {
            weakSelf.publishBtn.enabled=NO;
            [weakSelf.publishBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
        }
        }];
    browser.notDismissWhenDelete=YES;
}

#pragma mark --- 添加图片
-(void)addPic
{
    if (self.footprintType==Footprint_PhotoType) {
        [self createActionView];
    }
    else if (self.footprintType==Footprint_AlbumType){
        _picker=nil;
        _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:9-_images.count delegate:nil];
        _picker.pickingVideoEnable=NO;
        _picker.autoPushToPhotoCollection=YES;

        __weak typeof(self) weakSelf = self;
        // 选择图片后回调
        [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable asset) {
            
            [weakSelf.picker dismissViewControllerAnimated:NO completion:^{
                weakSelf.images= [weakSelf.images arrayByAddingObjectsFromArray:images];
                [weakSelf reloadDataByType:Footprint_AlbumType];
                if (weakSelf.images.count) {
                    weakSelf.publishBtn.enabled=YES;
                      [weakSelf.publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
                }
            }];
        }];
        
        //点击取消
        [_picker setDidCancelPickingBlock:^{
            [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:_picker animated:YES completion:nil];
    }
}

#pragma mark --- 创建选择器（选择本地或拍照）
-(void)createActionView
{
    //创建UIAlertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //选择本地相册
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否可以选择照片
        BOOL canChooseAlbum=[JudgeAuthorityTool judgeAlbumAuthority];
        if (!canChooseAlbum) {
            return ;
        }

        _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:9-_images.count  delegate:nil];
        _picker.pickingVideoEnable=NO;
        _picker.autoPushToPhotoCollection=YES;

        WEAKSELF
        // 选择图片后回调
        [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable asset) {
            weakSelf.images=[weakSelf.images arrayByAddingObjectsFromArray:images];
            [weakSelf reloadDataByType:Footprint_AlbumType];
            [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
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
    [albumAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    [photoAction setValue:[UIColor ZYZC_TextBlackColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:albumAction];
    [alertController addAction:photoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 获取本地照片的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage])
    {
        
        UIImage *photoImage = [ZYZCTool fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
        self.images=[self.images arrayByAddingObject:photoImage];
        [self reloadDataByType:self.footprintType];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark --- scrollView代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
}

#pragma mark --- 返回操作
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---  发布足迹👣
-(void)publishMyFootprint
{
    _publishBtn.enabled=NO;
    //发布图文
    if (self.footprintType==Footprint_AlbumType||self.footprintType==Footprint_PhotoType) {
        [self albumTypePublish];
    }
    //发布视频
    else if(self.footprintType==Footprint_VideoType)
    {
        [self videoTypePublish];
    }
}

#pragma mark --- 图文发布
-(void)albumTypePublish
{
    [MBProgressHUD showMessage:nil];
    
    if(_uploadSuccess)
    {
        [self commitData];
        return;
    }
    
    if (_images.count)
    {
        _fileTmpPathArr=[NSMutableArray array];
        _imgUrlArr=[NSMutableArray array];
        //将图片保存到本地tmp中
        NSString *tmpDir = NSTemporaryDirectory();
        for (NSInteger i=0; i<_images.count; i++) {
            NSString *path =[tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"footprint_album%ld.png",i]];
            [_fileTmpPathArr addObject:path];
            UIImage *image=_images[i];
            BOOL writeResult=[UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
            if (!writeResult) {
                [MBProgressHUD showError:@"数据错误，提交失败"];
                return;
            }
        }
        
        //将图片上传到oss
        ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
        
        __weak typeof (&*self)weakSelf=self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^
       {
           NSString *userId=[ZYZCAccountTool getUserId];
           NSString *timeStmp=[ZYZCTool getTimeStamp];
           for (NSInteger i=0; i<_fileTmpPathArr.count; i++) {
               NSString *fileName=[NSString stringWithFormat:@"%@/footprint/%@/%.2ld.png",userId,timeStmp,i+1];
               NSString *imgUrl=[NSString stringWithFormat:@"%@/%@",KHTTP_FILE_HEAD,fileName];
               [weakSelf.imgUrlArr addObject:imgUrl];
               BOOL uploadResult=[ossManager uploadIconSyncByFileName:fileName andFilePath:_fileTmpPathArr[i]];
               if (!uploadResult) {
                   //回到主线程提示上传失败
                   dispatch_async(dispatch_get_main_queue(), ^
                  {
                      [MBProgressHUD hideHUD];
                      [MBProgressHUD showShortMessage:@"网络错误,提交失败"];
                      weakSelf.publishBtn.enabled = YES;
                  });
                   return;
               }
           }
           //数据上传完成， 回到主线程
           dispatch_async(dispatch_get_main_queue(), ^
          {
              _uploadSuccess=YES;
              [MBProgressHUD hideHUD];
              [self commitData];
          });
       });
    }
    else
    {
//        [MBProgressHUD hideHUD];
        [self commitData];
    }
}

#pragma mark --- 发布视频
-(void)videoTypePublish
{
    [MBProgressHUD showMessage:nil];
    
    if(_uploadSuccess)
    {
        [self commitData];
        return;
    }
    
    //将视频和视频第一帧上传到oss
    ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
    
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(0, 0), ^
       {
           NSString *userId=[ZYZCAccountTool getUserId];
           NSString *timeStmp=[ZYZCTool getTimeStamp];
           
           NSString *videoFileName=[NSString stringWithFormat:@"%@/footprint/%@/video.mp4",userId,timeStmp];
            weakSelf.video=[NSString stringWithFormat:@"%@/%@",KHTTP_FILE_HEAD,videoFileName];
           BOOL uploadResult=[ossManager uploadIconSyncByFileName:videoFileName andFilePath:weakSelf.videoPath];
               if (!uploadResult) {
                   //回到主线程提示上传失败
                 dispatch_async(dispatch_get_main_queue(), ^
                  {
                      [MBProgressHUD hideHUD];
                      [MBProgressHUD showShortMessage:@"网络错误,提交失败"];
                      weakSelf.publishBtn.enabled = YES;
                  });
                   return;
               }
               else
               {
                   //视频上传完成，上传第一帧
                   NSString *videoImgFileName=[NSString stringWithFormat:@"%@/footprint/%@/videoImg.png",userId,timeStmp];
                    weakSelf.videoImg=[NSString stringWithFormat:@"%@/%@",KHTTP_FILE_HEAD,videoImgFileName];
                   BOOL uploadResult=[ossManager uploadIconSyncByFileName:videoImgFileName andFilePath:weakSelf.thumbnailPath];
                   if (!uploadResult) {
                       //回到主线程提示上传失败
                       dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [MBProgressHUD hideHUD];
                            [MBProgressHUD showShortMessage:@"网络错误,提交失败"];
                            weakSelf.publishBtn.enabled = YES;
                        });
                       return;
                   }
                   else
                   {
                       //数据上传完成， 回到主线程
                       dispatch_async(dispatch_get_main_queue(), ^
                        {
                          weakSelf.uploadSuccess=YES;
                          [MBProgressHUD hideHUD];
                          [weakSelf commitData];
                        });
                   }
               }
       });
}

#pragma mark --- 上传数据到服务器
-(void)commitData
{
    NSNumber *type=0;
   
    //类型
    if (self.footprintType==Footprint_AlbumType||self.footprintType==Footprint_PhotoType) {
        type=@1;
    }
    else if (self.footprintType==Footprint_VideoType)
    {
        type=@2;
    }
    
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithDictionary:@{
        @"userId":[ZYZCAccountTool getUserId],
        @"type"  :type,
    }];
    //文字
    _textView.text=[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isEmptyStr=[ZYZCTool isEmpty:_textView.text];
    if (!isEmptyStr) {
        [param setObject:_textView.text forKey:@"content"];
    }
    
    //当前位置
    if (_showLocation) {
        NSDictionary *param01=@{@"GPS_Address":_currentAddress,
                                @"GPS":_coordinateStr
                                };
        NSString *jsonStr=[ZYZCTool turnJson:param01];
        [param setObject:jsonStr forKey:@"gpsData"];
    }
    //图片
    if (_imgUrlArr.count) {
        NSString *images=[_imgUrlArr componentsJoinedByString:@","];
        [param setObject:images forKey:@"pics"];
    }
    //视频
    if (_video) {
        [param setObject:_video forKey:@"video"];
        [param setObject:_videoImg forKey:@"videoimg"];
        [param setObject:[NSNumber numberWithFloat:_videoimgsize] forKey:@"videoimgsize"];
        [param setObject:[NSNumber numberWithInt:(int)_videoLength] forKey:@"videosize"];
    }

    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_addYouji"] andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUD];
        _publishBtn.enabled=YES;
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [MBProgressHUD showSuccess:@"发布成功"];
            //发足迹成功通知
            [[NSNotificationCenter defaultCenter]postNotificationName:PUBLISH_FOOTPRINT_SUCCESS object:nil];
        }
        else
        {
            [MBProgressHUD showError:@"发布失败"];
        }
    }
     andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"发布失败"];
         _publishBtn.enabled=YES;
     }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",[self class]);
    
    for (NSInteger i=0; i<_fileTmpPathArr.count; i++) {
        [ZYZCTool removeExistfile:_fileTmpPathArr[i]];
    }
    
    [ZYZCTool removeExistfile:self.video];
    [ZYZCTool removeExistfile:self.videoImg];
    
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
