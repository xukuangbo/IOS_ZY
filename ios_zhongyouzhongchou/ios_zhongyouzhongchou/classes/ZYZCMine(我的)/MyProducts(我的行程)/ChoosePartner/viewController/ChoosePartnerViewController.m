//
//  ChoosePartnerViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define TOGETHER_SUPPORT(rate,money)  [NSString stringWithFormat:@"一起去:支持%d％旅费(%.2f元)",rate,money]


#define LIMIT_TEXT(limitNum,totalNum) [NSString stringWithFormat:@"限额：%@位    |    已报名：%ld位",limitNum,totalNum]

#import "ChoosePartnerViewController.h"
#import "UserIconButton.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
@interface ChoosePartnerViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scroll;
@property (nonatomic, strong) UIImageView   *bgImg;
@property (nonatomic, strong) UILabel       *titlelab;
@property (nonatomic, strong) UILabel       *descLab;
@property (nonatomic, strong) UIButton      *moreTextBtn;
@property (nonatomic, assign) CGFloat       textNormalHeight;
@property (nonatomic, assign) CGFloat       textOpenHeight;
@property (nonatomic, strong) UILabel       *limitLab;
@property (nonatomic, strong) UIView        *usersView;
@property (nonatomic, assign) BOOL          isOpenText;
@property (nonatomic, strong) TogetherUersModel *togetherUersModel;

@property (nonatomic, strong) NSMutableArray *chooseArr;

@property (nonatomic, strong) NSMutableArray *NewChooseArr;
@end

@implementation ChoosePartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"选择同游";
    _chooseArr=[NSMutableArray array];
    _NewChooseArr=[NSMutableArray array];
    [self configUI];
    [self getHttpData];
    [self setBackItem];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)configUI
{
    _scroll=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scroll.delegate=self;
    _scroll.height=self.view.height-100;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scroll];
    
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE,_scroll.width-2*KEDGE_DISTANCE , 0)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    _bgImg.userInteractionEnabled=YES;
    [_scroll addSubview:_bgImg];
    
    //标题
    _titlelab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 20, _bgImg.width-2*KEDGE_DISTANCE, 30)];
    _titlelab.textColor=[UIColor redColor];
    _titlelab.font=[UIFont systemFontOfSize:18];
    [_bgImg addSubview:_titlelab];
    
    //描述
    _descLab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _titlelab.bottom+KEDGE_DISTANCE, _bgImg.width-40, 0)];
//    _descLab.backgroundColor=[UIColor orangeColor];
    _descLab.font=[UIFont systemFontOfSize:15];
    _descLab.numberOfLines=3;
    _descLab.textColor=[UIColor ZYZC_TextBlackColor];
    [_bgImg addSubview:_descLab];
    
    //添加点击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMoreText)];
    [_descLab addGestureRecognizer:tap];
    _descLab.userInteractionEnabled=YES;
    //限额人数
    _limitLab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0 , _bgImg.width-2*KEDGE_DISTANCE, 20)];
    _limitLab.font=[UIFont systemFontOfSize:15];
    _limitLab.textColor=[UIColor ZYZC_TextGrayColor01];
    [_bgImg addSubview:_limitLab];
    
    //支持一起游的人
    _usersView=[[UIView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _limitLab.bottom+KEDGE_DISTANCE, _bgImg.width-2*KEDGE_DISTANCE, 0)];
    [_bgImg addSubview:_usersView];
    
    CGFloat btnHeight=60;
    UIButton  *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KEDGE_DISTANCE, self.view.height-btnHeight-20, self.view.width-2*KEDGE_DISTANCE, btnHeight);
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"确定选择" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [sureBtn addTarget:self action:@selector(chooseMyPartner) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

#pragma mark ---获取数据
-(void)getHttpData
{
//    获取已报名参加一起游的信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *httpUrl=TOGTHER_INFO([ZYZCAccountTool getUserId], _productId);
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getStyle4Users"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        //        NSLog(@"%@",result);
        if (isSuccess) {
            TogetherUersModel  *togetherUersModel=[[TogetherUersModel alloc]mj_setKeyValues:result[@"data"]];
            self.togetherUersModel=togetherUersModel;
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getHttpData];
        }];
    }];
}

#pragma mark --- 更新数据
-(void)setTogetherUersModel:(TogetherUersModel *)togetherUersModel
{
    _togetherUersModel=togetherUersModel;
//    //==================临时数据=======================
//    _togetherUersModel.sumPeople=@4;
//    _togetherUersModel.people   =@1;
//    //================================================

    
    //已选择的人
    if (togetherUersModel.users.count) {
        for (UserModel *partnerModel in togetherUersModel.users) {
            if ([partnerModel.isSelect isEqual:@1]) {
                 [_chooseArr addObject:partnerModel.userId];
            }
        }
    }
    //标题
    int rate=togetherUersModel.sumPrice>0?(int)([togetherUersModel.price floatValue]/[togetherUersModel.sumPrice floatValue]*100.0):0;
    _titlelab.text=TOGETHER_SUPPORT(rate,[togetherUersModel.price floatValue]/100.0);
    
    //描述文字
    CGFloat textHeight=[ZYZCTool calculateStrByLineSpace:10.0 andString:ZYLocalizedString(@"support_together") andFont:[UIFont systemFontOfSize:15] andMaxWidth:_bgImg.width].height;
    _textOpenHeight=textHeight;
    if (textHeight>75) {
        _textNormalHeight=75;
        textHeight=75;
        //添加更多按钮
        _moreTextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _moreTextBtn.frame=CGRectMake(_bgImg.width-30, 120, 15, 10);
//        _moreTextBtn.backgroundColor=[UIColor redColor];
        [_moreTextBtn setTitle:@"..." forState:UIControlStateNormal];
        [_moreTextBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
        [_moreTextBtn addTarget:self action:@selector(openMoreText) forControlEvents:UIControlEventTouchUpInside];
        [_bgImg addSubview:_moreTextBtn];
    }
    _descLab.attributedText=[ZYZCTool setLineDistenceInText:ZYLocalizedString(@"support_together")];
    _descLab.height=textHeight;

    //限额
    _limitLab.text=LIMIT_TEXT(togetherUersModel.sumPeople,togetherUersModel.users.count);
    _limitLab.attributedText=[self changeSubStr01:[NSString stringWithFormat:@"%@",togetherUersModel.sumPeople] andSubStr02:[NSString stringWithFormat:@"%ld",togetherUersModel.users.count] fromString:_limitLab.text];
    
    //添加users到usersView上
    NSInteger num=6;
    CGFloat   edg=5;
    CGFloat   btnWidth=(_usersView.width-5*(num-1))/num;
    CGFloat   lastBtnBottom=0.0;
    for (int i=0; i<togetherUersModel.users.count; i++) {
        UserIconButton *btn=[[UserIconButton alloc]initWithFrame:CGRectMake((edg+btnWidth)*(i%num), (edg+btnWidth)*(i/num), btnWidth, btnWidth)];
        UserModel *partnerModel=togetherUersModel.users[i];
        btn.partnerModel=partnerModel;
        btn.isChoose=[partnerModel.isSelect isEqual:@1];
        btn.enabled =![partnerModel.isSelect isEqual:@1];
        [btn addTarget:self action:@selector(chooseOneUser:) forControlEvents:UIControlEventTouchUpInside];
        lastBtnBottom=btn.bottom;
        [_usersView addSubview:btn];
    }
    _usersView.height=lastBtnBottom;
    [self changeViewsFrame];
}

#pragma mark --- 选择某个人
-(void)chooseOneUser:(UserIconButton *)button
{
    if (!button.isChoose) {
        if (_chooseArr.count<8) {
            button.isChoose=YES;
            [_chooseArr addObject:button.partnerModel.userId];
            [_NewChooseArr addObject:button.partnerModel.userId];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView  alloc]initWithTitle:nil message:@"选择人数已达上限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        button.isChoose=NO;
        [_chooseArr removeObject:button.partnerModel.userId];
        [_NewChooseArr removeObject:button.partnerModel.userId];
    }
}

#pragma mark --- 改变视图位置
-(void)changeViewsFrame
{
    //改变_limitLab
    _limitLab.top =_descLab.bottom+20;
    //改变usersView
    _usersView.top=_limitLab.bottom+20;
    //改变_bgImg
    _bgImg.height=_usersView.bottom+20;
    //改变_scroll
    _scroll.contentSize=CGSizeMake(0, _bgImg.bottom+KEDGE_DISTANCE);

}

#pragma mark --- 展开／关闭文字
-(void)openMoreText
{
    _isOpenText=!_isOpenText;
    _moreTextBtn.hidden=_isOpenText;
    if (_isOpenText) {
        _descLab.height=_textOpenHeight;
        _descLab.numberOfLines=0;
        
    }
    else
    {
        _descLab.height=_textNormalHeight;
    }
    [self changeViewsFrame];
}



#pragma mark --- 选择一起游的人
-(void)chooseMyPartner
{
    NSString *mutStr=[_NewChooseArr componentsJoinedByString:@","];
//    NSLog(@"userIds:%@",mutStr);
    if (!_togetherUersModel.users.count) {
        [self.navigationController popViewControllerAnimated:YES];
//        [MBProgressHUD showError:@"暂时没有可供选择的人!"];
        return;
    }
    if (!mutStr.length) {
        [self.navigationController popViewControllerAnimated:YES];
//        [MBProgressHUD showError:@"选择同游人数为空，请选择"];
        return;
    }
    
    NSString *httpUrl=ADD_TOGETHER_PARTNER([ZYZCAccountTool getUserId],_productId,mutStr);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool getHttpDataByURL:httpUrl withSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        [MBProgressHUD hideHUDForView:self.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            if (_addPartnerSuccess) {
                _addPartnerSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
    } andFailBlock:^(id failResult)
    {
        [NetWorkManager showMBWithFailResult:failResult];
    }];
}

#pragma mark --- 改变文字样式
-(NSAttributedString *)changeSubStr01:(NSString *)subStr01 andSubStr02:(NSString *)subStr02 fromString:(NSString *)str
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range01=[str rangeOfString:subStr01];
    NSRange range02=[str rangeOfString:subStr02];

    if (range01.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:range01];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range01];
    }
    if (range02.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:range02];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range02];
    }
    
    return  attrStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
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
