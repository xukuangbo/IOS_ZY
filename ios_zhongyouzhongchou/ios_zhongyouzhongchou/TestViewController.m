//
//  TestViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TestViewController.h"
#import "MLPlayVoiceButton.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet MLPlayVoiceButton *playerBtn;
@property (weak, nonatomic) IBOutlet MLPlayVoiceButton *playerBtn01;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.playerBtn downVoiceWithUrl:[NSURL URLWithString:@"http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/99/20160912212141/travel01.amr"] withComplete:nil];
//    self.playerBtn.hiddenAnimation=YES;
    
    [self.playerBtn01 downVoiceWithUrl:[NSURL URLWithString:@"http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/5168/20160912211352/travel01.amr"]withComplete:nil];
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
