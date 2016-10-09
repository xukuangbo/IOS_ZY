//
//  ViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ViewController.h"
#import "ZYDetailUserInfoView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    self.view.backgroundColor=[UIColor whiteColor];
    ZYDetailUserInfoView *infoView= [[[NSBundle mainBundle] loadNibNamed:@"ZYDetailUserInfoView" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(210);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
