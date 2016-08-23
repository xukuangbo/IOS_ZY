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
//#import "ZYZCLiveController.h"
#import <QPLive/QPLive.h>
#import "ZYLiveViewController.h"
#import "ZYCustomIconView.h"
#import <ReactiveCocoa.h>
#import "JudgeAuthorityTool.h"
#import "ZYZCAccountTool.h"

@interface ZYFaqiLiveViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 封面 */
@property (nonatomic, strong) ZYCustomIconView *faceImg;
/** 修改封面 */
@property (nonatomic, strong) UIButton *changeFaceImg;
/** 标题 */
@property (nonatomic, strong) UITextField *titleTextfield;

/** 开始直播 */
@property (nonatomic, strong) UIButton *startLiveBtn;

@property (nonatomic, strong) UIButton *exitButton;
/**
 *  背景
 */
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;


/** 推流url */
@property(nonatomic, copy) NSString* pushUrl;
/** 拉流url */
@property(nonatomic, copy) NSString* pullUrl;
/** 录像url */
@property(nonatomic, copy) NSString* recordUrl;


@end

@implementation ZYFaqiLiveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configUI];
    //请求头像
    [self requestPersonData];
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
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _bgImageView.userInteractionEnabled = YES;
    
    //封面
    _faceImg = [ZYCustomIconView new];
    [_bgImageView addSubview:_faceImg];
    [_faceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_bgImageView.mas_centerY);
        //        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        
    }];
    ZYZCAccountModel *account = [ZYZCAccountTool account];
    [_faceImg sd_setImageWithURL:[NSURL URLWithString:account.headimgurl] placeholderImage:nil options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
    
    //修改封面
    _changeFaceImg = [UIButton new];
    [_bgImageView addSubview:_changeFaceImg];
    [_changeFaceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_faceImg.mas_centerX);
        make.top.mas_equalTo(_faceImg.mas_bottom).offset(KEDGE_DISTANCE);
        make.height.mas_equalTo(20);
    }];
    [_changeFaceImg setTitle:@"修改封面" forState:UIControlStateNormal];
    [_changeFaceImg setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [_changeFaceImg addTarget:self action:@selector(changeFaceImgAction) forControlEvents:UIControlEventTouchUpInside];
    

    //标题,暂时用个label,后面用textfield,待定
    _titleTextfield = [UITextField new];
    [_bgImageView addSubview:_titleTextfield];
    [_titleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_faceImg.mas_right).offset(KEDGE_DISTANCE);
        make.centerY.mas_equalTo(_faceImg.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(_bgImageView.mas_right);
    }];
    _titleTextfield.placeholder = @"请输入标题";
    
    //开始直播
    _startLiveBtn = [UIButton new];
    [_bgImageView addSubview:_startLiveBtn];
    [_startLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView.mas_centerX);
        make.top.mas_equalTo(_titleTextfield.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    _startLiveBtn.layer.cornerRadius = 24;
    _startLiveBtn.layer.masksToBounds = YES;
    [_startLiveBtn setTitle:@"开启直播" forState:UIControlStateNormal];
    [_startLiveBtn addTarget:self action:@selector(startLive) forControlEvents:UIControlEventTouchUpInside];
    
    //退出按钮
    _exitButton = [UIButton new];
    [_bgImageView addSubview:_exitButton];
    [_exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(_bgImageView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_exitButton setImage:[UIImage imageNamed:@"live-quit"] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -
#pragma mark ---请求头像
- (void)requestPersonData
{
    
}
#pragma mark -
#pragma mark ---changeImg点击动作
- (void)changeFaceImgAction
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    
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


- (void)startLive
{
    QPLiveRequest *request = [[QPLiveRequest alloc] init];
    @weakify(self);
    [request requestCreateLiveWithDomain:@"http://zhongyoulive.s.qupai.me" success:^(NSString *pushUrl, NSString *pullUrl) {
        @strongify(self);
        self.pushUrl = pushUrl;
        self.pullUrl = pullUrl;
        NSLog(@"create live success");
        NSLog(@"pushUrl : %@", pushUrl);
        NSLog(@"pullUrl : %@", pullUrl);
        
        ZYLiveViewController *liveVC = [[ZYLiveViewController alloc] init];
        liveVC.pushUrl = pushUrl;
        liveVC.pullUrl = pullUrl;
        
        
        liveVC.conversationType = ConversationType_CHATROOM;
        liveVC.targetId = @"32";
//        liveVC.contentURL = videoUrl;
//        liveVC.isScreenVertical = _isScreenVertical;
//         *liveVC = [[ZYZCLiveController alloc] init];
//        liveVC.pushUrl = pushUrl;
//        liveVC.pullUrl = pullUrl;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:liveVC animated:YES];
        });
    } failure:^(NSError *error) {
        NSLog(@"create live failed %@", error);
    }];
}
#pragma mark ---exit
- (void)exitAction
{
    //退出控制器
    _imagePicker = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---PickerDelegete
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    self.faceImg.image = image;
}
@end
