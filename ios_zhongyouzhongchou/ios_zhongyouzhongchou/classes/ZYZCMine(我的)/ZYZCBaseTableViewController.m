//
//  ZYZCBaseTableViewController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableViewController.h"
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]

@interface ZYZCBaseTableViewController ()
@end

@implementation ZYZCBaseTableViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor ZYZC_BgGrayColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)setNavi
{
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    
}

- (void)setClearNavi
{
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(0)];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
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

#pragma mark - set方法
- (NSString *)titleName
{
    if (!_titleName) {
        _titleName = @"";
    }
    return _titleName;
}
- (CGFloat)imageViewHeight
{
    if (!_imageViewHeight) {
        _imageViewHeight = KSCREEN_W / 16 * 9;
    }
    return _imageViewHeight;
}

- (void)changeNaviColorWithScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= self.imageViewHeight) {
        CGFloat alpha = MAX(0, offsetY/self.imageViewHeight);
        
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(alpha)];
        self.title = @"";
    } else {
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
        self.title = self.titleName;
        
    }
}
@end
