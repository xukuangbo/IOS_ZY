//
//  SelectImageViewController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "SelectImageViewController.h"
#import "UINavigationBar+Background.h"
#import "FXBlurView.h"

//#define selectImagescrollViewH (KSCREEN_W / 16.0 * 10)
#define selectImageTabbarH 88

@interface SelectImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isVertical;
@property (nonatomic, assign) CGFloat scale;
@end

@implementation SelectImageViewController
#pragma mark - 系统方法
- (instancetype)initWithImage:(UIImage *)image WHScale:(CGFloat)WHScale
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.WHScale = WHScale;
        [self setBackItem];
//        self.title = @"编辑封面图片";
        _selectImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //系统的一些基本设置
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor blackColor]];
    
    /**
     *  创建scroll
     */
    [self createScrollView];
    
    /**
     *  创建6个角的小图标
     */
    [self createAngle];
}
/**
 *  创建scrollView,滑动的
 */
- (void)createScrollView
{
    //1.0先创建中间的透明图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.size = CGSizeMake(KSCREEN_W,KSCREEN_W / self.WHScale);
    scrollView.center = self.view.center;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    //让图片偏移到顶部去
    scrollView.contentOffset = CGPointMake(0, 0);
    
    //让scrollview没有覆盖的地方显示图片
    scrollView.clipsToBounds = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //创建imageView,这个imageView得放在srollview里面
    //做一个判断，判断是横条的view，还是竖条的view
    CGFloat imageViewH;
    CGFloat imageViewW;
    UIImageView *imageView = [[UIImageView alloc] init];
    if (_selectImage.size.width > _selectImage.size.height * self.WHScale) {
        //倍数
        _scale = _selectImage.size.height / (KSCREEN_W / self.WHScale);
        _isVertical = NO;
        //高度
        imageViewH = (KSCREEN_W / self.WHScale);
        //宽度
        imageViewW = _selectImage.size.width / _scale;
        
        imageView.frame = CGRectMake(0, 0, imageViewW, imageViewH);
        
        
        scrollView.contentSize = CGSizeMake(imageViewW, imageViewH);
    }else{
        //倍数
        _scale = _selectImage.size.width / KSCREEN_W;
        _isVertical = YES;
        //高度
        imageViewH = _selectImage.size.height / _scale;
        //宽度
        imageViewW = KSCREEN_W;
        
        imageView.frame = CGRectMake(0, 0, imageViewW, imageViewH);
        
        scrollView.contentSize = CGSizeMake(imageViewW, imageViewH);
    }
    
    imageView.image=_selectImage;
    //    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
}

/**
 *  创建小图标以及阴影
 */
- (void)createAngle
{
    
    UIView *clearView = [[UIView alloc] initWithFrame:self.scrollView.frame];
    clearView.backgroundColor =[UIColor clearColor];
    clearView.userInteractionEnabled = NO;
    [self.view addSubview:clearView];
    
    //1.1创建6个小图标view
    UIImageView *luView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_lu"]];
    luView.left = 0;
    luView.top = 0;
    [clearView addSubview:luView];
    
    
    
    UIImageView *ldView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_ld"]];
    ldView.left = 0;
    ldView.top = self.scrollView.height - ldView.height;
    [clearView addSubview:ldView];
    
    UIImageView *con_midTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con_mid"]];
    con_midTopView.centerX = self.scrollView.centerX;
    con_midTopView.top = 0;
    [clearView addSubview:con_midTopView];
    
    
    UIImageView *con_midBottonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con_mid"]];
    con_midBottonView.centerX = self.scrollView.centerX;
    con_midBottonView.bottom = self.scrollView.height;
    [clearView addSubview:con_midBottonView];
    
    UIImageView *ruView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_ru"]];
    ruView.right = self.scrollView.width;
    ruView.top = 0;
    [clearView addSubview:ruView];
    
    UIImageView *rdView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_rd"]];
    rdView.right = self.scrollView.width;
    rdView.bottom = self.scrollView.height;
    [clearView addSubview:rdView];
    
    //2.0创建顶部阴影图
    CGFloat topBlurViewH = self.scrollView.top - 64;
    UIView *topBlurView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_W,topBlurViewH)];
    topBlurView.backgroundColor = [UIColor blackColor];
    topBlurView.alpha = 0.7;
    [self.view addSubview:topBlurView];
    
    //4.0创建底部tabbar
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREEN_H-KTABBAR_HEIGHT, KSCREEN_W,KTABBAR_HEIGHT)];
    tabbarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabbarView];
    
    
    //3.0创建底部阴影图
    CGFloat bottomBlurViewY = self.scrollView.bottom;
    CGFloat bottomBlurViewH = tabbarView.top-self.scrollView.bottom;
    UIView *bottomBlurView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomBlurViewY, KSCREEN_W,bottomBlurViewH)];
    bottomBlurView.alpha = 0.7;
    bottomBlurView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomBlurView];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yesButton.frame=CGRectMake(tabbarView.frame.size.width/2-50, tabbarView.frame.size.height/2-20, 100, 40);
    //    yesButton.size = CGSizeMake(100, 40);
    yesButton.backgroundColor = [UIColor ZYZC_MainColor];
    [yesButton setTitle:@"确定" forState:UIControlStateNormal];
    yesButton.titleLabel.font = [UIFont systemFontOfSize:20];
    //    yesButton.centerX = KSCREEN_W * 0.5;
    //    yesButton.centerY = tabbarView.height * 0.5;
    
    yesButton.center= CGPointMake(KSCREEN_W * 0.5, tabbarView.height * 0.5);
    yesButton.layer.cornerRadius = 5;
    yesButton.layer.masksToBounds = YES;
    [yesButton addTarget:self action:@selector(yesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:yesButton];
    tabbarView.userInteractionEnabled=YES;
    
}

/**
 *  确定按钮的点击事件
 */
- (void)yesButtonAction:(UIButton *)button
{
    //这里拿到新的图片
    
    UIImage *srcimg = _selectImage;
    
    //考虑到手势放大后的宽度会变，所以先用一个临时的值来存取这个宽度
    
    //    NSLog(@"%@",NSStringFromCGPoint(self.scrollView.contentOffset));
    
    UIImageView *newImgview = [[UIImageView alloc] initWithImage:srcimg];
    
    //    NSInteger scale = [ZYZCTool deviceVersion];
    CGRect rect;
    if (_isVertical == YES) {
        rect.origin.x = 0;
        rect.origin.y = (self.scrollView.contentOffset.y ) * _scale;
        rect.size.width = _selectImage.size.width;
        rect.size.height = _selectImage.size.width / self.WHScale;
    }else{
        rect.origin.x = (self.scrollView.contentOffset.x) * _scale;
        rect.origin.y = 0;
        rect.size.width = _selectImage.size.height * self.WHScale;
        rect.size.height = _selectImage.size.height;
    }
    //    rect.origin.x = (self.scrollView.contentOffset.x) * (srcimg.size.width / KSCREEN_W);
    //    rect.origin.y = (self.scrollView.contentOffset.y ) * (srcimg.size.height / KSCREEN_H);
    //    rect.size.width = _selectImage.size.width;
    //    rect.size.height = _selectImage.size.width * 9 / 16.0;
    //    rect.size.width = self.scrollView.bounds.size.width * (srcimg.size.width / KSCREEN_W);
    //    rect.size.height = self.scrollView.bounds.size.height * (srcimg.size.height / KSCREEN_H);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
    
    //    NSLog(@"%@-----%f",NSStringFromCGRect(rect),zoomScale);
    
    CGImageRef cgimg = CGImageCreateWithImageInRect(_selectImage.CGImage, rect);
    newImgview.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    
    //获得了图片之后，传回首页的控制器
    if (self.imageBlock) {
        self.imageBlock(newImgview.image);
        //让自己的视图消失
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
/**
 *  返回需要滚动的view
 */
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    return  nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"编辑封面图片";
    [self setBackItem];
}

@end
