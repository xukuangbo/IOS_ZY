//
//  FZCBaseViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "FZCBaseViewController.h"

@interface FZCBaseViewController ()

@end

@implementation FZCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackItem];
}
-(void)createBottomView
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, KSCREEN_H-KTABBAR_HEIGHT , KSCREEN_W, KTABBAR_HEIGHT)];
    bottomView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:bottomView];
    
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KSCREEN_W/2-50, KTABBAR_HEIGHT/2-20, 100, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    _sureBtn=sureBtn;
    
    [bottomView addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]]];
}

-(void)clickBtn
{
    
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
