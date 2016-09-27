//
//  MinePersonSetUpController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MinePersonSetUpController.h"
#import "MinePersonSetUpHeadView.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "FXBlurView.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "MinePersonSetUpModel.h"
#import "MinePersonAddressModel.h"
#import "NetWorkManager.h"
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]

@interface MinePersonSetUpController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UITextField *editingTextField;
@end

@implementation MinePersonSetUpController
#pragma mark - 系统方法
- (void)loadView
{
    [super loadView];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面出现的时候需要去加载数据
    [self requestData];
    [self setBackItem];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(0)];

    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    
    self.hidesBottomBarWhenPushed = YES;

}
#pragma mark - 请求网络
- (void)requestData
{
    //能进这里肯定是存在账号的
    NSString *userId = [ZYZCAccountTool getUserId];
    
    NSString *getUserInfoURL  = Get_SelfInfo(userId, userId);
    __weak typeof(&*self) weakSelf = self;
//    NSLog(@"%@",getUserInfoURL);
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool getHttpDataByURL:getUserInfoURL withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        [weakSelf reloadUIData:result];
        
        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
//        NSLog(@"请求个人信息错误，errror：%@",failResult);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
    }];
}

- (void)createUI
{
    MinePersonSetUpScrollView *scrollView = [[MinePersonSetUpScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.wantFZC = _wantFZC;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

/**
 *  更新数据信息
 */
- (void)reloadUIData:(id)result
{
    NSDictionary *dic = (NSDictionary *)result;
    NSDictionary *data = dic[@"data"];
    
    MinePersonSetUpModel *model = [MinePersonSetUpModel mj_objectWithKeyValues:data[@"user"]];
    
    self.scrollView.minePersonSetUpModel = model;
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //make keyboard down
    if (scrollView.isTracking) {
        [scrollView endEditing:YES];
    }
    
    [self changeNaviColorWithScroll:scrollView];
}

- (void)changeNaviColorWithScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (offsetY <= imageHeadHeight) {
        CGFloat alpha = MAX(0, offsetY/imageHeadHeight);
        
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(alpha)];
        self.title = @"";
    } else {
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
        self.title = @"个人设置";
        
    }
}

#pragma mark - textfildNoti
- (void)keyboardWillShow:(NSNotification *)noti {
    // 拿到正在编辑中的textfield
    [self getIsEditingView:self.scrollView];
    // textfield在window中的位置
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGFloat viewY = [_editingTextField convertRect:_editingTextField.bounds toView:window].origin.y + _editingTextField.size.height;
    // 键盘的Y值
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardEndY = value.CGRectValue.origin.y;
    if (keyboardEndY < viewY) {
        // 动画
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.doubleValue animations:^{
            if (viewY > keyboardEndY) {
                CGRect rect = self.scrollView.frame;
                rect.origin.y += keyboardEndY - (viewY);
                self.scrollView.frame = rect;
            }
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)noti {
    CGRect rect = self.scrollView.frame;
    rect.origin.y = 0;
    self.scrollView.frame = rect;
}
/**
 *  获取正在编辑中的textfield
 */
- (void)getIsEditingView:(UIView *)rootView {
    for (UIView *subView in rootView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            if (((UITextField *)subView).isEditing) {
                self.editingTextField = (UITextField *)subView;
                return;
            }
        }
        [self getIsEditingView:subView];
    }
}

@end
