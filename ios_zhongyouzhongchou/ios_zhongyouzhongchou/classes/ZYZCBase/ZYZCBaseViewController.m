//
//  ZYZCBaseViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
@interface ZYZCBaseViewController ()

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

-(void)customNavWithLeftBtnImgName:(NSString *)leftName andRightImgName:(NSString *)rightName andLeftAction:(SEL)leftAction andRightAction:(SEL)rightAction
{
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:leftName andAction:leftAction];
   
    self.navigationItem.rightBarButtonItem=[self customItemByImgName:rightName andAction:rightAction];
}


-(UIBarButtonItem *)customItemByImgName:(NSString *)imgName andAction:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:action];
}

-(void)pressBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
