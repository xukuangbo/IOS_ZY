//
//  TacticMoreJieshaoVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]

#define imageViewHeight (KSCREEN_W / 8.0 * 5)

#define labelViewFont [UIFont systemFontOfSize:16]

#import "TacticMoreJieshaoVC.h"
#import "TacticSingleModel.h"

@interface TacticMoreJieshaoVC ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIImageView *mapView;
@property (nonatomic, weak) UILabel *labelView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TacticMoreJieshaoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
        //        self.edgesForExtendedLayout = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setUpUI];
        [self setBackItem];
        
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
//    imageView.backgroundColor = [UIColor redColor];
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
    namelabel.shadowColor=[UIColor blackColor];
    namelabel.textColor = [UIColor whiteColor];
    namelabel.centerX = KSCREEN_W * 0.5;
    namelabel.centerY = imageViewH * 0.5;
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
//    UILabel *labelView = [[UILabel alloc] init];
//    labelView.layer.cornerRadius = 5;
//    labelView.layer.masksToBounds = YES;
//    labelView.font = [UIFont systemFontOfSize:33];
//    //    labelView.backgroundColor = [UIColor whiteColor];
//    labelView.textColor = [UIColor ZYZC_TextGrayColor];
//    labelView.numberOfLines = 0;
//    [mapView addSubview:labelView];
//    self.labelView = labelView;
    
}


- (void)setTacticSingleModel:(TacticSingleModel *)tacticSingleModel
{
    _tacticSingleModel = tacticSingleModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleModel.viewImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    
    self.nameLabel.text = tacticSingleModel.name;
    //计算高度,传文字，标题，就可以
    
    /**
     *  概况
     */
    CGFloat gaikuangY = 0;
    
    /**
     *  天气
     */
    CGFloat weatherY = 0;
    
    if (tacticSingleModel.viewText.length > 0) {
        UIView *gaikuangView = [self createTextViewWithTitle:@"概况" text:tacticSingleModel.viewText];
        gaikuangView.top = 0;
        gaikuangView.left = 0;
        [_mapView addSubview:gaikuangView];
        
        weatherY = gaikuangY + gaikuangView.height;
    }else{
        
        weatherY = gaikuangY;
    }
    /**
     *  交通
     */
    CGFloat trafficY = 0;
    
    if (tacticSingleModel.weather.length > 0) {
        UIView *weatherview = [self createTextViewWithTitle:@"天气" text:tacticSingleModel.weather];
        weatherview.top = weatherY;
        weatherview.left = 0;
        [_mapView addSubview:weatherview];
        
        trafficY = weatherY + weatherview.height;
    }else{
        
        trafficY = weatherY;
    }
    /**
     *  住宿
     */
    CGFloat stayY = 0;
    
    if (tacticSingleModel.stay.length > 0) {
        UIView *trafficView = [self createTextViewWithTitle:@"交通" text:tacticSingleModel.stay];
        trafficView.top = trafficY;
        trafficView.left = 0;
        [_mapView addSubview:trafficView];
        
        stayY = trafficY + trafficView.height;
    }else{
        
        stayY = trafficY;
    }
    /**
     *  购物
     */
    CGFloat shoppingY = 0;
    
    if (tacticSingleModel.stay.length > 0) {
        UIView *stayView = [self createTextViewWithTitle:@"住宿" text:tacticSingleModel.stay];
        stayView.top = stayY;
        stayView.left = 0;
        [_mapView addSubview:stayView];
        
        shoppingY = stayY + stayView.height;
    }else{
        
        shoppingY = stayY;
    }
    /**
     *  语言
     */
    CGFloat languageY = 0;
    if (tacticSingleModel.shopping.length > 0) {
        UIView *shoppingView = [self createTextViewWithTitle:@"购物" text:tacticSingleModel.shopping];
        shoppingView.top = shoppingY;
        shoppingView.left = 0;
        [_mapView addSubview:shoppingView];
        
        languageY = shoppingY + shoppingView.height;
    }else{
        
        languageY = shoppingY;
    }
    /**
     *  汇率
     */
    CGFloat paritiesY = 0;
    if (tacticSingleModel.language.length > 0) {
        UIView *languageView = [self createTextViewWithTitle:@"语言" text:tacticSingleModel.language];
        languageView.top = languageY;
        languageView.left = 0;
        [_mapView addSubview:languageView];
        
        paritiesY = languageY + languageView.height;
    }else{
        
        paritiesY = languageY;
    }
    /**
     *  签证
     */
    CGFloat visaY = 0;
    if (tacticSingleModel.parities.length > 0) {
        UIView *paritiesView = [self createTextViewWithTitle:@"汇率" text:tacticSingleModel.parities];
        paritiesView.top = paritiesY;
        paritiesView.left = 0;
        [_mapView addSubview:paritiesView];
        
        visaY = paritiesY + paritiesView.height;
    }else{
        
        visaY = paritiesY;
    }
    
    CGFloat XXX = 0;
    if (tacticSingleModel.visa.length > 0) {
        UIView *visaView = [self createTextViewWithTitle:@"签证" text:tacticSingleModel.visa];
        visaView.top = visaY;
        visaView.left = 0;
        [_mapView addSubview:visaView];
        
        XXX = visaY + visaView.height;
    }else{
        
        XXX = visaY;
    }
    
    _mapView.frame = CGRectMake(KEDGE_DISTANCE, imageViewHeight + KEDGE_DISTANCE, KSCREEN_W - 2 * KEDGE_DISTANCE, XXX + KEDGE_DISTANCE);
    
    _mapView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _scrollView.contentSize = CGSizeMake(0, XXX + KEDGE_DISTANCE * 3 + imageViewHeight);
    
}

/**
 *  返回一个mapView，包括标题，内容
 */
- (UIView *)createTextViewWithTitle:(NSString *)title text:(NSString *)text
{
    UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, imageViewHeight + KEDGE_DISTANCE, KSCREEN_W - 2 * KEDGE_DISTANCE, 50)];
//    mapView.backgroundColor = [UIColor greenColor];
    
    //绿线，经过计算后，高度为22左右
    CGFloat titleHeight = 15;
    UIView *greenLineView = [UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, 2, titleHeight) andColor:[UIColor ZYZC_MainColor]];
    [mapView addSubview:greenLineView];
    
    //标题
    CGFloat titleLabelX = greenLineView.right + KEDGE_DISTANCE;
    CGFloat titleLabelY = KEDGE_DISTANCE;
    CGFloat titleLabelW = KSCREEN_W - 2 * KEDGE_DISTANCE - titleLabelX - KEDGE_DISTANCE;
    CGFloat titleLabelH = titleHeight;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
//    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = title;
    [mapView addSubview:titleLabel];
    
    //内容
    //textLabel
    CGFloat textLabelX = greenLineView.left;
    CGFloat textLabelY = titleLabel.bottom + KEDGE_DISTANCE;
    CGFloat textLabelW = KSCREEN_W - 2 * KEDGE_DISTANCE - KEDGE_DISTANCE * 2;
    CGFloat textLabelH = 0;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH)];
//    textLabel.backgroundColor = [UIColor redColor];
    textLabel.textColor = [UIColor ZYZC_TextGrayColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = text;
    [mapView addSubview:textLabel];
    
    //先去空格,先按段切割，然后,然后用\n拼接
    NSArray *tempStringArr = [text componentsSeparatedByString:@"\n"];
    //拼接后的句子
    NSString *tempString = [NSString string];
    for (NSString *str in tempStringArr) {
        //去首尾空格
        NSString *tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (tempString.length <= 0) {
            //第一句话
            tempString = [tempString stringByAppendingString:tempStr];
        }else{
            //不是第一句话
            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"\n%@",tempStr]];
        }
    }
    //这里能拿到拼接过的句子
    
    //更改行首缩进
    NSMutableParagraphStyle *paragrahStyle =  [[NSMutableParagraphStyle alloc] init];
    
    paragrahStyle.firstLineHeadIndent = 20.0f;//首行缩进
    paragrahStyle.alignment = NSTextAlignmentLeft;  //对齐
//    paragrahStyle.lineSpacing = 10.0f;//行间距
    
    //属性字典
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : paragrahStyle,
                                 NSFontAttributeName : textLabel.font};
    //属性文本
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:tempString attributes:attributes];
    //属性大小赋值
    textLabel.size = [tempString boundingRectWithSize:CGSizeMake(textLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    //属性文本赋值
    textLabel.attributedText = attrText;
    
    mapView.height = textLabel.bottom;
    return mapView;
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
        self.title = self.tacticSingleModel.name;
        
    }
}

//    paragrahStyle.alignment = NSTextAlignmentLeft;  //对齐
//    paragrahStyle.headIndent = 0.0f;//行首缩进
//    paragrahStyle.tailIndent = 0.0f;//行尾缩进
//paragrahStyle.firstLineHeadIndent = 10.0f;//首行缩进
//paragrahStyle.lineSpacing = 10.0f;//行间距
@end
