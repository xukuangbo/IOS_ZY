//
//  ZCProductDetailController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define KGET_DETAIL_PRODUCT(userId,productId)  [NSString stringWithFormat:@"%@userId=%@&productId=%@",GETPRODUCTDETAIL,userId,productId]

#define SHARE_URL(productId) [NSString stringWithFormat:@"http://www.sosona.com/pay/crowdfundingDetail?pid=%@",productId]


#import "ZCProductDetailController.h"

#import "ZCDetailBottomView.h"

#import "ZCCommentViewController.h"
#import "MBProgressHUD+MJ.h"

#import "WXApiShare.h"

#import "ZYVoicePlayer.h"
#import "NSDate+RMCalendarLogic.h"
#import "NetWorkManager.h"
#import "ZYZCDataBase.h"
#import "ZCSpotVideoModel.h"
#import "ZCListModel.h"
@interface ZCProductDetailController ()<UIActionSheetDelegate>
@property (nonatomic, strong) ZCProductDetailTableView *table;
@property (nonatomic, strong) UIColor               *navColor;
@property (nonatomic, strong) UIButton              *shareBtn;
@property (nonatomic, strong) UIButton          *collectionBtn;
@property (nonatomic, strong) ZCDetailBottomView  *bottomView;

@property (nonatomic, strong) NSMutableArray  *detailDays;
//行程安排数组
@property (nonatomic, strong) NSMutableArray   *favoriteTravel;//猜你喜欢的旅游
@property (nonatomic, assign) BOOL getCollection;//添加收藏与否
@property (nonatomic, assign) BOOL viewDidappear;//标记界面是否出现

@property (nonatomic, copy  ) NSString         *productDest;

@end

@implementation ZCProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _navColor=[UIColor ZYZC_NavColor];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    [self setBackItem];
    [self configUI];
    self.oneModel.productType=ZCDetailProduct;
    //如果不是本地草稿，获取数据
    if (_detailProductType!=SkimDetailProduct) {
        [self getHttpData];
    }
    
    if (_detailProductType==SkimDetailProduct) {
        self.productDest=_oneModel.product.productDest;
    }

}

#pragma mark --- 返回控制器
-(void)pressBack
{
    [super pressBack];
    [_shareBtn removeFromSuperview];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.oneModel.productType=_fromProductType;
}

#pragma mark --- 初始化数据
-(void)initData
{
    //旅行目的地
    _detailDays  =[NSMutableArray arrayWithArray:_schedule];
    if (_detailProductType==SkimDetailProduct) {
        _table.detailDays=_detailDays;
        _table.detailModel=_detailModel;
    }
}

#pragma mark --- 创建控件
-(void)configUI
{
    //创建table
    _table=[[ZCProductDetailTableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H-KTABBAR_HEIGHT) style:UITableViewStylePlain];
     [self.view addSubview:_table];
    _table.height=(_detailProductType==SkimDetailProduct||_detailProductType==DraftDetailProduct)?KSCREEN_H-KEDGE_DISTANCE:KSCREEN_H-KTABBAR_HEIGHT;
    _table.detailProductType=_detailProductType;
    _table.productId  =_productId;
    _table.oneModel   =_oneModel;
    
//    __weak typeof (&*self)weakSelf=self;
//    _table.headerRefreshingBlock=^()
//    {
//        if (weakSelf.detailProductType!=SkimDetailProduct) {
//            [weakSelf getHttpData];
//        }
//    };
    
    [self scrollDidScroll];
    
    if (_oneModel.product.headImage.length) {
        NSRange range=[_oneModel.product.headImage rangeOfString:KMY_ZHONGCHOU_FILE];
        //如果封面图片为本地图片
        if (range.length) {
            _table.topImgView.image=[UIImage imageWithContentsOfFile:_oneModel.product.headImage];
        }
        else
        {
             [_table.topImgView sd_setImageWithURL:[NSURL URLWithString:_oneModel.product.headImage ] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options: SDWebImageRetryFailed | SDWebImageLowPriority];
        }
    }


    //除预览和草稿，项目添加分享，评论，收藏，支付操作
    if (_detailProductType!=SkimDetailProduct&&_detailProductType!=DraftDetailProduct) {
        
        //如果安装微信&&支持微信API，则展示分享
        if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
            //导航栏添加分享
            _shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _shareBtn.frame=CGRectMake(KSCREEN_W-40, 0, 40, 44);
            [_shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
            [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationController.navigationBar addSubview:_shareBtn];
 
        }
    
//        添加底部按钮
        __weak typeof (&*self)weakSelf=self;
        _bottomView=[[ZCDetailBottomView alloc]init];
        [self.view addSubview:_bottomView];
        _bottomView.buttonClick=^(ZCBottomButtonType buttonType)
        {
            if (buttonType==CommentType) {
                [weakSelf comment];
            }
            else if(buttonType==SupportType)
            {
                [weakSelf support];
            }
            else if (buttonType==RecommendType)
            {
                [weakSelf collection];
            }
        };
    }
    
    //初始化数据
    [self initData];
}

#pragma mark --- tableView的滑动
-(void)scrollDidScroll
{
    __weak typeof (&*self)weakSelf=self;
    _table.scrollDidScrollBlock=^(CGFloat offSetY)
    {
        if (weakSelf.viewDidappear) {
            //导航栏颜色渐变
            [weakSelf changeNavColorByContentOffSetY:offSetY];
            //设置导航栏title
            CGFloat height=BGIMAGEHEIGHT;
            if ((height + offSetY)/(height)>1) {
                weakSelf.title= weakSelf.oneModel.product.productName;
                if (weakSelf.title.length>8) {
                    weakSelf.title=[NSString stringWithFormat:@"%@...",[weakSelf.title substringToIndex:7]];
                }
            }
            else
            {
                weakSelf.title=nil;
            }
        }
    };
}

#pragma mark --- 获取众筹详情数据
-(void)getHttpData
{
    //获取众筹详情
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr=KGET_DETAIL_PRODUCT([ZYZCAccountTool getUserId],_productId);
//     NSLog(@"%@",urlStr);
    [ZYZCHTTPTool getHttpDataByURL:urlStr withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
//        DDLog(@"productDetail:%@",result);
        if (isSuccess) {
            
            _detailModel=[[ZCDetailModel alloc]mj_setKeyValues:result];
            
            NSArray *detailDays=_detailModel.detailProductModel.schedule;
            for (NSString *jsonStr in detailDays) {
                NSDictionary *dict=[ZYZCTool turnJsonStrToDictionary:jsonStr];
                MoreFZCTravelOneDayDetailMdel *oneSchedule=[MoreFZCTravelOneDayDetailMdel mj_objectWithKeyValues:dict];
                [_detailDays addObject:oneSchedule];
            }
            //获取数据，给table赋值
            _table.detailDays=_detailDays;
            _table.detailModel=_detailModel;
            
            //判断是不是自己的项目，并更改底部按钮展示
            BOOL mySelf=[_detailModel.detailProductModel.mySelf boolValue];
            
            _oneModel.mySelf=mySelf;
            
            _bottomView.detailProductType=mySelf?MineDetailProduct:PersonDetailProduct;
            //判断是否已推荐
            _getCollection=[_detailModel.detailProductModel.Friend isEqual:@0];
            if (_bottomView.detailProductType==PersonDetailProduct) {
                _collectionBtn=(UIButton *)[_bottomView viewWithTag:RecommendType];
                 [_collectionBtn setTitle:_getCollection?@"推荐":@"已推荐" forState:UIControlStateNormal];
            }
            //判断项目众筹是否已截止
            //剩余天数
            int leftDays=0;
            if (_detailModel.detailProductModel.spell_end_time.length>8) {
                NSString *productEndStr=[NSDate changStrToDateStr:_detailModel.detailProductModel.spell_end_time];
                NSDate *productEndDate=[NSDate dateFromString:productEndStr];
                leftDays=[NSDate getDayNumbertoDay:[NSDate date] beforDay:productEndDate]+1;
                if (leftDays<0) {
                    leftDays=0;
                }
            }
            if (leftDays==0) {
                _bottomView.productEndTime=YES;
            }
            
            //获取目的地介绍和对应的视屏
            self.productDest=_oneModel.product.productDest;
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
            _bottomView.userInteractionEnabled=NO;
        }
    } andFailBlock:^(id failResult) {
//         NSLog(@"failResult:%@",failResult);
        [MBProgressHUD hideHUDForView:self.view];
        _bottomView.userInteractionEnabled=NO;
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpData];
        }];

    }];
}

#pragma mark --- 获取目的地及对应视屏
-(void)setProductDest:(NSString *)productDest
{
    _productDest=productDest;
    if (productDest.length) {
        NSArray *destArr=[ZYZCTool turnJsonStrToArray:productDest];
        //如果目的地是地名库中的目的地，则保存下来
        ZYZCDataBase *dataBase=[ZYZCDataBase sharedDBManager];
        NSMutableArray *viewSpots=[NSMutableArray array];
        for (NSString *dest in destArr) {
            OneSpotModel *oneSportModel=[dataBase searchOneDataWithName:dest];
            if (oneSportModel) {
                [viewSpots addObject:oneSportModel];
            }
        }
        _table.viewSpots=viewSpots;
    }
}

-(void)changeOneModelData:(ZCDetailProductModel *)detailProductModel
{
//    _oneModel.spellbuyproduct.realzjeNew;
}

#pragma mark --- 分享
-(void)share
{
    __weak typeof (&*self)weakSelf=self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    alertController.view.tintColor=[UIColor ZYZC_MainColor];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *shareToZoneAction = [UIAlertAction actionWithTitle:@"分享到微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [weakSelf shareToFriendScene:YES];
    }];
    
    UIAlertAction *shareToFriendAction = [UIAlertAction actionWithTitle:@"分享到微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
  {
      [weakSelf shareToFriendScene:NO];
  }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:shareToZoneAction];
    [alertController addAction:shareToFriendAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)shareToFriendScene:(BOOL)isFriendScene
{
    NSString *url=SHARE_URL(_productId);
    
    NSArray *destArr=[ZYZCTool turnJsonStrToArray:_oneModel.product.productDest];
    NSString *dest=destArr.count>1?destArr[1]:@"";
    
    [WXApiShare shareScene:isFriendScene withTitle:_oneModel.product.productName andDesc:[NSString stringWithFormat:@"%@梦想去%@旅行,正在众游筹旅费，希望你能支持TA",_oneModel.user.realName?_oneModel.user.realName:_oneModel.user.userName,dest] andThumbImage:_oneModel.user.faceImg andWebUrl:url];
}

#pragma mark --- 推荐/取消推荐
-(void)collection
{
    NSDictionary *parameters=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":_productId};
    NSString *url=_getCollection?FOLLOWPRODUCT:UNFOLLOWPRODUCT;
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
//        NSLog(@"%@",result);
        if(isSuccess)
        {
            _getCollection?[MBProgressHUD showSuccess:ZYLocalizedString(@"collection_success")]:[MBProgressHUD showSuccess:ZYLocalizedString(@"collection_fail")];
            [_collectionBtn setTitle:_getCollection?@"已推荐":@"推荐" forState:UIControlStateNormal];
            _getCollection=!_getCollection;
        }
        else
        {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
    }];
}

#pragma mark --- 评论
-(void)comment
{
    ZCCommentViewController *commentVC=[[ZCCommentViewController alloc]init];
    commentVC.productId=_oneModel.product.productId;
    commentVC.user=_oneModel.user;
    commentVC.title=@"评论";
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark --- 支持
-(void)support
{
    //支付
    if (_bottomView.surePay) {
        
        //如果没有安装微信/不能支持微信API，则提示
        if (![WXApi isWXAppInstalled]||![WXApi isWXAppSupportApi]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支持失败" message:@"未安装微信或微信版本过低" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if (_bottomView.payMoneyBlock) {
            _bottomView.payMoneyBlock(_oneModel.product.productId);
        }
    }
    //提示选择支付众筹的类型
    else{
        UIButton *supportBtn=(UIButton *)[_table.headView viewWithTag:ReturnType];
        [_table.headView getContent:supportBtn];
        
        [MBProgressHUD showShortMessage:@"请勾选下列支持方式"];
        [UIView animateWithDuration:0.1 animations:^{
            _table.contentOffset=CGPointMake(0, 156);
        } completion:nil];
    }
}

#pragma mark --- 改变导航栏颜色
-(void)changeNavColorByContentOffSetY:(CGFloat )offsetY
{
    //导航栏颜色渐变
    CGFloat height=BGIMAGEHEIGHT;
    if (offsetY >= -height) {
        CGFloat alpha = MIN(1, (height + offsetY)/height);
        [self.navigationController.navigationBar cnSetBackgroundColor:[_navColor colorWithAlphaComponent:alpha]];
    }
    else
    {
        [self.navigationController.navigationBar cnSetBackgroundColor:[_navColor colorWithAlphaComponent:0]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[_navColor colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    _viewDidappear=YES;
    _shareBtn.hidden=NO;
    [self changeNavColorByContentOffSetY:_table.contentOffset.y];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewControllerShow" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _shareBtn.hidden=YES;
    _viewDidappear=NO;
    
    //取消音频播放
    ZYVoicePlayer *zyVoicePlayer=[ZYVoicePlayer defaultAVPlayerWithPlayerItem:nil];
    [zyVoicePlayer pause];
    zyVoicePlayer=nil;
}

#pragma mark ---刷新部分数据
-(void)reloadPartInfo
{
    NSString *httpUrl=[NSString stringWithFormat:@"%@cache=false&orderType=4&status_not=0,2&productId=%@",LISTALLPRODUCTS,_oneModel.product.productId];
//    NSLog(@"%@",httpUrl);
    [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
//         NSLog(@"%@",result);
         if(isSuccess)
         {
             ZCListModel *listModel=[[ZCListModel alloc]mj_setKeyValues:result];
             ZCOneModel *oneModel=listModel.data.firstObject;
             _oneModel.spellbuyproduct.realzjeNew=oneModel.spellbuyproduct.realzjeNew;
             [_table reloadData];
         }
     }
      andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
      }];
    
}


-(void)dealloc
{
//    NSLog(@"dealloc:%@",self.class);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
