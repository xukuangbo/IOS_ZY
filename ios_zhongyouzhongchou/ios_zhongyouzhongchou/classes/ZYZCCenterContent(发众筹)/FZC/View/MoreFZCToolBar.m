//
//  MoreFZCToolBar.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCToolBar.h"
#import "MoreFZCViewController.h"
@implementation MoreFZCToolBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor ZYZC_BgGrayColor];
        UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, self.width - KEDGE_DISTANCE * 2, self.height-KEDGE_DISTANCE)];
        bgImg.userInteractionEnabled=YES;
        bgImg.image=KPULLIMG(@"bg-_ss_gre", 10, 0, 0, 0);
        [self addSubview:bgImg];
        NSArray *titleArr=@[@"目的地",@"筹旅费",@"行程",@"回报"];
        for (int i=0; i<4; i++) {
            [bgImg addSubview:[self setButton:i withTitle:titleArr[i] withMoreFZCToolBarType:MoreFZCToolBarTypeGoal+i]];
        }
        
//        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArr];
//        segmentedControl = [[UISegmentedControl alloc]initWithItems:titleArr];
//        CGFloat segmentedControlX = 10;
//        CGFloat segmentedControlY = 5;
//        CGFloat segmentedControlW = self.width - segmentedControlX * 2;
//        CGFloat segmentedControlH = self.height - segmentedControlY * 2;
//        segmentedControl.frame = CGRectMake(segmentedControlX, segmentedControlY, segmentedControlW, segmentedControlH);
//        segmentedControl.tintColor=[UIColor whiteColor];
//        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName: [UIColor ZYZC_NavColor]};
//        [segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor whiteColor]};
//        [segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
//        segmentedControl.selectedSegmentIndex =0;
//        segmentedControl.backgroundColor=[UIColor ZYZC_NavColor];
//        segmentedControl.layer.cornerRadius=4;
//        segmentedControl.layer.masksToBounds=YES;
//        [segmentedControl addTarget:self action:@selector(changeSegmented:) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:segmentedControl];
//        self.segmentedControl = segmentedControl;
//        [self.segmentedControl setDividerImage:[UIImage imageNamed:@"bg_tt_sl"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        
    }
    return self;
}

/**
 *
 *  创建4个点击的按钮
 */
- (UIButton *)setButton:(NSInteger)index withTitle:(NSString *)titleName withMoreFZCToolBarType:(MoreFZCToolBarType)toolBarType
{
    CGFloat buttonY = 0;
    CGFloat buttonW = (self.width - KEDGE_DISTANCE * 2)/4;
    CGFloat buttonH = self.height-KEDGE_DISTANCE;
    CGFloat buttonX =index * buttonW;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:titleName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"bg-_ss_gre_u"] forState:UIControlStateSelected];
    button.tag = toolBarType;
    if (index==0) {
        _preClickBtn=button;
        button.selected=YES;
    }
    button.backgroundColor=[UIColor clearColor];
    
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/**
 *  button点击动作
 */
- (void)buttonClickAction:(UIButton *)button
{
    button.selected=YES;
    if (_preClickBtn!=button) {
        _preClickBtn.selected=NO;
    }
    _preClickBtn=button;
        //送到控制器去执行切换tableView视图效果
    if ([self.delegate respondsToSelector:@selector(toolBarWithButton:)]) {
        [self.delegate toolBarWithButton:button.tag];
    }
    
    MoreFZCViewController *vc=(MoreFZCViewController *)self.viewController;
     UIButton *nextBtn=(UIButton *)[vc.bottomView viewWithTag:NextType];
    if (button.tag<MoreFZCToolBarTypeReturn) {
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        nextBtn.backgroundColor=[UIColor clearColor];
    }
    else
    {
        [nextBtn setTitle:@"发    布" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextBtn.backgroundColor=[UIColor ZYZC_MainColor];
    }
}


/**
 *  button点几的时候
 */
- (void)changeSegmented:(UISegmentedControl *)segmentedControl
{
    
    //送到控制器去执行切换tableView视图效果
    if ([self.delegate respondsToSelector:@selector(toolBarWithButton:)]) {
        [self.delegate toolBarWithButton:segmentedControl.selectedSegmentIndex + 33];
    }
//    switch (segmentedControl.selectedSegmentIndex) {
//        case 0:
//            NSLog(@"目的地");
//            break;
//        case 1:
//             NSLog(@"抽旅费");
//            break;
//        case 2:
//             NSLog(@"行程");
//            break;
//        case 3:
//             NSLog(@"回报");
//            break;
//            
//            
//        default:
//            break;
//    }
}
@end
