//
//  ZYZCMsgDetailViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCMsgDetailViewController.h"
#import "ZYDetailMsgScrollView.h"
#import "NetWorkManager.h"
#import "MBProgressHUD+MJ.h"
#import "MsgDetailModel.h"
#import "MyProductViewController.h"
#import "MyReturnViewController.h"

@interface ZYZCMsgDetailViewController ()
@property (nonatomic, strong) UIView      *topView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel     *titleLab;
@property (nonatomic, strong) UILabel     *subTitleLab;
@property (nonatomic, strong) UILabel     *alertLab;
@property (nonatomic, strong) ZYDetailMsgScrollView *msgScroll;
@property (nonatomic, strong) MsgDetailModel        *msgDetailModel;
@end

@implementation ZYZCMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"通知";
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self getHttpData];
}


#pragma mark --- 获取明细数据
-(void)getHttpData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Post_Detail_Msg andParameters:@{@"id":[NSNumber numberWithInteger:_msgListModel.ID],
                        @"productId":_msgListModel.productId
                        }
    andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         DDLog(@"result:%@",result);
         [MBProgressHUD hideHUDForView:self.view];
         [NetWorkManager hideFailViewForView:self.view];
         if (isSuccess) {
            _msgDetailModel=[[MsgDetailModel alloc]mj_setKeyValues:result[@"data"]];
            [self configUI];
         }
         else
         {
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
         }
     }
     andFailBlock:^(id failResult)
     {
         DDLog(@"failResult:%@",failResult);
         [MBProgressHUD hideHUDForView:self.view];
         [NetWorkManager hideFailViewForView:self.view];
         [NetWorkManager showMBWithFailResult:failResult];
         __weak typeof (&*self)weakSelf=self;
         [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
             [weakSelf getHttpData];
         }];
     }];
}

#pragma mark --- 创建控件
-(void)configUI
{
    
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_W, 0)];
    [_topView addTarget:self action:@selector(enterProduct)];
    [self.view addSubview:_topView];
    
    //icon
    CGFloat  icon_width=60;
    _icon= [[UIImageView alloc]initWithFrame:CGRectMake(20, KEDGE_DISTANCE, icon_width, icon_width)];
    _icon.layer.cornerRadius=KCORNERRADIUS;
    _icon.layer.masksToBounds=YES;
    [_topView addSubview:_icon];
    
    //title
    _titleLab=[self createLabWithFrame:CGRectMake(_icon.right+KEDGE_DISTANCE, KEDGE_DISTANCE, KSCREEN_W-_icon.right-20, 20) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [_topView addSubview:_titleLab];
    
    //subTitle;
    _subTitleLab=[self createLabWithFrame:CGRectMake(_titleLab.left, _titleLab.bottom+10, KSCREEN_W-_icon.right-20, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [_topView addSubview:_subTitleLab];

    [self getMsgData];
    
}

-(void)getMsgData
{
    if (_msgListModel.icon) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:_msgListModel.icon] placeholderImage:[UIImage imageNamed:@"众筹ICON"]];
    }
    else
    {
        if (_msgListModel.msgStyle==99) {
            _icon.image=[UIImage imageNamed:@"Share_iocn"];
        }
        else
        {
            _icon.image=[UIImage imageNamed:@"众筹ICON"];
        }
    }
    
    //title
    _titleLab.text=_msgListModel.title;
     _titleLab.numberOfLines=0;
    CGFloat titleHeight=[ZYZCTool calculateStrLengthByText:_titleLab.text andFont:_titleLab.font andMaxWidth:_titleLab.width].height;
    if (titleHeight >_titleLab.height) {
        _titleLab.height=titleHeight;
    }
    
    //subtitle
     _subTitleLab.top=_titleLab.bottom+10;
    _subTitleLab.text=_msgListModel.subtitle;
    _subTitleLab.numberOfLines=0;
     CGFloat subTitleHeight=[ZYZCTool calculateStrLengthByText:_subTitleLab.text andFont:_subTitleLab.font andMaxWidth:_subTitleLab.width].height;
    if (subTitleHeight >_subTitleLab.height) {
        _subTitleLab.height=subTitleHeight;
    }
    
    //进一步操作的提示文字
//    _msgDetailModel.topMsg=@"我得到的点点滴滴";
    if (_msgDetailModel.stepoption.length>0&&![_msgDetailModel.stepoption isEqualToString:@"null"]) {
        _alertLab=[self createLabWithFrame:CGRectMake(_titleLab.left, MAX(_icon.bottom+10, _subTitleLab.bottom+10), KSCREEN_W-_icon.right-50, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextGrayColor]];
        [_topView addSubview:_alertLab];
        _alertLab.text=_msgDetailModel.stepoption;
        
        UIImageView *alertImg=[[UIImageView alloc]initWithFrame:CGRectMake(KSCREEN_W-30, _alertLab.top, 11.25, 20)];
        alertImg.image=[UIImage imageNamed:@"btn_rightin"];
        [_topView addSubview:alertImg];
    }

    //分割线
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, _alertLab?_alertLab.bottom+20:MAX(_icon.bottom+10, _subTitleLab.bottom+10), KSCREEN_W-2*KEDGE_DISTANCE, 1.0) andColor:nil];
    [_topView addSubview:lineView];
    
    _topView.height=lineView.bottom;
    
    
    //详细信息
    _msgScroll=[[ZYDetailMsgScrollView alloc]initWithFrame:CGRectMake(0, _topView.bottom, self.view.width, KSCREEN_H-_topView.bottom) andDetailMsg:_msgDetailModel];
    [self.view addSubview:_msgScroll];
}

#pragma mark --- 进入项目
-(void)enterProduct
{
    //我发布，我参与
    if (_msgListModel.msgStyle==1||_msgListModel.msgStyle==2) {
        MyProductViewController *myTravelVC=[[MyProductViewController alloc]init];
        myTravelVC.hidesBottomBarWhenPushed=YES;
        myTravelVC.myProductType=_msgListModel.msgStyle;
        [self.navigationController pushViewController:myTravelVC animated:YES];
    }
    //我回报
    else if(_msgListModel.msgStyle==3)
    {
        MyReturnViewController *returnViewController=[[MyReturnViewController alloc]init];
        returnViewController.productType=MyReturnProduct;
        returnViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:returnViewController animated:YES];
    }
}


#pragma mark --- 创建lab
-(UILabel *)createLabWithFrame:(CGRect )frame andFont:(UIFont *)font andTitleColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=font;
    lab.textColor=color;
    return lab;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor ZYZC_TextBlackColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.navigationItem.leftBarButtonItem=[self customItemByImgName:@"back_black" andAction:@selector(pressBack)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];
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
