//
//  MoreFZCViewController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCViewController.h"

#import "MoreFZCGoalTableView.h"
#import "MoreFZCRaiseMoneyTableView.h"
#import "MoreFZCTravelTableView.h"
#import "MoreFZCReturnTableView.h"
#import "ZYZCTool+getLocalTime.h"
#import "MoreFZCDataManager.h"
#import "FZCReplaceDataKeys.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCOSSManager.h"
#import "NecessoryAlertManager.h"

#import "FZCSaveDraftData.h"
#import "ZCProductDetailController.h"
#import "GuideWindow.h"
#import "ZYNewGuiView.h"
#import "ZYGuideManager.h"
#define kMoreFZCToolBar 20
#define kNaviBar 64

#define ALERT_BACK_TAG    1
#define ALERT_UPLOAD_TAG  2
#define ALERT_PUBLISH_TAG 3
#define ALERT_NO_WIFI_TAG  5
#define ALERT_PUBLISH      6
//#define ALERT_NETWORK_CHANGE_TAG  6

@interface MoreFZCViewController ()<MoreFZCToolBarDelegate,UIAlertViewDelegate, ShowDoneDelegate>
@property (nonatomic, assign) BOOL needPopVC;
                              //记录发布的数据在oss的位置
@property (nonatomic, copy  ) NSString *myZhouChouMarkName;
                              //记录发布的所有文件的状态
//@property (nonatomic, strong) NSMutableArray *uploadDataState;
                              //要上传到oss上的文件个数
@property (nonatomic, assign) NSInteger uploadDataNumber;
                              //发布成功个数
@property (nonatomic, assign) NSInteger  uploadSuccessNumber;
                              //记录发布成功的状态
@property (nonatomic, assign) BOOL hasPulish;
                              //记录上传数据成功的状态
@property (nonatomic, assign) BOOL hasUpload;
                              //记录是否保存数据
@property (nonatomic, assign) BOOL hasSaveProduct;
                              // 是否保存为草稿
@property (nonatomic, assign) BOOL saveMyDraft;

                              //发布数据的参数
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) ZCOneModel   *oneModel;

@property (nonatomic, strong) ZCDetailProductModel  *detailProductModel;

@property (nonatomic, strong) MBProgressHUD *mbProgress;

//@property (nonatomic, assign) BOOL stopPublish;
// 引导页view
@property (strong, nonatomic) GuideWindow *guideWindow;
@property (strong, nonatomic) ZYNewGuiView *guideView;
@property (strong, nonatomic) ZYNewGuiView *skipGuideView;
@property (strong, nonatomic) ZYNewGuiView *changeGuideView;
@property (nonatomic, assign) detailType guideType;
@end

@implementation MoreFZCViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
   
    [super viewDidLoad];
//    [self getHttpData];
//    return; 
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithInteger:0] forKey:KMOREFZC_RETURN_SUPPORTTYPE];
    [user synchronize];
//    self.title=@"发起众筹";
     self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    _uploadDataState=[NSMutableArray array];
    [self setBackItem];
    [self createToolBar];
    [self createClearMapView];
    [self createBottomView];
    if (![ZYGuideManager getGuidePreview]) {
        [self createPrevContextView];
    }
    //    [self getHttpData];
}
/**
 *  创建空白容器，并创建4个tableview
 */
- (void)createClearMapView
{
    //1.创建空白的view
    UIView *clearMapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H)];
    clearMapView.backgroundColor = [UIColor redColor];
    [self.view insertSubview:clearMapView belowSubview:self.toolBar];
    self.clearMapView = clearMapView;
    
    //!重点：IOS7 UIScrollerView 的一个特点 如果UIScView是父view的第一个子view 会自动添加偏移量 uitableview继承自UIscview 所以有偏移，所以！！！我加了一个view放在底部，防止偏移
    UIView *clearView1 = [[UIView alloc] initWithFrame:clearMapView.bounds];
    clearView1.backgroundColor = [UIColor clearColor];
    [clearMapView addSubview:clearView1];
    
    MoreFZCGoalTableView *goalTableView = [[MoreFZCGoalTableView alloc] initWithFrame:clearMapView.bounds style:UITableViewStylePlain];
    goalTableView.tag = MoreFZCToolBarTypeGoal;
    [clearMapView addSubview:goalTableView];
    
    MoreFZCRaiseMoneyTableView *raiseMoneyTableView = [[MoreFZCRaiseMoneyTableView alloc] initWithFrame:clearMapView.bounds style:UITableViewStylePlain];
    raiseMoneyTableView.tag = MoreFZCToolBarTypeRaiseMoney;
    [clearMapView insertSubview:raiseMoneyTableView belowSubview:goalTableView];
//    [clearMapView addSubview:raiseMoneyTableView];
    
    MoreFZCTravelTableView *travelTableView = [[MoreFZCTravelTableView alloc] initWithFrame:clearMapView.bounds style:UITableViewStylePlain];
    
    [clearMapView insertSubview:travelTableView belowSubview:goalTableView];
     travelTableView.tag = MoreFZCToolBarTypeTravel;
//    [clearMapView addSubview:travelTableView];
    
    MoreFZCReturnTableView *returnTableView = [[MoreFZCReturnTableView alloc] initWithFrame:clearMapView.bounds style:UITableViewStylePlain];
    returnTableView.tag = MoreFZCToolBarTypeReturn;
    [clearMapView insertSubview:returnTableView belowSubview:goalTableView];
}

/**
 *  创建工具条
 */
- (void)createToolBar
{
    //2.toolbar的创建
    MoreFZCToolBar *toolBar = [[MoreFZCToolBar alloc] initWithFrame:CGRectMake( 0, kNaviBar, KSCREEN_W, 44)];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
}

/**
 *  返回被选中的view
 */
- (UIView *)selectdView:(NSInteger)buttonTag
{
    
    for (UIView *subView in self.clearMapView.subviews) {
            if (subView.tag == buttonTag) {
                return subView;
            }
    }
    return nil;
}

#pragma mark -guideView
- (GuideWindow *)guideWindow
{
    if (!_guideWindow) {
        _guideWindow = [[GuideWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _guideWindow;
}

- (void)createPrevContextView
{
    self.guideType = prevType;
    ZYNewGuiView *newGuideView = [[ZYNewGuiView alloc] initWithFrame:CGRectMake(0, -49, ScreenWidth, ScreenHeight)];
    [self.guideWindow addSubview:newGuideView];
    self.guideView = newGuideView;
    newGuideView.showDoneDelagate = self;
    [newGuideView initSubViewWithTeacherGuideType:prevType withContextViewType:rectTangleType];
    [self.guideWindow bringSubviewToFront:newGuideView];
    [self.guideWindow show];
}

- (void)createChangeContextView
{
    self.guideType = voiceType;
    ZYNewGuiView *changeGuideView = [[ZYNewGuiView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.guideWindow addSubview:changeGuideView];
    self.changeGuideView = changeGuideView;
    self.changeGuideView.rectTypeOriginalY = 283;
    changeGuideView.showDoneDelagate = self;
    [changeGuideView initSubViewWithTeacherGuideType:voiceType withContextViewType:rectTangleType];
    [self.guideWindow bringSubviewToFront:changeGuideView];
    [self.guideWindow show];
}

- (void)createSkipContextView
{
    self.guideType = skipType;
    ZYNewGuiView *skipGuideView = [[ZYNewGuiView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    [self.guideWindow addSubview:skipGuideView];
    self.skipGuideView = skipGuideView;
    skipGuideView.showDoneDelagate = self;
    [skipGuideView initSubViewWithTeacherGuideType:skipType withContextViewType:rectTangleType];
    [self.guideWindow bringSubviewToFront:skipGuideView];
    [self.guideWindow show];
}


#pragma mark - ShowDoneDelegate
- (void)showDone
{
    if (self.guideType == prevType) {
        self.guideView = nil;
        [self.guideView removeFromSuperview];
        [self.guideWindow dismiss];
        self.guideWindow = nil;
        [ZYGuideManager guidePreview:YES];
    } else if (self.guideType == skipType) {
        self.skipGuideView = nil;
        [self.skipGuideView removeFromSuperview];
        [self.guideWindow dismiss];
        self.guideWindow = nil;
        [ZYGuideManager guideSkip:YES];
    } else {
        self.changeGuideView = nil;
        [self.changeGuideView removeFromSuperview];
        [self.guideWindow dismiss];
        self.guideWindow = nil;
        [ZYGuideManager guideChangeVoice:YES];
    }
}

#pragma mark --- 创建底部视图
-(void)createBottomView
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, KSCREEN_H-KTABBAR_HEIGHT , KSCREEN_W, KTABBAR_HEIGHT)];
    bottomView.backgroundColor=[UIColor ZYZC_TabBarGrayColor];
    [self.view addSubview:bottomView];
    
    [bottomView addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]]];
    
    NSArray *titleArr=@[@"预览",@"下一步",@"保存"];
    CGFloat btn_width=100;
    CGFloat btn_edg  =(KSCREEN_W-btn_width*3)/4;
    for (int i=0; i<3; i++) {
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame=CGRectMake(btn_edg+(btn_width+btn_edg)*i, KTABBAR_HEIGHT/2-20, btn_width, 40);
        [sureBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        sureBtn.layer.cornerRadius=KCORNERRADIUS;
        sureBtn.layer.masksToBounds=YES;
        [sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.tag=SkimType+i;
        [bottomView addSubview:sureBtn];
    }
    self.bottomView=bottomView;
}

#pragma mark - MoreFZCToolBarDelegate
- (void)toolBarWithButton:(NSInteger)buttonTag
{
    //把tableview带到前面去
    UITableView *tableView=(UITableView *)[self selectdView:buttonTag];
    [self.clearMapView bringSubviewToFront:tableView];
    if (tableView.tag == MoreFZCToolBarTypeTravel) {
        if (![ZYGuideManager getGuideSkip]) {
            [self createSkipContextView];
        }
    } else if (tableView.tag == MoreFZCToolBarTypeRaiseMoney) {
        if (![ZYGuideManager getGuideChangeVoice]) {
            [self createChangeContextView];
        }
    }

    if (tableView.tag!=MoreFZCToolBarTypeRaiseMoney)
    {
        [tableView reloadData];
    }
    
    [self.view endEditing:YES];
}

#pragma mark - 自定义方法
/**
 *  重写返回键方法
 */
-(void)pressBack
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"直接退出,所有数据将清除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=ALERT_BACK_TAG;
    [alert show];
}

#pragma mark --- alertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==ALERT_BACK_TAG) {
        //保存数据
        if (buttonIndex ==1)
        {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            NSString *myDraftState=[user objectForKey:KMY_ZC_DRAFT_SAVE];
            //如果没有保存，则清空
            if (!myDraftState) {
                [ZYZCTool cleanZCDraftFile];
            }
            // 释放单例中存储的内容
            MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
            [manager initAllProperties];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    //数据上传到oss失败，提示重新上传
    else if (alertView.tag ==ALERT_UPLOAD_TAG)
    {
        //点击确定，重新上传数据到oss
        if (buttonIndex ==1) {
            [self uploadDataToOSS];
        }
    }
    else if (alertView.tag == ALERT_NO_WIFI_TAG)
    {
        if (buttonIndex==1) {
            //允许发布众筹
            [self doUploadDataOss];
        }
    }
    else if (alertView.tag ==  ALERT_PUBLISH)
    {
        if (buttonIndex==1) {
            //如果是编辑的草稿
            if (_editFromDraft) {
                //判断众筹项目时间是否有冲突
                MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
                NSString *httpUrl=JUDGE_MY_PRODUCT_TIME([ZYZCAccountTool getUserId],manager.goal_startDate,manager.goal_backDate);
                //            NSLog(@"%@",httpUrl);
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess)
                 {
                     [MBProgressHUD hideHUDForView:self.view];
                     //                 NSLog(@"%@",result);
                     if([result[@"data"] isEqual:@0])
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"旅行时间与已有行程时间冲突,请修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     else if([result[@"data"] isEqual:@1])
                     {
                         [self uploadDataToOSS];
                     }
                 } andFailBlock:^(id failResult) {
                     [MBProgressHUD hideHUDForView:self.view];
                     [MBProgressHUD showShortMessage:@"网络错误,发布失败"];
                 }];
            }
            else{
                [self uploadDataToOSS];
            }
        }
    }
}


#pragma mark --- 点击底部按钮触发事件
-(void)clickBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case SkimType:
            [self skimZhongchou];
            break;
        case NextType:
            [self nextOneOrPublish:self.toolBar.preClickBtn];
            break;
        default:
        case SaveType:
            //保存数据
            [self saveMyProduct];
            break;
    }
}

#pragma mark --- 浏览我的众筹
-(void)skimZhongchou
{
    UIButton *skimBtn=[self.bottomView viewWithTag:SkimType];
    skimBtn.enabled=NO;
    
    _oneModel=[[ZCOneModel alloc]init];
    _detailProductModel=[[ZCDetailProductModel alloc]init];
    __weak typeof (&*self)weakSelf=self;
    [FZCSaveDraftData saveDraftDataInOneModel:_oneModel andDetailProductModel:_detailProductModel andDoBlock:^{
        [weakSelf zcDraftDetail];
    }];
}

#pragma mark ---草稿详情
-(void)zcDraftDetail
{
    ZCDetailModel *detailModel=[[ZCDetailModel alloc]init];
    detailModel.detailProductModel=_detailProductModel;
    ZCProductDetailController *draftDetailVC=[[ZCProductDetailController alloc]init];
    draftDetailVC.detailModel=detailModel;
    draftDetailVC.schedule=_detailProductModel.schedule;
    draftDetailVC.detailProductType=SkimDetailProduct;
    [self.navigationController pushViewController:draftDetailVC animated:YES];

    UIButton *skimBtn=[self.bottomView viewWithTag:SkimType];
    skimBtn.enabled=YES;
}

#pragma mark --- 下一步或发布
-(void)nextOneOrPublish:(UIButton *)button
{
    NSInteger lossMessage=0;
    if (button.tag==MoreFZCToolBarTypeGoal) {
        lossMessage=[NecessoryAlertManager showNecessoryAlertView01];
    }
    else if (button.tag==MoreFZCToolBarTypeRaiseMoney)
    {
        lossMessage=[NecessoryAlertManager showNecessoryAlertView02];
    }
    else if (button.tag==MoreFZCToolBarTypeTravel)
    {
        lossMessage=[NecessoryAlertManager showNecessoryAlertView03];
    }
    else if (button.tag==MoreFZCToolBarTypeReturn)
    {
        lossMessage=[NecessoryAlertManager showNecessoryAlertView04];
    }
    
//    NSLog(@"%ld",lossMessage);
    
    UIButton *chooseButton=nil;
    
    if (lossMessage==1&&button.tag!=MoreFZCToolBarTypeGoal) {
        chooseButton=(UIButton *)[self.toolBar viewWithTag:MoreFZCToolBarTypeGoal];
    }
    else if(lossMessage==2&&button.tag!=MoreFZCToolBarTypeRaiseMoney)
    {
        chooseButton=(UIButton *)[self.toolBar viewWithTag:MoreFZCToolBarTypeRaiseMoney];
    }
    else if(lossMessage==3&&button.tag!=MoreFZCToolBarTypeTravel)
    {
        chooseButton=(UIButton *)[self.toolBar viewWithTag:MoreFZCToolBarTypeTravel];
    }
    else if(lossMessage==4&&button.tag!=MoreFZCToolBarTypeReturn)
    {
        chooseButton=(UIButton *)[self.toolBar viewWithTag:MoreFZCToolBarTypeReturn];
    }
    if (chooseButton) {
        [self.toolBar buttonClickAction:chooseButton];
    }
    //下一步
    if (button.tag<MoreFZCToolBarTypeReturn) {
        if (lossMessage>0) {
            return;
        }
        
        UIButton *btn=(UIButton *)[self.toolBar viewWithTag:(button.tag+1)];
        [self.toolBar buttonClickAction:btn];
        UIButton *nextBtn=(UIButton *)[self.bottomView viewWithTag:NextType];
        if (btn.tag==MoreFZCToolBarTypeReturn) {
            [nextBtn setTitle:@"发布" forState:UIControlStateNormal];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nextBtn.backgroundColor=[UIColor ZYZC_MainColor];
        }
    }
    //发  布
    else
    {
        if (button.tag==MoreFZCToolBarTypeReturn) {
            if (lossMessage>0) {
                return;
            }
        }
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"此行程发布后不可修改，是否确认发布？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=ALERT_PUBLISH;
        [alert show];
    }
}

-(void)judgeFirstTimeUpload
{
    BOOL firstTime=[ZYZCTool firstPublishOrSaveProduct];
    if (firstTime) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"数据上传过程会受到网速和文件大小影响，请耐心等待" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self uploadDataToOSS];
    }
}
#pragma mark --- 上传数据
//上传数据到oss
-(void)uploadDataToOSS
{
    [ZYZCTool getZCDraftFiles];
    //已上传数据到oss，
    if (_hasUpload) {
        [self publishMyZhongchou];
        return;
    }
    
    int networkType=[ZYZCTool getCurrentNetworkStatus];
    //无网络
    if (networkType==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"当前无网络" message:@"无法发布,请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=10;
        [alert show];
        return;
    }
    //无Wi-Fi
    else if(networkType!=5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"【流量使用提示】" message:@"当前网络无Wi-Fi,继续操作可能导致等待时间较长" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        alert.tag=ALERT_NO_WIFI_TAG;
        [alert show];
        return;
    }
    //有wifi
    [self doUploadDataOss];
}

#pragma mark --- 允许发布众筹
-(void)doUploadDataOss
{
//    //    监听网络状态
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChange:) name:@"NetworkChange"  object:nil];
    
    if (!_saveMyDraft) {
        
        _mbProgress=[MBProgressHUD showMessage:@"正在发布中..."];
    }
    else
    {
        _mbProgress=[MBProgressHUD showMessage:@"正在存储中..."];
    }
    
    _uploadSuccessNumber=0;
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *failDataFile=[user objectForKey:KFAIL_UPLOAD_OSS];
    //如果上次标记的失败文件没有删除，先删除掉
    if (failDataFile) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
            [ossManager deleteObjectsByPrefix:failDataFile andSuccessUpload:^
             {
                 [user setObject:nil forKey:KFAIL_UPLOAD_OSS];
                 [user synchronize];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self continueUploadDataToOss];
                 });
             }
            andFailUpload:^
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUD];
                     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"网络错误，请检查网络" message:nil delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                     [alertView show];
                 });
             }];
            
        });
    }
    else
    {
        [self continueUploadDataToOss];
    }
}

#pragma mark --- 上传新数据到oss
-(void)continueUploadDataToOss
{
    _myZhouChouMarkName=[ZYZCTool getLocalTime];
    
    //上传数据到oss,首先将远程文件标记为上传失败的文件，以免上传过程中意外退出导致部分文件留在oss上，文件上传成功将标记移除
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%@/%@",[ZYZCAccountTool getUserId],_myZhouChouMarkName] forKey:KFAIL_UPLOAD_OSS];
    [user synchronize];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString *tmpFile=[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0],KMY_ZHONGCHOU_FILE];
    
    NSArray *tmpFileArr=[fileManager subpathsAtPath:tmpFile];
    _uploadDataNumber=tmpFileArr.count;
    dispatch_async(dispatch_get_global_queue(0, 0), ^
       {
           for (int i=0; i<tmpFileArr.count; i++) {
               //文件上传到oss中以openId为文件名下的以_myZhouChouMarkName为文件名下
               ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
               BOOL uploadSuccess=[ossManager uploadObjectSyncByFileName:[NSString stringWithFormat:@"%@/%@",self.myZhouChouMarkName,tmpFileArr[i]]  andFilePath:[tmpFile stringByAppendingPathComponent:tmpFileArr[i]]];
               //单个文件上传失败
               if (!uploadSuccess) {
                   break;
               }
               //单个文件上传成功
               else
               {
                   _uploadSuccessNumber++;
                   //在主线程更行进度条
                   dispatch_async(dispatch_get_main_queue(), ^{
                       CGFloat successRate=0.0;
                       if (_uploadDataNumber) {
                          successRate=(float)_uploadSuccessNumber/(float)_uploadDataNumber*100.0;
                       }
                       _mbProgress.labelText=_saveMyDraft?
                       [NSString stringWithFormat:@"正在存储,已存储%.f％",successRate]:
                       [NSString stringWithFormat:@"正在发布,已完成%.f％",successRate];
                   });
               }
           }
           //回到主线程
           dispatch_async(dispatch_get_main_queue(), ^
          {
              _hasUpload=_uploadSuccessNumber>=_uploadDataNumber;
              //数据上传成功，发布众筹
              if (_hasUpload) {
                  [self publishMyZhongchou];
              }
              //上传失败，提示重新上传
              else
              {
                  [MBProgressHUD hideHUD];
                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络异常，发布失败，是否重新发布" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                  alert.tag=ALERT_UPLOAD_TAG;
                  [alert show];
              }
          });
       });
}

#pragma mark --- 发布我的众筹
-(void)publishMyZhongchou
{
    //将数据转化成上传数据对应的类型
    FZCReplaceDataKeys *replaceKeys=[[FZCReplaceDataKeys alloc]init];
    [replaceKeys replaceDataKeysBySubFileName:_myZhouChouMarkName];
    // 模型转字典
    NSDictionary *dataDict = [replaceKeys mj_keyValuesWithIgnoredKeys:@[@"myZhouChouMarkName"]];
    
    NSMutableDictionary *newParameters=[NSMutableDictionary dictionaryWithDictionary:dataDict];
    [newParameters addEntriesFromDictionary:@{@"productCountryId":@1}];

    if (_saveMyDraft) {
        [newParameters setObject:@0 forKey:@"status"];
    }
    if (_editFromDraft) {
        [newParameters setObject:_productId forKey:@"productId"];
    }
    _dataDic=newParameters;
    //从发众筹进入的发布／保存项目 //从草稿中进入的发布／保存项目
    [self publishHttpData];
}

#pragma mark --- 发布请求
-(void)publishHttpData
{
    DDLog(@"param:%@",[self turnJson:_dataDic]);
    
    NSString *httpUrl=_editFromDraft?UPDATA_PRODUCT:ADDPRODUCT;
//    NSLog(@"httpUrl:%@",httpUrl);
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:httpUrl  andParameters:_dataDic andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"result:%@",result);
        if (isSuccess) {
            //发送成功，删除本地数据
//            [self cleanTmpFile];
            [MBProgressHUD hideHUD];
            _saveMyDraft?
            //保存成功
            [MBProgressHUD showSuccess:@"保存成功!"]:
            //发布成功
            [self publishSuccessAlertShow];
            
             //将标记的失败文件置空，取消标记
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:nil forKey:KFAIL_UPLOAD_OSS];
            [user synchronize];
            
            MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
            [manager initAllProperties];
            
            _saveMyDraft?(_hasSaveProduct=YES):(_hasPulish=YES);
            [self.navigationController popViewControllerAnimated:YES];
            [ZYZCTool cleanZCDraftFile];
        }
        else
        {
            [MBProgressHUD hideHUD];
            _saveMyDraft?
            [MBProgressHUD showShortMessage:result[@"errorMsg"]]:
            [MBProgressHUD showShortMessage:result[@"errorMsg"]];
        }
        _saveMyDraft=NO;
    } andFailBlock:^(id failResult) {
//        NSLog(@"_dataDic:%@",_dataDic);
//        NSLog(@"failResult:%@",failResult);
        [MBProgressHUD hideHUD];
        //提示发布失败
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:_saveMyDraft? @"网络错误，保存失败":@"网络错误,发布失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.tag=ALERT_PUBLISH_TAG;
        [alert show];
        _saveMyDraft=NO;
    }];
}

#pragma mark --- 保存数据
-(void)saveMyProduct
{
    BOOL showAlert=[NecessoryAlertManager showNecessoryAlertView01];
    if (showAlert) {
         UIButton *chooseButton=(UIButton *)[self.toolBar viewWithTag:MoreFZCToolBarTypeGoal];
        if (self.toolBar.preClickBtn.tag!=MoreFZCToolBarTypeGoal) {
            [self.toolBar buttonClickAction:chooseButton];
        }
        return;
    }
    _saveMyDraft=YES;
    
    //上传数据
    [self uploadDataToOSS];
    
}

#pragma mark --- 弹出提示
-(void )publishSuccessAlertShow
{
    UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"发布成功" message:@"建议将这次行程转发到微信朋友圈，选择亲朋好友、同学同事一起出行更安全哦。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//#pragma mark --- 发布众筹／保存草稿时网络状态发生改变
//-(void)networkChange:(NSNotification *)notify
//{
//    NSNumber *number=notify.object;
    //无wifi状态
//    if (![number isEqual:@2]) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"【流量使用提示】" message:@"当前网络无Wi-Fi,继续发布可能会被运营商收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
//        alert.tag=ALERT_NETWORK_CHANGE_TAG;
//        [alert show];
//    }
//}

-(NSString *)turnJson:(id )dic
{
//    转换成json
        NSData *data = [NSJSONSerialization dataWithJSONObject :dic options : NSJSONWritingPrettyPrinted error:NULL];
    
        NSString *jsonStr = [[ NSString alloc ] initWithData :data encoding : NSUTF8StringEncoding];
    
    return jsonStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fzcVC_Show" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title=@"发起众筹";
    [self setBackItem];
}


-(void)dealloc
{
//    NSLog(@"dealloc:%@",self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
