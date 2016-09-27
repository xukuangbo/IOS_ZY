//
//  ComplainViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define imageHeight   300
#define COMPLAIN_PLACEHOLDER_TEXT  @"请在此记录对ta的不满，我们会第一时间处理。"
#import "ComplainViewController.h"
#import "WordEditViewController.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "AboutTousuVC.h"
@interface ComplainViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView           *textView;
@property (nonatomic, strong) UILabel        *placeHolderLab;

@end

@implementation ComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"投诉";
    [self configUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)configUI
{
    [self setBackItem];

    //卡片
    UIImageView  *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 64+KEDGE_DISTANCE, KSCREEN_W-2*KEDGE_DISTANCE, imageHeight)];
    bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    bgImg.userInteractionEnabled=YES;
    [self.view addSubview:bgImg];

    UIView *view=[[UIView alloc]init];
    [bgImg addSubview:view];
    //填写文字
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, bgImg.width-2*KEDGE_DISTANCE, bgImg.height-2*KEDGE_DISTANCE)];
    _textView.editable=NO;
    _textView.delegate=self;
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius=KCORNERRADIUS;
    _textView.layer.masksToBounds=YES;
    _textView.backgroundColor= [UIColor ZYZC_BgGrayColor01];
    _textView.contentInset = UIEdgeInsetsMake(-8, 0, 8, 0);
    [bgImg addSubview:_textView];
    
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 8, _textView.width, 20)];
    _placeHolderLab.text=COMPLAIN_PLACEHOLDER_TEXT;
    _placeHolderLab.font=[UIFont systemFontOfSize:15];
    _placeHolderLab.adjustsFontSizeToFitWidth=YES;
    _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor];
    [_textView addSubview:_placeHolderLab];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHappen:)];
    [_textView addGestureRecognizer:tap];
    
    //提交按钮
    CGFloat btnHeight=60;
    UIButton  *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KEDGE_DISTANCE, self.view.height-btnHeight-20, self.view.width-2*KEDGE_DISTANCE, btnHeight);
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"提交投诉" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [sureBtn addTarget:self action:@selector(commitComplain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame=CGRectMake(0, 0, 60, 44);
    [navRightBtn setTitle:@"投诉须知" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [navRightBtn addTarget:self action:@selector(learnComplaintNotes ) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
}

#pragma mark --- 投诉须知
-(void)learnComplaintNotes
{
    AboutTousuVC *aboutTousuVC=[[AboutTousuVC alloc]init];
    [self.navigationController pushViewController:aboutTousuVC animated:YES];
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


#pragma mark --- 提交投诉
-(void)commitComplain
{
    
    NSDictionary *param=@{@"userId"    :[ZYZCAccountTool getUserId],
                          @"productId" :_productId,
                          @"content"   :_textView.text,
                          @"type"      :_type,//1：一起游；2回报
                          @"role"      :_role //1：参与人投诉发起人；2发起人投诉参与人
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:COMPLAIN andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        [MBProgressHUD hideHUDForView:self.view];
//        NSLog(@"%@",result);
        if (isSuccess) {
            if (_complainSuccess) {
                _complainSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"提交成功"];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        
    } andFailBlock:^(id failResult)
    {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
//        NSLog(@"%@",failResult);
    }];
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
