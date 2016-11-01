//
//  TacticGeneralVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]

#define imageViewHeight (KSCREEN_W / 8 * 5)

#define labelViewFont [UIFont systemFontOfSize:16]

#import "TacticGeneralVC.h"
#import "TacticGeneralModel.h"
@interface TacticGeneralVC ()<UIScrollViewDelegate>
//head
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *flagImage;
@property (nonatomic, weak) UILabel *flagImageName;
//body
@property (nonatomic, weak) UIImageView *mapView;
@property (nonatomic, weak) UILabel *labelView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TacticGeneralVC
- (instancetype)initWithViewId:(NSInteger)viewId
{
    self = [super init];
    if (self) {
        self.viewId = viewId;
        [self setUpUI];
        [self setBackItem];
        
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
        
        /**
         *  刷新数据
         */
        [self refreshDataWithViewId:self.viewId];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(0)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:home_navi_bgcolor(1)];
    self.navigationController.navigationBar.shadowImage = nil;
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
    self.imageView = imageView;
    
    //添加渐变条
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    bgImg.image=[UIImage imageNamed:@"Background"];
    [imageView addSubview:bgImg];
    
    /**
     图片上的文字
     */
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageViewW, 60)];
    namelabel.font = [UIFont systemFontOfSize:33];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.textColor = [UIColor whiteColor];
    namelabel.shadowOffset=CGSizeMake(1, 1);
    namelabel.shadowColor=[UIColor blackColor];
    namelabel.centerX = KSCREEN_W * 0.5;
    namelabel.centerY = imageViewH * 0.5;
    [imageView addSubview:namelabel];
    self.nameLabel = namelabel;
    
    CGFloat flagImageWH = 30;
    UIImageView *flagImage = [[UIImageView alloc] init];
    flagImage.size = CGSizeMake(flagImageWH, flagImageWH);
    flagImage.layer.cornerRadius = flagImageWH / 2.0;
    flagImage.layer.masksToBounds = YES;
    flagImage.left = KEDGE_DISTANCE;
    flagImage.bottom = imageView.size.height - KEDGE_DISTANCE;
    [imageView addSubview:flagImage];
    self.flagImage = flagImage;
    
    UILabel *flagImageName = [[UILabel alloc] init];
    flagImageName.size = CGSizeMake(200, 30);
    flagImageName.left = flagImage.right + 5;
    flagImageName.textColor = [UIColor whiteColor];
    flagImageName.centerY = flagImage.centerY;
    flagImageName.shadowOffset=CGSizeMake(1, 1);
    [imageView addSubview:flagImageName];
    self.flagImageName = flagImageName;
    
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
//    labelView.backgroundColor = [UIColor whiteColor];
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

/**
 *  刷新数据
 */
- (void)refreshDataWithViewId:(NSInteger)viewId
{
//    NSString *url= GET_TACTIC_VIEW(viewId);
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"viewSpot_getViewSpot"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:[NSString stringWithFormat:@"%ld", viewId] forKey:@"viewId"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功，转化为数组
            //            NSDictionary *dic = (NSDictionary *)result;
            //            NSLog(@"%@",dic[@"foods"]);
            //先判断是那种类型
            TacticGeneralModel *tacticGeneralModel = [TacticGeneralModel mj_objectWithKeyValues:result[@"data"]];
            weakSelf.tacticGeneralModel = tacticGeneralModel;
        }
    } andFailBlock:^(id failResult) {
        
    }];
}

- (void)setTacticGeneralModel:(TacticGeneralModel *)tacticGeneralModel
{
    _tacticGeneralModel = tacticGeneralModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    //肯定有图片
    CGFloat mapViewX = KEDGE_DISTANCE;
    CGFloat mapViewY = imageViewHeight + KEDGE_DISTANCE;
    CGFloat mapViewW = KSCREEN_W - mapViewX * 2;
    //先计算文字高度
    CGFloat labelViewX = KEDGE_DISTANCE;
    CGFloat labelViewY = KEDGE_DISTANCE;
    CGFloat labelViewW = mapViewW - labelViewX * 2;
    CGFloat labelViewH = 0;
    CGSize textSize = [ZYZCTool calculateStrLengthByText:tacticGeneralModel.viewText andFont:labelViewFont andMaxWidth:labelViewW];
    labelViewH = textSize.height;
    
    self.nameLabel.text = tacticGeneralModel.name;
//    [self.nameLabel sizeToFit];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticGeneralModel.viewImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    
    self.labelView.text = tacticGeneralModel.viewText;
    self.labelView.frame = CGRectMake(labelViewX, labelViewY, labelViewW, labelViewH);
    
    CGFloat mapViewH = labelViewH + KEDGE_DISTANCE * 2;
    
    if (tacticGeneralModel.pics) {
        
        CGFloat imageX = KEDGE_DISTANCE;
        CGFloat imageW = mapViewW - imageX * 2;
        CGFloat imageH = imageW / 16 * 9;
        NSArray *detailImageArray = tacticGeneralModel.pics;
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, CGRectGetMaxY(self.mapView.frame) + KEDGE_DISTANCE);
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
        self.title = @"景点";
        
    }
}
@end
