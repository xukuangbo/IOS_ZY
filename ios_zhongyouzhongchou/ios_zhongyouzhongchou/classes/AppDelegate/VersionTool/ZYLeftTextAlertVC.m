//
//  ZYLeftTextAlertVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLeftTextAlertVC.h"

@interface ZYLeftTextAlertVC ()

@end

@implementation ZYLeftTextAlertVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:self.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[1];
        messageLb.textAlignment = NSTextAlignmentLeft;
    }
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
- (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            
            DDLog(@"%@",NSStringFromCGRect(subView.frame));
            return view;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}
@end
