//
//  TacticSingleTipsController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticSingleTipsController.h"
#import "TacticSingleTipsModel.h"
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#define imageViewHeight (KSCREEN_W / 8.0 * 5)
@interface TacticSingleTipsController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *labelView;
@property (nonatomic, weak) UIImageView *mapView;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TacticSingleTipsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.hidesBottomBarWhenPushed = YES;
        [self setUpUI];
        [self setBackItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(0)];
    
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
    scrollView.bounces = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    /**
     创建白色背景
     */
    UIImageView *mapView = [[UIImageView alloc] init];
    mapView.userInteractionEnabled = YES;
    [self.scrollView addSubview:mapView];
    self.mapView = mapView;
    /**
     *  创建图片
     */
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    CGFloat imageViewW = KSCREEN_W;
    CGFloat imageViewH = imageViewHeight;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    [self.scrollView addSubview:imageView];
    imageView.backgroundColor = [UIColor redColor];
    self.imageView = imageView;
    
    //添加渐变条
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    bgImg.image=[UIImage imageNamed:@"Background"];
    [imageView addSubview:bgImg];
    
    /**
     *  创建文字
     */
    UILabel *labelView = [[UILabel alloc] init];
    labelView.layer.cornerRadius = 5;
    labelView.layer.masksToBounds = YES;
    labelView.font = labelViewFont;
    labelView.textColor = [UIColor ZYZC_TextGrayColor];
    labelView.numberOfLines = 0;
    [mapView addSubview:labelView];
    self.labelView = labelView;
    
}

- (void)setTacticSingleTipsModel:(TacticSingleTipsModel *)tacticSingleTipsModel
{
    _tacticSingleTipsModel = tacticSingleTipsModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    //肯定有图片
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:KWebImage(tacticSingleTipsModel.tipsImg)] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    
    CGFloat xxx = 0;
    if (tacticSingleTipsModel.tipsText.length > 0) {
        UIView *tipsView = [self createTextViewWithTitle:@"小贴士" text:tacticSingleTipsModel.tipsText];
        tipsView.top = 0;
        tipsView.left = 0;
        [_mapView addSubview:tipsView];
        
        xxx = KEDGE_DISTANCE + tipsView.height;
    }else{
        
        xxx = KEDGE_DISTANCE;
    }
    
    _mapView.frame = CGRectMake(KEDGE_DISTANCE, imageViewHeight + KEDGE_DISTANCE, KSCREEN_W - 2 * KEDGE_DISTANCE, xxx);
    
    _mapView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    _scrollView.contentSize = CGSizeMake(0,_mapView.bottom + KEDGE_DISTANCE);
}


/**
 *  返回一个mapView，包括标题，内容
 */
- (UIView *)createTextViewWithTitle:(NSString *)title text:(NSString *)text
{
    UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE,KEDGE_DISTANCE, KSCREEN_W - 2 * KEDGE_DISTANCE, 50)];
    //    mapView.backgroundColor = [UIColor greenColor];
    
    //绿线，经过计算后，高度为22左右
    UIView *greenLineView = [UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, 4, 22) andColor:[UIColor ZYZC_MainColor]];
    [mapView addSubview:greenLineView];
    
    //标题
    CGFloat titleLabelX = greenLineView.right + KEDGE_DISTANCE;
    CGFloat titleLabelY = KEDGE_DISTANCE;
    CGFloat titleLabelW = KSCREEN_W - 2 * KEDGE_DISTANCE - titleLabelX - KEDGE_DISTANCE;
    CGFloat titleLabelH = 22;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:20];
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
    
    paragrahStyle.firstLineHeadIndent = 25.0f;//首行缩进
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
        
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(alpha)];
        self.title = @"";
    } else {
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
        if (self.tacticSingleTipsModel) {
            self.title = self.tacticSingleTipsModel.name;
        }
        
    }
}
@end
