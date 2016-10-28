//
//  TacticSingleFoodVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticSingleFoodVC.h"
#import "TacticSingleFoodModel.h"
#import "TacticVideoModel.h"
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]

#define imageViewHeight (KSCREEN_W / 8.0 * 5)

#define labelViewFont [UIFont systemFontOfSize:16]

@interface TacticSingleFoodVC ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIImageView *mapView;
@property (nonatomic, weak) UILabel *labelView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

static NSString *textCellID = @"TacticFoodTextCell";
static NSString *picCellID = @"TacticFoodPicCell";

@implementation TacticSingleFoodVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
        [self setBackItem];
        self.hidesBottomBarWhenPushed = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(0)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

/**
 *  创建界面
 */
- (void)setUpUI
{
    /**
     *  创建Scrollview
     */
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    /**
     *  创建图片
     */
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    CGFloat imageViewW = KSCREEN_W;
    CGFloat imageViewH = imageViewHeight;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    [scrollView addSubview:imageView];
    imageView.backgroundColor = [UIColor redColor];
    self.imageView = imageView;
    
    //添加渐变条
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    bgImg.image=[UIImage imageNamed:@"Background"];
    [imageView addSubview:bgImg];
    /**
     图片上的文字
     */
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageViewW, 60)];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.font = [UIFont boldSystemFontOfSize:33];
    namelabel.shadowOffset=CGSizeMake(1, 1);
    namelabel.textColor = [UIColor whiteColor];
    namelabel.centerX = KSCREEN_W * 0.5;
    namelabel.centerY = imageViewH * 0.5;
    namelabel.shadowOffset=CGSizeMake(1, 1);
    namelabel.shadowColor=[UIColor blackColor];
    [imageView addSubview:namelabel];
    self.nameLabel = namelabel;
    
    /**
     创建白色背景
     */
    UIImageView *mapView = [[UIImageView alloc] init];
    mapView.userInteractionEnabled = YES;
    [self.scrollView addSubview:mapView];
    self.mapView = mapView;
    /**
     *  创建文字
     */
    UILabel *labelView = [[UILabel alloc] init];
    labelView.layer.cornerRadius = 5;
    labelView.layer.masksToBounds = YES;
    labelView.font = [UIFont systemFontOfSize:16];
    labelView.textColor = [UIColor ZYZC_TextGrayColor];
    labelView.numberOfLines = 0;
    [mapView addSubview:labelView];
    self.labelView = labelView;
    
    //创造3个imageView的数组
    self.imageArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.imageArray addObject:imageView];
    }
}


- (void)setTacticSingleFoodModel:(TacticSingleFoodModel *)tacticSingleFoodModel
{
    _tacticSingleFoodModel = tacticSingleFoodModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    //肯定有图片
    CGFloat mapViewX = KEDGE_DISTANCE;
    CGFloat mapViewY = imageViewHeight + KEDGE_DISTANCE;
    CGFloat mapViewW = KSCREEN_W - mapViewX * 2;
    //先计算文字高度
    CGFloat labelViewX = KEDGE_DISTANCE;
    CGFloat labelViewY = KEDGE_DISTANCE;
    CGFloat labelViewW = mapViewW - KEDGE_DISTANCE * 2;
    CGFloat labelViewH = 0;
    CGSize textSize = [ZYZCTool calculateStrLengthByText:tacticSingleFoodModel.foodText andFont:labelViewFont andMaxWidth:labelViewW];
    labelViewH = textSize.height;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleFoodModel.foodImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    self.nameLabel.text = tacticSingleFoodModel.name;
    
    self.labelView.text = tacticSingleFoodModel.foodText;
    self.labelView.frame = CGRectMake(labelViewX, labelViewY, labelViewW, labelViewH);
    
    CGFloat mapViewH = labelViewH + KEDGE_DISTANCE * 2;
    if (tacticSingleFoodModel.pics) {
        
        CGFloat imageX = KEDGE_DISTANCE;
        CGFloat imageW = mapViewW - imageX * 2;
        CGFloat imageH = imageW / 16 * 9;
        NSArray *detailImageArray = tacticSingleFoodModel.pics;
        for (int i = 0; i < detailImageArray.count; i++) {
            CGFloat imageY = CGRectGetMaxY(self.labelView.frame) + i * (imageH + KEDGE_DISTANCE) + KEDGE_DISTANCE;
            UIImageView *imageView = self.imageArray[i];
            [self.mapView addSubview:imageView];
            imageView.backgroundColor = [UIColor redColor];
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [imageView sd_setImageWithURL:[NSURL URLWithString:KWebImage(detailImageArray[i])] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
        }
        mapViewH = mapViewH + detailImageArray.count * (imageH + KEDGE_DISTANCE);
    }
    
    self.mapView.frame = CGRectMake(mapViewX, mapViewY, mapViewW, mapViewH);
    self.mapView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.mapView.height + KEDGE_DISTANCE * 2 + imageViewHeight);
}


#pragma mark - UISrollViewDelegate
/**
 *  navi背景色渐变的效果
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (offsetY <= imageViewHeight) {
        CGFloat alpha = MAX(0, offsetY/imageViewHeight);
        
        [self.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(alpha)];
        self.title = @"";
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(1)];
       
        self.title = self.tacticSingleFoodModel.name;
        self.title = @"特色美食";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
