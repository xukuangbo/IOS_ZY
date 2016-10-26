//
//  ZYFaqiLiveViewController.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYFaqiLiveViewController.h"
#import <RACEXTScope.h>
#import <Masonry.h>
#import <QPSDKCore/QPSDKCore.h>
#import "ZYLiveViewController.h"
#import "ZYCustomIconView.h"
#import <ReactiveCocoa.h>
#import "JudgeAuthorityTool.h"
#import "ZYZCAccountTool.h"
#import "UIView+ZYLayer.h"
#import "MBProgressHUD+MJ.h"
#import "ZYLiveListModel.h"
#import "SelectImageViewController.h"
#import "ZYZCWebViewController.h"
#import "ZYFaqiGuanlianXCView.h"
@interface ZYFaqiLiveViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UIAlertViewDelegate, ZYLiveViewControllerDelegate>
/** 模糊效果 */
@property (nonatomic, strong) UIVisualEffectView *backView;
/** 封面 */
@property (nonatomic, strong) ZYCustomIconView *faceImg;
/** 封面占位文字 */
@property (nonatomic, strong) UILabel *faceTextLabel;
/** 标题 */
@property (nonatomic, strong) UITextField *titleTextfield;
/** 关联直播 */
@property (nonatomic, strong) ZYFaqiGuanlianXCView *guanlianView;
/** 关联的项目id */
@property (nonatomic, copy) NSString *guanlianProductID;
/** 上传图片的url */
@property (nonatomic, copy) NSString *uploadImgString;
/** 开始直播 */
@property (nonatomic, strong) UIButton *startLiveBtn;
/** 退出 */
@property (nonatomic, strong) UIButton *exitButton;
/** 背景 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 图片选择器 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;
/** 推流url */
@property(nonatomic, copy) NSString* pushUrl;
/** 拉流url */
@property(nonatomic, copy) NSString* pullUrl;
/** 录像url */
@property(nonatomic, copy) NSString* recordUrl;


@end

@implementation ZYFaqiLiveViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //配置背景
    [self configUI];
    
    //请求行程数据
    [self requestXCData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark -
#pragma mark ---设置创建UI
- (void)configUI
{
    //navi设置
    self.navigationController.navigationBar.hidden = YES;
    
    //背景
    _bgImageView = [UIImageView new];
    [self.view addSubview:_bgImageView];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.image = [UIImage imageNamed:@"create_bg_live"];
    
    //添加模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _backView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_bgImageView addSubview:_backView];
    _backView.alpha = 0.6;
    
    //退出按钮
    _exitButton = [UIButton new];
    [_bgImageView addSubview:_exitButton];
    [_exitButton setImage:[UIImage imageNamed:@"live-start-quite"] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];

    //封面
    _faceImg = [ZYCustomIconView new];
    _faceImg.clipsToBounds = YES;
    [_bgImageView addSubview:_faceImg];
    _faceImg.layerCornerRadius = 5;
    [_faceImg addTarget:self action:@selector(changeFaceImgAction)];
    
    //封面的一个背景色
    UIView *faceColorBg = [UIView new];
    [_faceImg addSubview:faceColorBg];
    faceColorBg.alpha = 0.2;
    faceColorBg.backgroundColor = [UIColor whiteColor];
    
    //封面的文字
    _faceTextLabel = [UILabel new];
    _faceTextLabel.font = [UIFont systemFontOfSize:18];
    [_faceImg addSubview:_faceTextLabel];
    _faceTextLabel.textColor = [UIColor whiteColor];
    _faceTextLabel.text = @"点击上传封面";
    
    //标题,暂时用个label,后面用textfield
    _titleTextfield = [UITextField new];
    [_bgImageView addSubview:_titleTextfield];
    _titleTextfield.backgroundColor = [UIColor clearColor];
    _titleTextfield.delegate = self;
    _titleTextfield.placeholder = @"请输入标题";
    _titleTextfield.tintColor = [UIColor whiteColor];
    _titleTextfield.textColor = [UIColor whiteColor];
    [_titleTextfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //关联行程
    _guanlianView = [[ZYFaqiGuanlianXCView alloc] init];
    [_bgImageView addSubview:_guanlianView];
    _guanlianView.layer.masksToBounds = NO;
    
    //开始直播
    _startLiveBtn = [UIButton new];
    [_bgImageView addSubview:_startLiveBtn];
    CGFloat startLiveBtnH = 46;
    _startLiveBtn.multipleTouchEnabled = NO;
    _startLiveBtn.backgroundColor = [UIColor ZYZC_MainColor];
    _startLiveBtn.layerBorderColor = [UIColor ZYZC_TextGrayColor];
    _startLiveBtn.layerBorderWidth = 1;
    _startLiveBtn.layer.cornerRadius = startLiveBtnH * 0.5;
    _startLiveBtn.layer.masksToBounds = YES;
    [_startLiveBtn setTitle:@"开启直播" forState:UIControlStateNormal];
    [_startLiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startLiveBtn addTarget:self action:@selector(clickStartLiveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgImageView);
    }];
    
    [faceColorBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_faceImg);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_faceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_faceImg);
        make.height.mas_equalTo(20);
    }];
    
    [_exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KStatus_Height + KEDGE_DISTANCE);
        make.right.mas_equalTo(_bgImageView.mas_right).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_faceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_exitButton).offset(30);
        make.left.equalTo(_bgImageView).offset(10);
        make.right.equalTo(_bgImageView).offset(-10);
        make.height.mas_equalTo(_faceImg.mas_width).multipliedBy(9 / 20.0);
    }];
    
    [_titleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_faceImg.mas_bottom).offset(20);
        make.left.equalTo(_bgImageView).offset(10);
        make.right.equalTo(_bgImageView).offset(-10);
        make.height.mas_equalTo(16);
    }];
    
    [_guanlianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView.mas_left).offset(KEDGE_DISTANCE);
        make.top.equalTo(_titleTextfield.mas_bottom).offset(30);
        make.right.equalTo(_bgImageView.mas_right).offset(-KEDGE_DISTANCE);
        make.height.mas_equalTo(GuanlianViewH);
        
    }];
    
    [_startLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(_titleTextfield.mas_bottom).offset(10);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(startLiveBtnH);
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-100);
    }];
    
}


#pragma mark -
#pragma mark ---请求行程数据
- (void)requestXCData
{
    NSString *url = Get_Live_FaqiXC;
    MJWeakSelf
//    data = {
//        productTitle = Hehe,
//        productId = 121
//    },
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:nil andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSString *title = result[@"data"][@"productTitle"];
        NSString *productID = result[@"data"][@"productId"];
        if (title) {
            weakSelf.guanlianView.hidden = NO;
            weakSelf.guanlianProductID = productID;
            weakSelf.guanlianView.travelLabel.text = title;
        }else{
            weakSelf.guanlianView.hidden = YES;
        }
    } andFailBlock:^(id failResult) {
        
    }];
}


#pragma mark - 监听通知
//- (void)addNoti{
//    //监听键盘的出现
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    //收起
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
//    //监听键盘高度改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}

#pragma mark -
#pragma mark ---changeImg点击动作
- (void)changeFaceImgAction
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    
    WEAKSELF
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
        [weakSelf presentViewController:weakSelf.imagePicker animated:YES completion:nil];
        
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
        [weakSelf presentViewController:weakSelf.imagePicker animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:draftsAction];
    [alertController addAction:giftCardAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clickStartLiveButtonAction
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    // 判断是否同意直播协议
    if ([userDefaults boolForKey:CREATE_LIVE_AGREEMENT]) {
        [self startLive];
    } else {
        UIAlertView *liveAgreementAlertview = [[UIAlertView alloc] initWithTitle:nil message:@"点击确认同意众游直播协议" delegate:self cancelButtonTitle:@"查看协议" otherButtonTitles:@"确定", nil];
        [liveAgreementAlertview show];
    }
}
    

- (void)startLive
{
    //先上传图片,再请求趣拍创建直播,成功后再请求我们的服务器创建直播
    WEAKSELF
    [_faceImg uploadImageToOSS:_faceImg.image andResult:^(BOOL result, NSString *imgUrl) {
        if (result == YES) {//成功
            
            weakSelf.uploadImgString = imgUrl;
            //请求直播
            [weakSelf requestLive];
            
        }else{
            //展示出上传失败
            [MBProgressHUD showMessage:@"上传图片失败" toView:weakSelf.view];
            //延时1秒后删掉
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showHintWithText:@"上传图片失败，请重新创建"];
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            });
        }
    }];
    
}

//请求直播
- (void)requestLive
{
    //必须有封面
    if(self.faceImg.image == nil){
        [self showHintWithText:@"请选择封面图片"];
        return ;
    }
    
    QPLiveRequest *request = [[QPLiveRequest alloc] init];
    // http://zhongyoutest01.s.qupai.me
    WEAKSELF
    [request requestCreateLiveWithDomain:@"http://zhongyoulive.s.qupai.me" success:^(NSString *pushUrl, NSString *pullUrl) {
        
        weakSelf.pushUrl = pushUrl;
        weakSelf.pullUrl = pullUrl;
        NSLog(@"create live success");
        NSLog(@"pushUrl : %@", pushUrl);
        NSLog(@"pullUrl : %@", pullUrl);
        
        //请求我们的服务器创建直播
        [weakSelf createLiveDataWithPushUrl:pushUrl pullUrl:pullUrl];
        
    } failure:^(NSError *error) {
        
        NSLog(@"create live failed %@", error);
        
    }];
}

#pragma mark ---创建服务器直播
- (void)createLiveDataWithPushUrl:(NSString *)pushUrl pullUrl:(NSString *)pullUrl
{
    //分割pullURL,获取spaceName和streamName
    //    http://play.lss.qupai.me/zhongyoulive/zhongyoulive-1TS1A.flv?auth_key=1471681152-0-2156-87d5e4a6853084c4e9a1b03126899a4b
    NSString *chatRoomId = [NSString stringWithFormat:@"chatRoomId%@",[ZYZCAccountTool getUserId]];
    ZYLiveListModel *createLiveModel = [[ZYLiveListModel alloc] init];
    NSArray *temArr1 = [pullUrl componentsSeparatedByString:@".flv"];
    NSArray *temArr2 = [temArr1[0] componentsSeparatedByString:@"/"];
    createLiveModel.streamName = temArr2[temArr2.count - 1];
    createLiveModel.spaceName = temArr2[temArr2.count - 2];
    createLiveModel.pullUrl = pullUrl;
    createLiveModel.title = self.titleTextfield.text;
    createLiveModel.img = self.uploadImgString;
    createLiveModel.chatRoomId = chatRoomId;
    //判断是否关联行程
    if (self.guanlianView.judgeTravelButton.selected == YES) {
        createLiveModel.productId = self.guanlianProductID;
        createLiveModel.productTitle = self.guanlianView.travelLabel.text;
        
    }

    ZYLiveViewController *liveVC = [[ZYLiveViewController alloc] initLiveModel:createLiveModel];
    liveVC.delegate = self;
    liveVC.targetId = chatRoomId;
    liveVC.pushUrl = pushUrl;
    if ([[NSString stringWithFormat:@"%@", self.guanlianProductID] length] != 0) {
        liveVC.productID = self.guanlianProductID;
    }
    liveVC.conversationType = ConversationType_CHATROOM;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self presentViewController:liveVC animated:NO completion:nil];
        [self.navigationController pushViewController:liveVC animated:YES];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)exitAction
{
    //退出控制器
    _imagePicker = nil;
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - PickerDelegete
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage])
    {
        __weak typeof (&*self)weakSelf=self;
        [picker dismissViewControllerAnimated:YES completion:^{
            SelectImageViewController *selectImgVC=[[SelectImageViewController alloc]initWithImage:[ZYZCTool fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]] WHScale:(20 / 9.0)];
            selectImgVC.imageBlock=^(UIImage *img)
            {
                weakSelf.faceImg.image=[ZYZCTool imageByScalingAndCroppingWithSourceImage:img] ;
            };
            [weakSelf.navigationController pushViewController:selectImgVC animated:YES];
        }];
    }
}

#pragma mark - UITextfieldDelegete
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ZYZCWebViewController *webVC = [[ZYZCWebViewController alloc] initWithUrlString:@"https://www.baidu.com"];
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        [self startLive];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:CREATE_LIVE_AGREEMENT];
        [defaults synchronize];
    }
}

#pragma mark - ZYLiveViewControllerDelegate
- (void)backHomePage
{
    [self exitAction];
}
//#pragma mark - 键盘高度改变通知
//#pragma mark --- 键盘出现
//-(void)keyboardWillShow:(NSNotification *)notify
//{
//    NSDictionary *dic = notify.userInfo;
//    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
//    CGFloat height=value.CGRectValue.size.height;
//    if (height < 100) {
//        height = 100;
//    }
//    
//    [_startLiveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-height-10);
//    }];
//}
//#pragma mark - 键盘收起方法
//-(void)keyboardWillHidden:(NSNotification *)notify
//{
//    [_startLiveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-100);
//    }];
//}
//
//#pragma mark --- 键盘高度改变
//-(void)keyboardWillChangeFrame:(NSNotification *)notify
//{
//    NSDictionary *dic = notify.userInfo;
//    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
//    CGFloat height=value.CGRectValue.size.height;
//    if (height < 100) {
//        height = 100;
//    }
//    
//    [_startLiveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-height - 10);
//    }];
//    
//}
@end
