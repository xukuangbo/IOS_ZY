//
//  ZYZCBaseViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "MBProgressHUD.h"
@interface ZYZCBaseViewController ()
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation ZYZCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor whiteColor],
    NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
}

-(void)setBackItem
{
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:@"btn_back_new" andAction:@selector(pressBack)];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarItem {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarItem];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarItem {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
}


-(void)customNavWithLeftBtnImgName:(NSString *)leftName andRightImgName:(NSString *)rightName andLeftAction:(SEL)leftAction andRightAction:(SEL)rightAction
{
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:leftName andAction:leftAction];
   
    self.navigationItem.rightBarButtonItem=[self customItemByImgName:rightName andAction:rightAction];
}

-(void)customNavWithLeftBtnTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle  andTarget:(id)target andFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andLeftAction:(SEL)leftAction andRightAction:(SEL)rightAction
{
    
    CGFloat leftWidth=[ZYZCTool calculateStrLengthByText:leftTitle andFont:font andMaxWidth:KSCREEN_W].width+20;
    CGFloat rightWidth=[ZYZCTool calculateStrLengthByText:rightTitle andFont:font andMaxWidth:KSCREEN_W].width+20;
    
    UIButton *leftBtn=[ZYZCTool createBtnWithFrame:CGRectMake(0, 0, leftWidth, 44) andNormalTitle:leftTitle andNormalTitleColor:titleColor andTarget:target andAction:leftAction];
    leftBtn.titleLabel.font=font;
    
    UIButton *rightBtn=[ZYZCTool createBtnWithFrame:CGRectMake(0, 0, rightWidth, 44) andNormalTitle:rightTitle andNormalTitleColor:titleColor andTarget:target andAction:rightAction];
    rightBtn.titleLabel.font=font;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}


-(UIBarButtonItem *)customItemByImgName:(NSString *)imgName andAction:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:action];
}


- (void)setClearNavigationBar:(BOOL)isClear {
    if (isClear) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                      forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationController.navigationBar.hidden = YES;
//        self.navigationController.navigationBar.clipsToBounds = YES;
    } else {
        //复原
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.hidden = NO;
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor ZYZC_MainColor]]];
//        self.navigationController.navigationBar.clipsToBounds = NO;
    }
}

- (void)showHintWithText:(NSString *)text {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hub.mode = MBProgressHUDModeText;
    //    hub.labelText = text;
    hub.detailsLabelText = text;
    hub.detailsLabelFont = [UIFont systemFontOfSize:14.0];
    hub.removeFromSuperViewOnHide = YES;
    [hub show:YES];
    [hub hide:YES afterDelay:2];
    if (self.hud) {
        [self.hud hide:YES];
    }
}

#pragma mark - event 事件处理
-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
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
