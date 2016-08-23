

#import "TacticTableViewCell.h"
#import "TacticModel.h"
#import "TacticVideoModel.h"
#import "TacticThreeMapView.h"
#import "TacticCustomMapView.h"
#import "ZYZCTool.h"
#import "TacticMoreVideosController.h"
#import "TacticMoreCitiesVC.h"
#import "TacticMoreVideoVC.h"
#import "ZCWebViewController.h"
#import "ZYZCPlayViewController.h"
#import "TacticCustomMapView.h"
@interface TacticTableViewCell()<TacticCustomMapViewDelegate>
/**
 *  视频view
 */
@property (nonatomic, weak) UIView *videoView;
/**
 *  video的容器view
 */
@property (nonatomic, weak) TacticThreeMapView *videoThreeMapView;

/**
 *  国家view
 */
@property (nonatomic, strong) TacticCustomMapView *countryView;
/**
 *  国家的容器view1
 */
@property (nonatomic, strong) TacticThreeMapView *countryViewOne;
/**
 *  国家的容器view2
 */
@property (nonatomic, strong) TacticThreeMapView *countryViewTwo;
/**
 *  热门目的地view
 */
@property (nonatomic, strong) TacticCustomMapView *hotDestView;
/**
 *  热门目的地容器view
 */
@property (nonatomic, strong) TacticThreeMapView *hotDestViewOne;
/**
 *  热门目的地容器view
 */
@property (nonatomic, strong) TacticThreeMapView *hotDestViewTwo;

/**
 *  广告-拷贝位
 */
@property (nonatomic, strong) UIImageView *adView;

@property (nonatomic, assign) CGFloat adViewHeight;

@end

#pragma mark - system方法

@implementation TacticTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        UIImage *image = [UIImage imageNamed:@"广告-拷贝"];
        _adViewHeight = (KSCREEN_W - 2 * KEDGE_DISTANCE) * image.size.height * image.size.width;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /**
         *  创建视频view
         */
        [self createVideoView];
        
        
        /**
         *  创建国家
         */
        [self createCountryView];
        
        /**
         *  创建目的地view
         */
        [self createDestView];
        
        /**
         *  创建一个广告-拷贝位
         */
        [self createADView];
    }
    return self;
}
#pragma mark - setUI方法
/**
 *  创建视频view
 */
- (void)createVideoView
{
    CGFloat videoViewX = KEDGE_DISTANCE;
    CGFloat videoViewY = KEDGE_DISTANCE;
    CGFloat videoViewW = KSCREEN_W - videoViewX * 2;
    CGFloat videoViewH = threeViewMapHeight;
//    UIView *videoView = [UIView viewWithIndex:1 frame:CGRectMake(videoViewX, videoViewY, videoViewW, videoViewH) Title:@"视频攻略" desc:@"3分钟看懂旅行目的地核心攻略"];
    TacticCustomMapView *videoView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(videoViewX, videoViewY, videoViewW, videoViewH)];
    videoView.titleLabel.text = ZYLocalizedString(@"tactic_video_title");
    videoView.moreButton.tag = MoreVCTypeTypeVideo;
    videoView.delegate = self;
    videoView.moreButton.hidden = NO;
    videoView.descLabel.text = ZYLocalizedString(@"tactic_video_detailTitle");
    self.videoView = videoView;
    //添加点击手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotDestViewAction:)];
    [videoView addGestureRecognizer:gesture];
    [self.contentView addSubview:videoView];
    
    //    descLabel.bottom == descLabelBottom
    CGFloat threeMapViewX = KEDGE_DISTANCE;
    CGFloat threeMapViewY = descLabelBottom + 4;
    CGFloat threeMapViewW = videoViewW - KEDGE_DISTANCE * 2;
    CGFloat threeMapViewH = threeViewHeight;
    TacticThreeMapView *threeMapView = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(threeMapViewX, threeMapViewY, threeMapViewW, threeMapViewH)];
    threeMapView.threeMapViewType = threeMapViewTypeVideo;
    [videoView addSubview:threeMapView];
    self.videoThreeMapView = threeMapView;
    
}

- (void)createCountryView
{
    CGFloat hotDestViewX = KEDGE_DISTANCE;
    CGFloat hotDestViewY = self.videoView.bottom + KEDGE_DISTANCE;
    CGFloat hotDestViewW = KSCREEN_W - hotDestViewX * 2;
    CGFloat hotDestViewH = sixViewMapHeight;
    _countryView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(hotDestViewX, hotDestViewY, hotDestViewW, hotDestViewH)];
    _countryView.moreButton.tag = MoreVCTypeTypeCountryView;
    _countryView.moreButton.hidden = NO;
    _countryView.delegate = self;
    _countryView.titleLabel.text = ZYLocalizedString(@"tactic_country_title");
    _countryView.descLabel.text = ZYLocalizedString(@"country_detail_title");
    [self.contentView addSubview:_countryView];
    //创建3个图片的容器
    
    //    descLabel.bottom == descLabelBottom
    CGFloat countryViewOneX = KEDGE_DISTANCE;
    CGFloat countryViewOneY = descLabelBottom + 4;
    CGFloat countryViewOneW = hotDestViewW - KEDGE_DISTANCE * 2;
    CGFloat countryViewOneH = threeViewHeight;
    _countryViewOne = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(countryViewOneX, countryViewOneY, countryViewOneW, countryViewOneH)];
    [_countryView addSubview:_countryViewOne];
    
    
    //    descLabel.bottom == descLabelBottom
    CGFloat countryViewTwoX = KEDGE_DISTANCE;
    CGFloat countryViewTwoY = _countryViewOne.bottom + KEDGE_DISTANCE;
    CGFloat countryViewTwoW = _countryView.width - KEDGE_DISTANCE * 2;
    CGFloat countryViewTwoH = threeViewHeight;
    _countryViewTwo = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(countryViewTwoX, countryViewTwoY, countryViewTwoW, countryViewTwoH)];
    [_countryView addSubview:_countryViewTwo];
}


/**
 *  创建目的地view
 */
- (void)createDestView
{
    CGFloat hotDestViewX = KEDGE_DISTANCE;
    CGFloat hotDestViewY = _countryView.bottom + KEDGE_DISTANCE;
    CGFloat hotDestViewW = KSCREEN_W - hotDestViewX * 2;
    CGFloat hotDestViewH = sixViewMapHeight;
    _hotDestView = [[TacticCustomMapView alloc] initWithFrame:CGRectMake(hotDestViewX, hotDestViewY, hotDestViewW, hotDestViewH)];
    _hotDestView.moreButton.tag = MoreVCTypeTypeCityView;
    _hotDestView.moreButton.hidden = NO;
    _hotDestView.delegate = self;
    _hotDestView.titleLabel.text = ZYLocalizedString(@"tactic_dest_title");
    _hotDestView.descLabel.text = ZYLocalizedString(@"country_detail_title");
    
    [self.contentView addSubview:_hotDestView];
    //创建3个图片的容器
    //    descLabel.bottom == descLabelBottom
    CGFloat hotDestViewOneX = KEDGE_DISTANCE;
    CGFloat hotDestViewOneY = descLabelBottom + 4;
    CGFloat hotDestViewOneW = hotDestViewW - KEDGE_DISTANCE * 2;
    CGFloat hotDestViewOneH = threeViewHeight;
    _hotDestViewOne = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(hotDestViewOneX, hotDestViewOneY, hotDestViewOneW, hotDestViewOneH)];
    [_hotDestView addSubview:_hotDestViewOne];
    
    //    descLabel.bottom == descLabelBottom
    CGFloat hotDestViewTwoX = KEDGE_DISTANCE;
    CGFloat hotDestViewTwoY = _hotDestViewOne.bottom + KEDGE_DISTANCE;
    CGFloat hotDestViewTwoW = _hotDestView.width - KEDGE_DISTANCE * 2;
    CGFloat hotDestViewTwoH = threeViewHeight;
    _hotDestViewTwo = [[TacticThreeMapView alloc] initWithFrame:CGRectMake(hotDestViewTwoX, hotDestViewTwoY, hotDestViewTwoW, hotDestViewTwoH)];
    [_hotDestView addSubview:_hotDestViewTwo];
}
- (void)createADView
{
    UIImage *image = [UIImage imageNamed:@"广告-拷贝"];
    CGFloat adViewX = KEDGE_DISTANCE;
    CGFloat adViewY = _hotDestView.bottom + KEDGE_DISTANCE;
    CGFloat adViewW = KSCREEN_W - 2 * adViewX;
    CGFloat adViewH = adViewW * image.size.height / image.size.width;
    _adView = [[UIImageView alloc] initWithFrame:CGRectMake(adViewX, adViewY, adViewW, adViewH)];
    [_adView addTarget:self action:@selector(adViewAction)];
    _adView.image = [UIImage imageNamed:@"广告-拷贝"];
//    _adView.height =
//    _adView.backgroundColor = [UIColor redColor];
    _adView.layer.cornerRadius = 5;
    _adView.layer.masksToBounds = YES;
    [self.contentView addSubview:_adView];
    
}
#pragma mark - requsetData方法

#pragma mark - set方法
- (void)setTacticModel:(TacticModel *)tacticModel
{
    if (_tacticModel != tacticModel) {
        _tacticModel = tacticModel;
        
        self.videoThreeMapView.videos = tacticModel.videos;
        
        if (tacticModel.countryViews.count>3) {
            _countryViewOne.singleViews = tacticModel.countryViews;
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 3; i < tacticModel.countryViews.count; i++) {
                [tempArray addObject:tacticModel.countryViews[i]];
            }
            _countryViewTwo.singleViews = tempArray;
        }
        
        if (tacticModel.mgViews.count > 3) {//有两排的情况下
            _hotDestViewOne.singleViews = tacticModel.mgViews;
            
            NSMutableArray *tempArrayTwo = [NSMutableArray array];
            for (int i = 3; i < tacticModel.mgViews.count; i++) {
                [tempArrayTwo addObject:tacticModel.mgViews[i]];
            }
            _hotDestViewTwo.singleViews = tempArrayTwo;
        }
    }
}

#pragma mark - button点击方法

- (void)hotDestViewAction:(UITapGestureRecognizer *)gesture
{
//    NSLog(@"555555555");
}

/**
 *  广告-拷贝点击
 */
- (void)adViewAction
{
    //获取当前网络状态
    int networkType=[ZYZCTool getCurrentNetworkStatus];
    //无网络
    if (networkType==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"当前无网络" message:@"无法播放视屏,请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=0;
        [alert show];
        return;
    }
    //无Wi-Fi
    else if(networkType!=5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"【流量使用提示】" message:@"当前网络无Wi-Fi,继续播放可能会被运营商收取流量费用" delegate:self cancelButtonTitle:@"停止播放" otherButtonTitles:@"继续播放", nil];
        alert.tag=1;
        [alert show];
        return;
    }
    //有wifi
    else
    {
        [self playVideo];
    }
    
}

#pragma mark --- 播放视频
-(void)playVideo
{
    NSString *playUrl = @"http://video.sosona.com/video_spot/jieshao";
    
    NSRange range=[playUrl rangeOfString:@".html"];
    if (range.length) {//网页
        ZCWebViewController *webController=[[ZCWebViewController alloc]init];
        webController.requestUrl= playUrl;
        webController.myTitle=@"视频播放";
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webController animated:YES completion:nil];
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {//视频
        ZYZCPlayViewController *playVC = [[ZYZCPlayViewController alloc] init];
        playVC.urlString = playUrl;
        [self.viewController presentViewController:playVC animated:YES completion:nil];
        return;
    }
}

#pragma mark - TacticCustomMapViewDelegate
- (void)pushToMoreVC:(UIButton *)button
{
    if (button.tag == MoreVCTypeTypeVideo) {
//        NSLog(@"我是更多视频");
        TacticMoreVideoVC *moreVC = [[TacticMoreVideoVC alloc] init];
//        moreVC.moreArray = self.tacticModel.videos;
        [self.viewController.navigationController pushViewController:moreVC animated:YES];
    }else if (button.tag == MoreVCTypeTypeCountryView){
//        NSLog(@"我是更多国家");
        TacticMoreCitiesVC *moreVC = [[TacticMoreCitiesVC alloc] initWithViewType:1];
//        moreVC.moreArray = self.tacticModel.mgViews;
        [self.viewController.navigationController pushViewController:moreVC animated:YES];
    }else if (button.tag == MoreVCTypeTypeCityView){
//        NSLog(@"我是更多景点");
        TacticMoreCitiesVC *moreVC = [[TacticMoreCitiesVC alloc] initWithViewType:2];
        //        moreVC.moreArray = self.tacticModel.mgViews;
        [self.viewController.navigationController pushViewController:moreVC animated:YES];
    }else if (button.tag == MoreVCTypeTypeFood){
//        NSLog(@"我是更多美食");
    }
}
@end
