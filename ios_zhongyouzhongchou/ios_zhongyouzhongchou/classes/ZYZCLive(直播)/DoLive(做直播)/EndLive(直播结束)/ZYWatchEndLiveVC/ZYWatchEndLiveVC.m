//
//  ZYWatchEndLiveVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYWatchEndLiveVC.h"
#import "UIView+ZYLayer.h"
#import "WatchEndLiveModel.h"
#import "ZYZCAccountTool.h"
#import "MBProgressHUD+MJ.h"
#define iconCornerRadious 50

@interface ZYWatchEndLiveVC ()
@property (nonatomic, assign) BOOL friendship;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
/** 模糊效果 */
@property (nonatomic, strong) UIVisualEffectView *backView;
@property (weak, nonatomic) IBOutlet UIView *personMapView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)guanzhuButtonAction:(UIButton *)sender;
- (IBAction)backButtonAction:(UIButton *)sender;

@end

@implementation ZYWatchEndLiveVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bgImageView.image = [UIImage imageNamed:@"create_bg_live"];
    _iconView.image = [UIImage imageNamed:@"icon_live_placeholder"];
    //圆角
    _iconView.layerCornerRadius = iconCornerRadious;
    _guanzhuButton.layerCornerRadius = 5;
    _backButton.layerCornerRadius = 5;
    //添加模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _backView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _backView.frame = self.view.frame;
    [_bgImageView addSubview:_backView];
    _backView.alpha = 0.6;
    
    
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    //头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_watchEndLiveModel.headImgUrl] placeholderImage:nil options:option];
    //名字
    _nameLabel.text = _watchEndLiveModel.name.length > 0? _watchEndLiveModel.name : @"未知";
    
    //性别
    _sexImageView.image = [_watchEndLiveModel.sex isEqualToString:@"1"]? [UIImage imageNamed:@"btn_sex_fem"] : [UIImage imageNamed:@"btn_sex_mal"];
    
    //是否关注
    _friendship = _watchEndLiveModel.isGuanzhu;
    if (_watchEndLiveModel.isGuanzhu == YES) {
        [_guanzhuButton setTitle:@"已关注" forState:UIControlStateNormal];
        _guanzhuButton.backgroundColor = [UIColor lightGrayColor];
    }else{
        [_guanzhuButton setTitle:@"关注" forState:UIControlStateNormal];
        _guanzhuButton.backgroundColor = [UIColor ZYZC_MainColor];
        
    }
}

#pragma mark - set方法
- (void)setWatchEndLiveModel:(WatchEndLiveModel *)watchEndLiveModel
{
    _watchEndLiveModel = watchEndLiveModel;
    
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    //头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:watchEndLiveModel.headImgUrl] placeholderImage:nil options:option];
    //名字
    _nameLabel.text = watchEndLiveModel.name.length > 0? watchEndLiveModel.name : @"未知";
    
    //性别
    _sexImageView.image = [watchEndLiveModel.sex isEqualToString:@"1"]? [UIImage imageNamed:@"btn_sex_fem"] : [UIImage imageNamed:@"btn_sex_mal"];
    
    //是否关注
    _friendship = watchEndLiveModel.isGuanzhu;
    if (watchEndLiveModel.isGuanzhu == YES) {
        [_guanzhuButton setTitle:@"已关注" forState:UIControlStateNormal];
        _guanzhuButton.backgroundColor = [UIColor lightGrayColor];
    }else{
        [_guanzhuButton setTitle:@"关注" forState:UIControlStateNormal];
        _guanzhuButton.backgroundColor = [UIColor ZYZC_MainColor];
        
    }
    
}
#pragma mark - 添加关注／取消关注
- (IBAction)guanzhuButtonAction:(UIButton *)sender {
    WEAKSELF
    NSDictionary *params=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":self.watchEndLiveModel.userId};
    //    NSLog(@"params:%@",params);
    if (_friendship) {
        NSString *unfollowUser = [[ZYZCAPIGenerate sharedInstance] API:@"friends_unfollowUser"];

        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:unfollowUser andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
             //            NSLog(@"%@",result);
             if (isSuccess) {
                 [MBProgressHUD showSuccess:@"取消成功"];
                 [weakSelf.guanzhuButton setTitle:@"关注" forState:UIControlStateNormal];
                 weakSelf.guanzhuButton.backgroundColor = [UIColor ZYZC_MainColor];
                 
                 weakSelf.friendship = !weakSelf.friendship;
             }
             else
             {
                 [MBProgressHUD showSuccess:@"取消失败"];
             }
         }
         andFailBlock:^(id failResult) {
             [MBProgressHUD showSuccess:@"取消失败"];
         }];
        
    }
    //添加关注
    else
    {
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"friends_followUser"];

        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
            //            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"关注成功"];
                [weakSelf.guanzhuButton setTitle:@"已关注" forState:UIControlStateNormal];
                weakSelf.guanzhuButton.backgroundColor = [UIColor lightGrayColor];
                weakSelf.friendship = !weakSelf.friendship;
            }
            else
            {
                [MBProgressHUD showSuccess:@"关注失败"];
            }
        } andFailBlock:^(id failResult) {
            [MBProgressHUD showSuccess:@"关注成功"];
        }];
    }
}

- (IBAction)backButtonAction:(UIButton *)sender {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
