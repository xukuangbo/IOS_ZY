//
//  AboutZhongyouVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AboutZhongyouVC.h"
#import "AboutXieyiVC.h"
#import "AboutJianyiVC.h"
#import "AboutUsVC.h"
@interface AboutZhongyouVC ()
@property (nonatomic, strong) UIImageView *bgView;


@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation AboutZhongyouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)configUI
{
    [self setBackItem];
    self.title = @"关于我们";
    
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    //图标
    CGFloat logoImageViewH = 70;
    CGFloat logoImageViewW = logoImageViewH * (8 / 5.0);
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.size = CGSizeMake(logoImageViewW, logoImageViewH);
    logoImageView.image = [UIImage imageNamed:@"about_us"];
    logoImageView.centerX = self.view.centerX;
    logoImageView.top = 100;
    [self.view addSubview:logoImageView];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.size = CGSizeMake(KSCREEN_W, 20);
    _titleLabel.centerX = self.view.centerX;
    _titleLabel.top = logoImageView.bottom + KEDGE_DISTANCE;
    _titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.text = @"众游";
    [self.view addSubview:_titleLabel];
    
    
    [self createSelectUI];
    
    [self createBottomLabel];
}

- (void)createSelectUI
{
    //背景白图
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = 0;
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    //众游服务使用协议
    UIButton *xieyiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xieyiButton addTarget:self action:@selector(xieyiButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self createUIWithSuperView:_bgView actionView:xieyiButton index:1 title:@"众筹服务使用协议"];
    //灰色线
    [_bgView addSubview:[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, xieyiButton.bottom + KTextMargin, (bgImageViewW - 2 * KEDGE_DISTANCE), 1) andColor:nil]];
    //意见建议
    UIButton *jianyiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jianyiButton addTarget:self action:@selector(jianyiButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self createUIWithSuperView:_bgView actionView:jianyiButton index:2 title:@"意见建议"];
    //灰色线
    [_bgView addSubview:[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, jianyiButton.bottom + KTextMargin, (bgImageViewW - 2 * KEDGE_DISTANCE), 1) andColor:nil]];
    //关于我们
    UIButton *aboutUSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutUSButton addTarget:self action:@selector(aboutUSButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self createUIWithSuperView:_bgView actionView:aboutUSButton index:3 title:@"关于我们"];
    
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    _bgView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    int rowNumber = 3;
    _bgView.height = (selectUIRowHeight * rowNumber + KEDGE_DISTANCE * 2 + KEDGE_DISTANCE * (rowNumber - 1));
    
    _bgView.top = _titleLabel.bottom + 50;
}

- (void)createBottomLabel
{
    //公司名
    UILabel *companyNameLabel = [[UILabel alloc] init];
    companyNameLabel.size = CGSizeMake(KSCREEN_W, 16);
    companyNameLabel.bottom = KSCREEN_H - KEDGE_DISTANCE;
    companyNameLabel.centerX = self.view.centerX;
    companyNameLabel.textColor = [UIColor ZYZC_TextGrayColor];
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.font = [UIFont systemFontOfSize:15];
    companyNameLabel.text = @"杭州众游科技有限公司";
    [self.view addSubview:companyNameLabel];
    
    //公司时间
    UILabel *companyTimeLabel = [[UILabel alloc] init];
    companyTimeLabel.size = CGSizeMake(KSCREEN_W, 16);
    companyTimeLabel.bottom = companyNameLabel.top - KTextMargin;
    companyTimeLabel.centerX = self.view.centerX;
    companyTimeLabel.textColor = [UIColor ZYZC_TextGrayColor];
    companyTimeLabel.textAlignment = NSTextAlignmentCenter;
    companyTimeLabel.font = [UIFont systemFontOfSize:15];
    companyTimeLabel.text = @"Copyright © 2015-2016";
    [self.view addSubview:companyTimeLabel];
}

- (void)createUIWithSuperView:(UIView *)superView actionView:(UIButton *)actionButton index:(NSInteger )index title:(NSString *)title
{
    CGFloat titleViewX = KEDGE_DISTANCE;
    CGFloat titleViewY = (selectUIRowHeight + KEDGE_DISTANCE) * (index - 1) + KEDGE_DISTANCE;
    CGFloat titleViewW = superView.width - titleViewX * 2;
    CGFloat titleViewH = selectUIRowHeight;
//    actionButton.backgroundColor = [UIColor redColor];
    actionButton.frame = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    [superView addSubview:actionButton];
    
    //添加右边的箭头
    CGFloat jiantouImageViewW = 10;
    CGFloat jiantouImageViewH = jiantouImageViewW / 9.0 * 16;
    UIImageView *jiantouImageView = [[UIImageView alloc] init];
    jiantouImageView.size = CGSizeMake(jiantouImageViewW, jiantouImageViewH);
    jiantouImageView.image=[UIImage imageNamed:@"btn_rightin"];
    jiantouImageView.right = actionButton.width;
    jiantouImageView.centerY = actionButton.height * 0.5;
    [actionButton addSubview:jiantouImageView];
    
    //添加文字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.size = CGSizeMake(superView.width - KEDGE_DISTANCE * 2 - jiantouImageView.width, titleViewH);
    titleLabel.left = 0;
    titleLabel.top = 0;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor ZYZC_TextGrayColor];
    [actionButton addSubview:titleLabel];
    
    
}

#pragma mark ---使用协议点击
- (void)xieyiButtonAction
{
    AboutXieyiVC *xieyiVc = [[AboutXieyiVC alloc] init];
    
    [self.navigationController pushViewController:xieyiVc animated:YES];
}
#pragma mark ---意见建议点击
- (void)jianyiButtonAction
{
    AboutJianyiVC *jianyiVc = [[AboutJianyiVC alloc] init];
    
    [self.navigationController pushViewController:jianyiVc animated:YES];
}
#pragma mark ---关于我们点击
- (void)aboutUSButtonAction
{
    AboutUsVC *aboutUsVc = [[AboutUsVC alloc] init];
    
    [self.navigationController pushViewController:aboutUsVc animated:YES];
}


@end
