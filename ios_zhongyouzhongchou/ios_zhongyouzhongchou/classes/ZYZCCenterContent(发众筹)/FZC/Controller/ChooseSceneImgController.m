//
//  ChooseSceneImgController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define BTN_LINE_TAG  100
#define BTN_FIRST_TAG 1000

#import "ChooseSceneImgController.h"
#import "SelectImageViewController.h"
#import "ZYChooseNetImgTable.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
@interface ChooseSceneImgController ()
@property (nonatomic, strong) ZYChooseNetImgTable *table;
@property (nonatomic, strong) UIButton            *scrollTop;
@property (nonatomic, strong) NSMutableArray      *listArr;
@property (nonatomic, assign) NSInteger           pageNo;
@property (nonatomic, strong) UIView              *topView;
@property (nonatomic, strong) UIScrollView        *goalsView;
@property (nonatomic, strong) UIButton            *preClickBtn;
@property (nonatomic, assign) CGFloat             preBtnX;
@property (nonatomic, strong) NSNumber            *contentViewId;
@property (nonatomic, strong) UIView              *bottomView;
@property (nonatomic, strong) UIButton            *sureBtn;
@property (nonatomic, assign) BOOL                hasNoneData;
@property (nonatomic, strong) ZYImageModel        *imgModel;
@end

@implementation ChooseSceneImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"众游图库";
    self.automaticallyAdjustsScrollViewInsets=NO;
    _pageNo=1;
    _listArr=[NSMutableArray array];
    [self setBackItem];
    [self configUI];
}

-(void)configUI
{
    _table=[[ZYChooseNetImgTable alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_table];
    
    //创建置顶按钮
    _scrollTop=[UIButton buttonWithType:UIButtonTypeCustom];
    _scrollTop.layer.cornerRadius=KCORNERRADIUS;
    _scrollTop.layer.masksToBounds=YES;
    _scrollTop.frame=CGRectMake(KSCREEN_W-60,KSCREEN_H-59-55,50,50);
    [_scrollTop setImage:[UIImage imageNamed:@"回到顶部"] forState:UIControlStateNormal];
    
    [_scrollTop addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    _scrollTop.hidden=YES;
    [self.view addSubview:_scrollTop];
    
    //目的地栏
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_W, 40)];
    _topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_topView];
    
    
    //确定按钮
    [self createBottomView];
   
    _goalsView=[[UIScrollView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, _topView.height)];
    _goalsView.backgroundColor=[UIColor whiteColor];
    _goalsView.showsHorizontalScrollIndicator=NO;
    [_topView addSubview:_goalsView];
    
    
    [self getDestData];
    
    __weak typeof (&*self)weakSelf=self;
    _table.headerRefreshingBlock=^()
    {
        weakSelf.pageNo=1;
        [weakSelf getHttpDataByViewIds:weakSelf.contentViewId];
        _imgModel=nil;
        [weakSelf.sureBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        weakSelf.sureBtn.backgroundColor=[UIColor ZYZC_BgGrayColor];
    };
    
    _table.footerRefreshingBlock=^()
    {
        weakSelf.pageNo++;
        [weakSelf getHttpDataByViewIds:weakSelf.contentViewId];
    };

    _table.scrollDidScrollBlock=^(CGFloat offSetY)
    {
        if (offSetY>=1000.0) {
            weakSelf.scrollTop.hidden=NO;
        }
        else
        {
            weakSelf.scrollTop.hidden=YES;
        }
    };
    
    _table.scrollUpBlock=^(CGFloat contentY)
    {
        if (contentY>40) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.topView.top=0;
                weakSelf.bottomView.top=KSCREEN_H;
            }];
        }
    };
    
    _table.scrollDownBlock=^(CGFloat contentY)
    {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.topView.top=64;
            weakSelf.bottomView.top= KSCREEN_H-KTABBAR_HEIGHT;
        }];
    };
    
    _table.scrollEndBlock=^(CGFloat contentY)
    {
        if (weakSelf.hasNoneData) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.topView.top=64;
                weakSelf.bottomView.top= KSCREEN_H-KTABBAR_HEIGHT;
            }];
        }
    };
    
    _table.chooseImgBlock=^(ZYImageModel *imgModel)
    {
        [weakSelf.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        weakSelf.sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
        weakSelf.imgModel=imgModel;
    };
}

#pragma mark ---  创建底部按钮
-(void)createBottomView
{
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, KSCREEN_H-KTABBAR_HEIGHT , KSCREEN_W, KTABBAR_HEIGHT)];
    _bottomView.backgroundColor=[UIColor ZYZC_BgGrayColor];
//    _bottomView.alpha=0.95;
    [self.view addSubview:_bottomView];
    
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KSCREEN_W/2-50, KTABBAR_HEIGHT/2-20, 100, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    sureBtn.backgroundColor=[UIColor ZYZC_BgGrayColor];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn addTarget:self action:@selector(clickBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:sureBtn];
    _sureBtn=sureBtn;
    
    [_bottomView addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]]];
}


#pragma mark --- 确定选择
-(void)clickBottomBtn
{
    if (_imgModel) {
        MoreFZCDataManager *dataManager=[MoreFZCDataManager sharedMoreFZCDataManager];
        dataManager.goal_travelThemeImgUrl=_imgModel.imgMin;
        [self.navigationController popViewControllerAnimated:YES];
        if (_chooseImageBolck) {
            _chooseImageBolck(_imgModel.imgMin);
        }
    }
}

-(void)getDestData
{
    _preBtnX=0;
    //添加目的地试图到_goalsView
    CGFloat step=30;
    for (int i=0; i<_views.count; i++) {
        UIButton *btn = [self setButton:i withTitle:_views[i]];
        [_goalsView addSubview:btn];
        _preBtnX=btn.right+step;
    }
    
    if (_preBtnX-step>_goalsView.width) {
        _goalsView.contentSize=CGSizeMake(_preBtnX-step, 0);
    }
    else
    {
        _goalsView.contentOffset=CGPointMake(-(_goalsView.width-_preBtnX+step)/2, 0);
    }
    
    //初始化后点击第一个目的地
    if (!_preClickBtn) {
        UIButton *btn=(UIButton *)[_goalsView viewWithTag:BTN_FIRST_TAG];
        [self changeView:btn];
    }
}

#pragma mark --- 创建目的地btn
- (UIButton *)setButton:(NSInteger)index withTitle:(NSString *)title
{
    UIFont *font=[UIFont  systemFontOfSize:17];
    
    CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:title andFont:font andMaxWidth:KSCREEN_W].width;
    
    CGFloat buttonW = titleWidth+10;
    CGFloat buttonH = _goalsView.height-KEDGE_DISTANCE;
    CGFloat buttonX = _preBtnX;
    CGFloat buttonY = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=font;
    button.tag = index+BTN_FIRST_TAG;
    [button addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    
    //给btn添加下划线
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, button.height-2, button.width, 2) andColor:[UIColor ZYZC_MainColor]];
    lineView.tag=BTN_LINE_TAG;
    lineView.hidden=YES;
    [button addSubview:lineView];
    [self getButtonNormalState:button];
    
    return button;
}

#pragma mark --- 改变目的地
-(void)changeView:(UIButton *)button
{
    _imgModel=nil;
    [_sureBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    _sureBtn.backgroundColor=[UIColor ZYZC_BgGrayColor];

    [self getButtonHeightState:button];
    
    if (_preClickBtn&&_preClickBtn!=button) {
        [self getButtonNormalState:_preClickBtn];
    }
    _preClickBtn=button;
    
    //获取数据
    [self getHttpDataByViewIds:_viewIds[button.tag-BTN_FIRST_TAG]];
}


#pragma mark --- 置顶
-(void)scrollToTop
{
    [_table setContentOffset:CGPointMake(0, -(64+40)) animated:YES];
}


#pragma mark --- 获取数据
-(void)getHttpDataByViewIds:(NSNumber *)viewId
{
    _contentViewId=viewId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:NO andURL:Post_GetNetImg andParameters:@{@"viewspotId":@"566",
          @"pageSize":@"20",
          @"pageNo":[NSNumber numberWithInteger:_pageNo]
        }
    andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        [MBProgressHUD hideHUDForView:self.view ];
        [NetWorkManager hideFailViewForView:self.view];
        if (isSuccess) {
            if (_pageNo==1&&_listArr.count) {
                [_listArr removeAllObjects];
            }
            
            ListImgModel *listImgModel=[[ListImgModel alloc]mj_setKeyValues:result];
            for(ZYImageModel *imageModel in listImgModel.data)
            {
                [_listArr addObject:imageModel];
            }
            
            if (listImgModel.data.count==0) {
                _pageNo--;
                _hasNoneData=YES;
                MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_table.mj_footer ;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateIdle];
            }
            else
            {
                _hasNoneData=NO;
                MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_table.mj_footer ;
                [autoFooter setTitle:@"" forState:MJRefreshStateIdle];
            }
            
            _table.dataArr=_listArr;
            
            [_table reloadData];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        
    } andFailBlock:^(id failResult) {
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [MBProgressHUD  hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpDataByViewIds:weakSelf.contentViewId];
        }];
    }];
}

#pragma mark --- buttonNormalState
-(void)getButtonNormalState:(UIButton *)button
{
    [button setTitleColor:[UIColor ZYZC_TextGrayColor04] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor whiteColor];
    
    UIView *lineView=[button viewWithTag:BTN_LINE_TAG];
    lineView.hidden=YES;
}

#pragma mark --- buttonHeightState
-(void)getButtonHeightState:(UIButton *)button
{
    [button setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor whiteColor];
    
    UIView *lineView=[button viewWithTag:BTN_LINE_TAG];
    lineView.hidden=NO;
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
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
