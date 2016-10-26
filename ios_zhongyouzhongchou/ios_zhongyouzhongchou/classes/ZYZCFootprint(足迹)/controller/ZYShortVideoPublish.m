//
//  ZYShortVideoPublish.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define img_height         130*KCOFFICIEMNT

#define page_text(page)    [NSString stringWithFormat:@"封面%ld",page]
#define placeHolder_text            @"分享此刻的心情"

#define videoPublish_localText      @"显示当前位置"

#define MAX_LIMIT_NUMS      36

#import "ZYShortVideoPublish.h"
#import "VideoService.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "JudgeAuthorityTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYLocationManager.h"
#import "ZYZCOSSManager.h"
#import "MediaUtils.h"
#import "WXApiManager.h"
#import "ZYBaseLimitTextView.h"
#import "ZYCustomBlurView.h"
@interface ZYShortVideoPublish ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) ZYCustomBlurView    *backImgView;
@property (nonatomic, strong) UILabel             *pageLab;
@property (nonatomic, strong) UIImageView         *cardImg;
@property (nonatomic, strong) ZYBaseLimitTextView *textView;
@property (nonatomic, strong) UILabel             *leftNumLab;
@property (nonatomic, strong) UIImageView         *locationImg;
@property (nonatomic, strong) UILabel             *locationLab;
@property (nonatomic, strong) UISwitch            *switchView;
@property (nonatomic, strong) UIButton            *publishBtn;
@property (nonatomic, strong) UIButton            *shareToFBtn;
@property (nonatomic, strong) UIButton            *shareToPYQBtn;

@property (nonatomic, strong) NSMutableArray      *imageArray;
@property (nonatomic, copy  ) NSString     *currentAddress;//位置
@property (nonatomic, copy  ) NSString     *coordinateStr; //坐标
@property (nonatomic, strong) ZYLocationManager *locationManager;
@property (nonatomic, assign) BOOL         uploadSuccess;
@property (nonatomic, copy  ) NSString      *video;//上传的视频url
@property (nonatomic, copy  ) NSString      *videoImg;//视频图片url
@property (nonatomic, strong) NSNumber      *videoImgSize;//视频图片长宽比值
@property (nonatomic, strong) NSNumber     *videoLen;//视频长
@property (nonatomic, copy  ) NSString      *localVideoImgPath;//本地视频图片路径



/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation ZYShortVideoPublish

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getImageData];
    [self configBodyUI];
    [self configNavUI];
    [_textView becomeFirstResponder];
    [self switchAction:_switchView];
   self.videoLen = [NSNumber numberWithInt:(int)[VideoService getVideoDuration:[NSURL fileURLWithPath:self.videoPath]]];
}

-(void )getImageData
{
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL exist=[manager fileExistsAtPath:self.videoPath];
    if(exist)
    {
        NSArray *images=[VideoService thumbnailImagesForVideo:[NSURL fileURLWithPath:self.videoPath] withImageCount:20];
        self.imageArray=[NSMutableArray arrayWithArray:images];
        if (!_backImgView.image) {
             _backImgView.image=[self.imageArray firstObject];
            //视频长宽比
            CGFloat sizeRate=_backImgView.image.size.width/_backImgView.image.size.height;
            _videoImgSize=[NSNumber numberWithFloat:sizeRate];
        }
    }
}

-(void)configNavUI
{
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLab.text=@"发布视频";
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont systemFontOfSize:20];
    titleLab.centerX=self.view.centerX;
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    //退出按钮
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(0, 0, 60, 44);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [backBtn  addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)configBodyUI {
    
    self.backImgView.image=self.imageArray.count>0?[self.imageArray firstObject]:nil;
    //视频长宽比
    CGFloat sizeRate=_backImgView.image.size.width/_backImgView.image.size.height;
    _videoImgSize=[NSNumber numberWithFloat:sizeRate];
    [self.view addSubview:self.backImgView];
    
    //轮播封面
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 44, KSCREEN_W, img_height)];
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.5;
    pageFlowView.minimumPageScale = 0.85;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    //提前告诉有多少页
    pageFlowView.orginPageCount = self.imageArray.count;
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate=self;
    scrollView.contentSize=CGSizeMake(self.view.width,self.view.height+1);
    [scrollView addSubview:pageFlowView];
    [pageFlowView reloadData];
    
    [self.view addSubview:scrollView];
    
    _pageLab=[ZYZCTool createLabWithFrame:CGRectMake((self.view.width-40)/2, pageFlowView.bottom-20, 40, 15) andFont:[UIFont systemFontOfSize:11.f] andTitleColor:[UIColor whiteColor]];
//    _pageLab.layer.cornerRadius=3;
//    _pageLab.layer.masksToBounds=YES;
//    _pageLab.backgroundColor=[UIColor ZYZC_TextGrayColor01];
    _pageLab.textAlignment=NSTextAlignmentCenter;
    _pageLab.text=page_text((NSInteger)1);
    [scrollView addSubview:_pageLab];
    
    //描述卡片
    _cardImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, pageFlowView.bottom+10, self.view.width-2*KEDGE_DISTANCE, 120) ];
    _cardImg.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0) ;
    _cardImg.userInteractionEnabled = YES;
    [scrollView addSubview:_cardImg];
    
    _textView=[[ZYBaseLimitTextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, _cardImg.width-2*KEDGE_DISTANCE, 50) andMaxTextNum:(NSInteger)MAX_LIMIT_NUMS];
    _textView.font=[UIFont systemFontOfSize:15.f];
    _textView.placeholder = placeHolder_text;
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    [_cardImg addSubview:_textView];
    
    _leftNumLab=[ZYZCTool createLabWithFrame:CGRectMake(_cardImg.width-70, _textView.bottom+5, 60, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _leftNumLab.textAlignment=NSTextAlignmentRight;
    _leftNumLab.text=[NSString stringWithFormat:@"%ld/%ld",(NSInteger)MAX_LIMIT_NUMS,(NSInteger)MAX_LIMIT_NUMS];
    [_cardImg addSubview:_leftNumLab];
    
    _locationImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _leftNumLab.bottom+10, 17, 20)];
    _locationImg.image=[UIImage imageNamed:@"footprint-coordinate-2"];
    [_cardImg addSubview:_locationImg];
    
    _locationLab=[ZYZCTool createLabWithFrame:CGRectMake(_locationImg.right+KEDGE_DISTANCE, _locationImg.top, _cardImg.width-130, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor ZYZC_TextGrayColor01]];
    _locationLab.text = videoPublish_localText;
    [_cardImg addSubview:_locationLab];
    
    _switchView=[[UISwitch alloc]initWithFrame:CGRectMake(_cardImg.width-60, 0, 0, 0)];
    _switchView.on=YES;
    _switchView.top=_cardImg.height-_switchView.height-10;
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_cardImg addSubview:_switchView];
    
    //发布按钮
    _publishBtn = [ZYZCTool createBtnWithFrame:CGRectMake(35, self.view.height-70, self.view.width-70, 40) andNormalTitle:@"发布到足迹" andNormalTitleColor:[UIColor whiteColor] andTarget:self andAction:@selector(publishMyFootprint)];
    _publishBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20.f];
    _publishBtn.layer.cornerRadius=KCORNERRADIUS;
    _publishBtn.layer.masksToBounds=YES;
    _publishBtn.backgroundColor=[UIColor colorWithHexString:@"2ef2c7"];
    [scrollView addSubview:_publishBtn];
    
    //分享
    CGFloat left=(self.view.width-220)/2;
    UIView  *shareToFriend=[self createShareBtnWithFrame:CGRectMake(left, _publishBtn.top-140, 90, 80) andImgName:@"Wechat" andTitle:@"分享给微信朋友" andTag:1];
    [scrollView addSubview:shareToFriend];
    shareToFriend.hidden=YES;
    
    UIView  *shareToPYQ=[self createShareBtnWithFrame:CGRectMake(left+130, shareToFriend.top, 90, 80) andImgName:@"PYQ" andTitle:@"分享到朋友圈" andTag:2];
    [scrollView addSubview: shareToPYQ];
    shareToPYQ.hidden=YES;
    
    WEAKSELF;
    _textView.textChangeBlock = ^(NSInteger leftNum)
    {
        weakSelf.leftNumLab.text = [NSString stringWithFormat:@"%ld/36",leftNum];
    };
}

#pragma mark --- 创建分享视图
-(UIView *)createShareBtnWithFrame:(CGRect)frame andImgName:(NSString *)imgName andTitle:(NSString *)title andTag:(NSInteger)tag
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    
    UIButton *imgBtn=[ZYZCTool createBtnWithFrame:CGRectMake(0, 0, 50, 50) andNormalTitle:nil andNormalTitleColor:nil andTarget:self andAction:@selector(shareToWeChat:)];
    imgBtn.tag=tag;
    [imgBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    if (tag==1) {
        _shareToFBtn=imgBtn;
    }
    else if (tag==2)
    {
        _shareToPYQBtn=imgBtn;
    }
    [view addSubview:imgBtn];
    
    UILabel *lab=[ZYZCTool createLabWithFrame:CGRectMake(0, imgBtn.bottom+10, 0, 20) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor whiteColor]];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text=title;
    [view addSubview:lab];
    CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:title andFont:lab.font andMaxWidth:KSCREEN_W].width;
    lab.width=titleWidth;
    view.width=titleWidth;
    view.height=lab.bottom;
    imgBtn.centerX=lab.centerX;
    
    return view;
}

#pragma mark --- 创建毛玻璃
- (UIImageView *)backImgView
{
    if (!_backImgView) {
        //背景图
        _backImgView=[[ZYCustomBlurView alloc]initWithFrame:self.view.bounds andBlurEffectStyle:UIBlurEffectStyleLight andBlurColor:[UIColor blackColor] andBlurAlpha:1.0 andColorAlpha:0.3];
    }
    return _backImgView;
}

#pragma mark --- 退出
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --- 分享微信
-(void) shareToWeChat:(UIButton *)button
{
    if (button.tag==1) {
        [button setImage:[UIImage imageNamed:@"wechat_1"] forState:UIControlStateNormal];
        [_shareToPYQBtn setImage:[UIImage imageNamed:@"PYQ"] forState:UIControlStateNormal];
    }
    else if (button.tag==2)
    {
        [button setImage:[UIImage imageNamed:@"frends-ship"] forState:UIControlStateNormal];
         [_shareToFBtn setImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
    }
}

#pragma mark ---  发布足迹👣
-(void)publishMyFootprint
{
    _publishBtn.enabled=NO;
    [MBProgressHUD showMessage:nil];
    if(_uploadSuccess)
    {
        [self commitData];
        return;
    }
    
    //将图片数据转换成png格式文件并存储
    _localVideoImgPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"videoImg%@.png"];
    [MediaUtils deleteFileByPath:_localVideoImgPath];
    if (_backImgView.image){
        [UIImagePNGRepresentation(_backImgView.image) writeToFile:_localVideoImgPath atomically:YES];
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
           //视频上传完成，图片
           NSString *videoImgFileName=[NSString stringWithFormat:@"%@/footprint/%@/videoImg.png",userId,timeStmp];
           weakSelf.videoImg=[NSString stringWithFormat:@"%@/%@",KHTTP_FILE_HEAD,videoImgFileName];
           BOOL uploadResult=[ossManager uploadIconSyncByFileName:videoImgFileName andFilePath:_localVideoImgPath];
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
    //类型
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithDictionary:@{
        @"userId":[ZYZCAccountTool getUserId],
        @"type"  :@2,
        }];
    //文字
    _textView.text=[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isEmptyStr=[ZYZCTool isEmpty:_textView.text];
    if (!isEmptyStr) {
        [param setObject:_textView.text forKey:@"content"];
    }
    
    //当前位置
    if (_switchView.isOn==YES) {
        NSDictionary *param01=@{
         @"GPS_Address":_currentAddress,
         @"GPS":_coordinateStr
        };
        NSString *jsonStr=[ZYZCTool turnJson:param01];
        [param setObject:jsonStr forKey:@"gpsData"];
    }
    //视频
    if (_video) {
        [param setObject:_video forKey:@"video"];
    }
    //视频图片
    if (_videoImg) {
        [param setObject:_videoImg forKey:@"videoimg"];
    }
    //视频时长
    if (_videoLen) {
        [param setObject:_videoLen forKey:@"videosize"];
    }
    //视频长宽比
    if (_videoImgSize) {
        [param setObject:_videoImgSize forKey:@"videoimgsize"];
    }
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Publish_Footprint andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess) {
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

#pragma mark --- 是否显示当前位置
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        BOOL allowLocation=[JudgeAuthorityTool judgeLocationAuthority];
        if (allowLocation) {
            
            if (self.currentAddress) {
                self.locationImg.image=[UIImage imageNamed:@"footprint-coordinate"];
                self.locationLab.textColor=[UIColor ZYZC_MainColor];
                self.locationLab.text=self.currentAddress;
                return;
            }
//            [MBProgressHUD showMessage:@"正在获取当前位置"];
            WEAKSELF;
            _locationManager=[ZYLocationManager new];
            _locationManager.getCurrentLocationResult=^(BOOL isSuccess,NSString *currentCity,NSString *currentAddress,NSString *coordinateStr)
            {
                
                if (isSuccess) {
                    weakSelf.currentAddress=currentAddress;
                    weakSelf.coordinateStr=coordinateStr;
                    
                    weakSelf.locationImg.image=[UIImage imageNamed:@"footprint-coordinate"];
                    weakSelf.locationLab.textColor=[UIColor ZYZC_MainColor];
                    weakSelf.locationLab.text=weakSelf.currentAddress;
                    
//                    dispatch_async(dispatch_get_main_queue(), ^
//                                   {
//                                       [MBProgressHUD hideHUD];
//                                   });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
//                                       [MBProgressHUD hideHUD];
//                                       [MBProgressHUD showShortMessage:@"当前位置获取失败"];
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
        _locationImg.image=[UIImage imageNamed:@"footprint-coordinate-2"];
        _locationLab.textColor=[UIColor ZYZC_TextGrayColor01];
        _locationLab.text=videoPublish_localText;
    }
}

#pragma mark --- scrollView Delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textView resignFirstResponder];
}

#pragma mark NewPagedFlowView Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(img_height*_img_rate, img_height);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
//    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, img_height*_img_rate, img_height)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    _pageLab.text=page_text(pageNumber+1);
    _backImgView.image=self.imageArray[pageNumber];
    //视频长宽比
    CGFloat sizeRate=_backImgView.image.size.width/_backImgView.image.size.height;
    DDLog(@"sizeRate:%.2f",sizeRate);
    _videoImgSize=[NSNumber numberWithFloat:sizeRate];

}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void) dealloc
{
    DDLog(@"dealloc:%@",[self class]);
    [ZYNSNotificationCenter  removeObserver:self];
    [MediaUtils deleteFileByPath:_localVideoImgPath];
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
