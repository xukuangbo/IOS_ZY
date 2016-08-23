//
//  CommentUserViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define FIRST_STAR_TAG    30
#define PLACEHOLDER_TEXT  @"使用文字描述ta吧～"

#import "CommentUserViewController.h"
#import "ZCDetailCustomButton.h"
#import "WordEditViewController.h"
#import "ChooseStarView.h"
#import "MBProgressHUD+MJ.h"
#import "ComplainViewController.h"
#import "NetWorkManager.h"
@interface CommentUserViewController ()<UITextViewDelegate>
@property (nonatomic, strong) ZCDetailCustomButton  *iconImg;
@property (nonatomic, strong) UILabel               *nameLab;
@property (nonatomic, strong) UIImageView            *sexImg;
@property (nonatomic, strong) UILabel                *jobLab;
@property (nonatomic, strong) UITextView           *textView;
@property (nonatomic, strong) UILabel        *placeHolderLab;
@property (nonatomic, strong) UILabel               *starLab;
@property (nonatomic, strong) ChooseStarView  *firstStarView;

@property (nonatomic, strong) UIButton           *navRightBtn;

//@property (nonatomic, strong) ChooseStarView  *secondStarView;
//@property (nonatomic, strong) ChooseStarView  *thirdStarView;

@end

@implementation CommentUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"评价";
    [self setBackItem];
    [self configUI];
    [self reloadData];
}
-(void)configUI
{
    //投诉
    _navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _navRightBtn.frame=CGRectMake(0, 0, 50, 44);
//    [_navRightBtn setTitle:_hasComplain?@"已投诉":@"投诉" forState:UIControlStateNormal];
    [_navRightBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [_navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navRightBtn addTarget:self action:@selector(complain) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_navRightBtn];
    
    //卡片
    UIImageView  *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 64+KEDGE_DISTANCE, KSCREEN_W-2*KEDGE_DISTANCE, 0)];
    bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    bgImg.userInteractionEnabled=YES;
    [self.view addSubview:bgImg];
    
    //头像
    CGFloat iconImgWidth=60;
    _iconImg =[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, iconImgWidth, iconImgWidth)];
    _iconImg.layer.cornerRadius=KCORNERRADIUS;
    _iconImg.layer.masksToBounds=YES;
    _iconImg.layer.borderWidth=1;
    _iconImg.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
    [bgImg addSubview:_iconImg];
    
    //名字
    _nameLab =[[UILabel alloc] initWithFrame:CGRectMake(_iconImg.right+20, 15, 0, 20)];
    _nameLab.textColor=[UIColor ZYZC_TextBlackColor];
    _nameLab.font=[UIFont systemFontOfSize:17];
    [bgImg addSubview:_nameLab];
    
    //性别
    _sexImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, _nameLab.top, 20, 20)];
    [bgImg addSubview:_sexImg];
    
    //职业
    _jobLab=[[UILabel alloc]initWithFrame:CGRectMake(_iconImg.right+20, _nameLab.bottom+KEDGE_DISTANCE, bgImg.width-40-iconImgWidth, 20)];
    _jobLab.textColor=[UIColor ZYZC_TextGrayColor];
    _jobLab.font=[UIFont systemFontOfSize:16];
    [bgImg addSubview:_jobLab];
    
    _firstStarView=[[ChooseStarView alloc]initWithFrame:CGRectMake(0,  _iconImg.bottom+20,190, 30)];
    _firstStarView.centerX=bgImg.centerX;
    [bgImg addSubview:_firstStarView];
    
    
    _starLab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _firstStarView.bottom+KEDGE_DISTANCE, bgImg.width-2*KEDGE_DISTANCE, 20)];
    _starLab.font=[UIFont systemFontOfSize:17];
    _starLab.textAlignment=NSTextAlignmentCenter;
    _starLab.textColor=[UIColor ZYZC_TextBlackColor];
    [bgImg addSubview:_starLab];
    
    __weak typeof (&*self)weakSelf=self;
    _firstStarView.clickBlock=^(NSInteger num)
    {
        switch (num) {
            case 1:
                weakSelf.starLab.text=@"很差";
                break;
            case 2:
                weakSelf.starLab.text=@"差";
                break;
            case 3:
                weakSelf.starLab.text=@"一般";
                break;
            case 4:
                weakSelf.starLab.text=@"好";
                break;
            case 5:
                weakSelf.starLab.text=@"很好";
                break;
                
            default:
                break;
        }
    };
    
//    _secondStarView=[[ChooseStarView alloc]init];
//    _thirdStarView=[[ChooseStarView alloc]init];
    
//    NSArray  *starViews=@[_firstStarView,_secondStarView,_thirdStarView];
//    NSArray *title=@[@"性格沟通",@"旅行安排",@"时间观念"];
//    CGFloat height=30;
//    CGFloat edg=10;
//    CGFloat lastBottm=0.0;
//    for (int i=0 ; i<3; i++) {
//        UIView *starView=[[UIView alloc]initWithFrame:CGRectMake(0, _iconImg.bottom+20+(height+edg)*i, bgImg.width, height)];
//        [bgImg addSubview:starView];
//        lastBottm=starView.bottom;
//        
//        UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 2.5, 80, height)];
//        titlelab.font=[UIFont systemFontOfSize:16];
//        titlelab.text=title[i];
//        [starView addSubview:titlelab];
//        
//        ChooseStarView *chooseStarView=starViews[i];
//        chooseStarView.frame=CGRectMake(titlelab.right, 0, 190, height);
//        [starView addSubview:chooseStarView];
//    }
    
    
    //填写文字
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _starLab.bottom +20, bgImg.width-2*KEDGE_DISTANCE, 150)];
    _textView.editable=NO;
    _textView.delegate=self;
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius=KCORNERRADIUS;
    _textView.layer.masksToBounds=YES;
    _textView.backgroundColor= [UIColor ZYZC_BgGrayColor01];
    _textView.contentInset = UIEdgeInsetsMake(-8, 0, 8, 0);
    [bgImg addSubview:_textView];
    
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 8, _textView.width, 20)];
    _placeHolderLab.text=PLACEHOLDER_TEXT;
    _placeHolderLab.font=[UIFont systemFontOfSize:15];
    _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor];
    [_textView addSubview:_placeHolderLab];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHappen:)];
    [_textView addGestureRecognizer:tap];
    
    bgImg.height=_textView.bottom+KEDGE_DISTANCE;

    //提交按钮
    CGFloat btnHeight=60;
    UIButton  *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KEDGE_DISTANCE, self.view.height-btnHeight-20, self.view.width-2*KEDGE_DISTANCE, btnHeight);
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"提交评价" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [sureBtn addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

#pragma mark --- 更新数据
-(void)reloadData
{
    //加载头像
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:_userModel.faceImg] forState:UIControlStateNormal];
    _iconImg.userId=_userModel.userId;
    
    //名字
    _nameLab.text=_userModel.realName?_userModel.realName:_userModel.userName;
    
    CGFloat nameWidth=[ZYZCTool calculateStrLengthByText:_nameLab.text andFont:_nameLab.font andMaxWidth:KSCREEN_W].width;
    if (nameWidth>self.view.width-240) {
        nameWidth=self.view.width-220;
    }
    _nameLab.width=nameWidth;
    
    //性别
    if ([_userModel.sex isEqualToString:@"1"]) {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
    }
    else if ([_userModel.sex isEqualToString:@"2"])
    {
        _sexImg.image= [UIImage imageNamed:@"btn_sex_fem"];
    }
    _sexImg.left=_nameLab.right;
    
    //职业
    _jobLab.text=_userModel.department;
    
}

#pragma mark --- tap点击事件
-(void)tapHappen:(UITapGestureRecognizer *)tap
{
    WordEditViewController *wordEditVC=[[WordEditViewController alloc]init];
    wordEditVC.myTitle=@"文字描述";
    wordEditVC.preText=_textView.text;
    __weak typeof (&*self)weakSelf=self;
    wordEditVC.textBlock=^(NSString *textStr)
    {
        if (textStr.length) {
            weakSelf.placeHolderLab.hidden=YES;
        }
        else
        {
            weakSelf.placeHolderLab.hidden=NO;
            textStr=nil;
        }
        weakSelf.textView.text=textStr;
    };
    
    [self presentViewController:wordEditVC animated:YES completion:nil];
}

#pragma mark ---提交评价
-(void)commitComment
{
    if (_hasComment) {
        [MBProgressHUD showShortMessage:@"您已评价过，不可再次操作"];
        return;
    }
    
    NSNumber *userId=nil;
    NSString *myUserId=[ZYZCAccountTool getUserId];
    
    if (_firstStarView.star<=0) {
        [MBProgressHUD showError:ZYLocalizedString(@"loss_first_star")];
        return;
    }
    
    if (!_textView.text.length)
    {
        [MBProgressHUD showError:ZYLocalizedString(@"loss_content")];
        return;
    }
    
    NSString *httpUrl=nil;
    if (_commentType==CommentToghterPartner) {
        httpUrl=COMMENT_TOGETHER;
        userId=_userModel.userId;
    }
    else if (_commentType==CommentReturnPerson)
    {
        httpUrl=COMMENT_RETURN;
        userId=_userModel.userId;
    }
    else if (_commentType==CommentProductPerson)
    {
        httpUrl=COMMENT_MYJOIN_PRODUCT;
        userId=(NSNumber *)myUserId;
    }
    else if (_commentType==CommentMyReturnProduct)
    {
        httpUrl=COMMENT_MYRETURN_PRODUCT;
        userId=(NSNumber *)myUserId;
    }
    
    NSDictionary *param=@{@"productId":_productId,
                          @"userId":userId,
                          @"star":_firstStarView.star,
                          @"content":_textView.text
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:httpUrl andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            if (_finishComent) {
                _finishComent();
            }
            [MBProgressHUD showSuccess:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
    }];
}

#pragma mark --- 投诉
-(void)complain
{
    if (_hasComplain) {
        [MBProgressHUD showError:@"您已提交过投诉"];
        return;
    }
    NSNumber *type=nil;//1：一起游；2回报
    NSNumber *role=nil;//1：参与人投诉发起人；2发起人投诉参与人
    if (_commentType==CommentToghterPartner) {
        type =@1;
        role=@2;
    }
    else if (_commentType==CommentReturnPerson)
    {
        type=@2;
        role=@2;
    }
    else if (_commentType==CommentProductPerson)
    {
        type=@1;
        role=@1;
    }
    else if (_commentType==CommentMyReturnProduct)
    {
        type=@2;
        role=@1;
    }
    
    ComplainViewController *complainContriller=[[ComplainViewController alloc]init];
    complainContriller.productId=_productId;
    complainContriller.type=type;
    complainContriller.role=role;
    [self.navigationController pushViewController:complainContriller animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
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
