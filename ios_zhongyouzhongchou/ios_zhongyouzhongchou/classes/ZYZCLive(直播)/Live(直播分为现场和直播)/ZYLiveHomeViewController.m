//
//  ZYLiveHomeViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveHomeViewController.h"

#import <GRKPageViewController.h>
#import "ZYSceneViewController.h"
#import "ZYLiveListController.h"
#import "ZYFaqiLiveViewController.h"
@interface ZYLiveHomeViewController () <GRKPageViewControllerDataSource, GRKPageViewControllerDelegate>
@property (strong, nonatomic) GRKPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (strong, nonatomic) UISegmentedControl *segmentControl;

@end

@implementation ZYLiveHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationView];
    [self setupData];
    [self setupView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    [self setRightBarButtonItem:rightItem];
}
#pragma mark - setup
- (void)setupData
{
    self.viewControllers = [NSMutableArray array];
    ZYSceneViewController *sceneVC = [[ZYSceneViewController alloc] init];
    ZYLiveListController *liveListVC = [[ZYLiveListController alloc] init];
    [self.viewControllers addObject:sceneVC];
    [self.viewControllers addObject:liveListVC];
}

- (void)setupView
{
    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame=CGRectMake(KSCREEN_W - 40, 10, 60, 30);
    [navRightBtn setTitle:@"发起" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn=navRightBtn;

    GRKPageViewController *pageViewController = [[GRKPageViewController alloc] init];
    pageViewController.view.backgroundColor = [UIColor whiteColor];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
//    pageViewController.scrollEnabled = NO;
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    [pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.pageViewController = pageViewController;
}

- (void)customNavigationView
{
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"现场",@"直播"]];

    segmentControl.frame = CGRectMake(110, 7, 158, 30);
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5;
    segmentControl.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor whiteColor].CGColor;
    [segmentControl.layer setBorderColor:cgColor];
    segmentControl.tintColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:15.0f],nil];
    [segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
//    NSDictionary *selecteddic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Light" size:14], [UIColor whiteColor],nil];
//
//    [segmentControl setTitleTextAttributes:selecteddic forState:UIControlStateSelected];
    
    [segmentControl addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl = segmentControl;
    self.navigationItem.titleView = self.segmentControl;
    
}

#pragma mark - event
- (void)rightBtnAction
{
    ZYFaqiLiveViewController *liveController=[[ZYFaqiLiveViewController alloc]init];
    liveController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:liveController animated:YES];
}

- (void)segmentChangedValue:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            //  NSLog(@"现场");
            
        }
            break;
        case 1:
        {
            //  NSLog(@"直播");
        }
        default:
            break;
    }
    
    [self.pageViewController setCurrentIndex:sender.selectedSegmentIndex];
}

#pragma mark - GRKPageViewControllerDataSource

- (NSUInteger)pageCountForPageViewController:(GRKPageViewController *)controller {
    return self.viewControllers.count;
}
- (UIViewController *)viewControllerForIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller {
    UIViewController *viewController = nil;
    
    if (index < self.viewControllers.count) {
        viewController = self.viewControllers[index];
    }
    
    if (!viewController) {
        viewController = [[ZYZCBaseViewController alloc] init];
    }
    
    return viewController;
}

#pragma mark - GRKPageViewControllerDelegate

- (void)changedIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller {
    
    [self.segmentControl setSelectedSegmentIndex:index];
}

- (void)changedIndexOffset:(CGFloat)indexOffset forPageViewController:(GRKPageViewController *)controller {
    
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
