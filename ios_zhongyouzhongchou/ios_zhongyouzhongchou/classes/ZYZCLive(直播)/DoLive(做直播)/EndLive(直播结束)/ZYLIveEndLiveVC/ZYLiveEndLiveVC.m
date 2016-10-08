//
//  ZYLiveEndLiveVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/9/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveEndLiveVC.h"
#import "UIView+ZYLayer.h"
#import "ZYLiveEndModel.h"
#import "MBProgressHUD+MJ.h"
@interface ZYLiveEndLiveVC ()
/** 背景 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
/** 模糊效果 */
@property (nonatomic, strong) UIVisualEffectView *backView;
/** 总时长 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 总金额 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
/** 累计总人数 */
@property (weak, nonatomic) IBOutlet UILabel *totalPeopleCount;
/** 同时在线总人数 */
@property (weak, nonatomic) IBOutlet UILabel *totalOnlinePeopleCount;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/** 删除按钮 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)backAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@end

@implementation ZYLiveEndLiveVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backButton.layerCornerRadius = 5;
    _deleteButton.layerCornerRadius = 5;
    //添加模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _backView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _backView.frame = [UIScreen mainScreen].bounds;
    [_bgImageView addSubview:_backView];
    _backView.alpha = 0.6;
    
    
    self.totalMoneyLabel.text = self.liveEndLiveModel.totalMoneyCount;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"本次直播时长:%@",self.liveEndLiveModel.endTime];
    self.totalPeopleCount.text = [NSString stringWithFormat:@"%zd",self.liveEndLiveModel.totalPeopleCount];
    self.totalOnlinePeopleCount.text = [NSString stringWithFormat:@"%zd",self.liveEndLiveModel.totalOnlinePeopleNumber];
    
}

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

- (void)dealloc
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setLiveEndLiveModel:(ZYLiveEndModel *)liveEndLiveModel
{
    _liveEndLiveModel = liveEndLiveModel;
    _totalMoneyLabel.text = liveEndLiveModel.totalMoneyCount;
    _totalTimeLabel.text = liveEndLiveModel.endTime;
    _totalPeopleCount.text = [NSString stringWithFormat:@"%zd",liveEndLiveModel.totalPeopleCount];
    _totalOnlinePeopleCount.text = [NSString stringWithFormat:@"%zd",liveEndLiveModel.totalOnlinePeopleNumber];
}


- (IBAction)backAction:(id)sender {
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)deleteAction:(id)sender {
    
    //删除视频
    NSDictionary *parameters = @{
                                 @"spaceName" : self.liveEndLiveModel.spaceName,
                                 @"streamName" : self.liveEndLiveModel.streamName
                                 };
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Post_Del_Live andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        
        [MBProgressHUD showSuccess:@"删除成功"];
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showError:@"删除失败"];
        DDLog(@"%@",failResult);
    }];
}
@end
