//
//  ZYShortVideoPublish.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define img_height        150
#define page_text(page)  [NSString stringWithFormat:@"封面%ld",page]
#import "ZYShortVideoPublish.h"
#import "VideoService.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
@interface ZYShortVideoPublish ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UIButton         *publishBtn;
@property (nonatomic, strong) UILabel          *pageLab;
@property (nonatomic, strong) NSMutableArray   *imageArray;
/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@end

@implementation ZYShortVideoPublish

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getImageData];
    [self configBodyUI];
    [self configNavUI];
}



-(void )getImageData
{
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL exist=[manager fileExistsAtPath:self.videoPath];
    if(exist)
    {
        NSArray *images=[VideoService thumbnailImagesForVideo:[NSURL fileURLWithPath:self.videoPath] withImageCount:20];
        self.imageArray=[NSMutableArray arrayWithArray:images];
    }
}

-(void)configNavUI
{
    //navUI
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    navView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:navView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleLab.text=@"添加足迹";
    titleLab.textColor=[UIColor ZYZC_TextBlackColor];
    titleLab.font=[UIFont systemFontOfSize:20];
    titleLab.centerX=navView.centerX;
    [navView addSubview:titleLab];
    
    //退出按钮
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 20, 50, 44);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [backBtn  addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //发布按钮
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(KSCREEN_W-60, 20, 50, 44);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(publishMyFootprint) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:publishBtn];
    _publishBtn=publishBtn;
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, navView.height-0.5, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]];
    [navView addSubview:lineView];
}

- (void)configBodyUI {
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 64+10, KSCREEN_W, img_height)];
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.5;
    pageFlowView.minimumPageScale = 0.85;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    //提前告诉有多少页
    pageFlowView.orginPageCount = self.imageArray.count;
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [bottomScrollView addSubview:pageFlowView];
    [pageFlowView reloadData];
    
    [self.view addSubview:bottomScrollView];
    
    _pageLab=[ZYZCTool createLabWithFrame:CGRectMake(0, pageFlowView.bottom+5, self.view.width, 20) andFont:[UIFont systemFontOfSize:15.f] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _pageLab.textAlignment=NSTextAlignmentCenter;
    _pageLab.text=page_text((NSInteger)1);
    [self.view addSubview:_pageLab];
    

}


#pragma mark --- 返回操作
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ---  发布足迹👣
-(void)publishMyFootprint
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(img_height*_img_rate, img_height);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, img_height*_img_rate, img_height)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    DDLog(@"移动到第%ld张",pageNumber);
    _pageLab.text=page_text(pageNumber+1);
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
