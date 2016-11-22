//
//  ZYPhoneLoginController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define TITLE_TEXT @"手机动态登录"
#define UNIT_HEIGHT  50

#import "ZYMobileLoginController.h"
#import "FinishBaseInfoController.h"

@interface ZYMobileLoginController ()<UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scroll;
//手机号
@property (nonatomic, strong) UITextField *textField;
//获取验证码按钮
@property (nonatomic, strong) UIButton    *codeBtn;
//输入验证码
@property (nonatomic, strong) UITextField *codeText;
//登录按钮
@property (nonatomic, strong) UIButton   *loginBtn;
//判断手机号是否正确的信息文字
@property (nonatomic, copy  ) NSString    *errorMessage;
//定时器
@property (nonatomic, strong) NSTimer     *timer;
//数秒
@property (nonatomic, assign) int         second;

@end

@implementation ZYMobileLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
    [self configUI];
}

-(void)configUI
{
    _scroll=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.delegate=self;
    _scroll.contentSize=CGSizeMake(0, self.view.height+1);
    [self.view addSubview:_scroll];
    
    UIImageView *topImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    topImg.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:topImg];
    
    //返回键
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(KEDGE_DISTANCE, 20, 40, 40) ;
    [backBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    titleLab.text=TITLE_TEXT;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor ZYZC_TextGrayColor];
    titleLab.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLab];
    
    //验证码获取界面
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, titleLab.bottom +10, self.view.width-2*KEDGE_DISTANCE, UNIT_HEIGHT*3)];
    bgImg.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    bgImg.userInteractionEnabled=YES;
    [_scroll addSubview:bgImg];
    
        //第一栏
    UILabel *firstLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgImg.width, UNIT_HEIGHT)];
    firstLab.text=@"+86 中国";
    firstLab.textAlignment=NSTextAlignmentCenter;
    firstLab.textColor=[UIColor ZYZC_TextGrayColor];
    [bgImg addSubview:firstLab];
    
    [firstLab addTarget:self action:@selector(enterChoose)];
    
    UIImageView *firstImg=[[UIImageView alloc]initWithFrame:CGRectMake(firstLab.width-10-KEDGE_DISTANCE, (firstLab.height-18)/2, 10,18)];
    firstImg.image=[UIImage imageNamed:@"btn_rightin"];
    [firstLab addSubview:firstImg];
    firstImg.hidden=YES;
    
    [bgImg addSubview:[UIView lineViewWithFrame:CGRectMake(0, UNIT_HEIGHT, bgImg.width, 0.5) andColor:[UIColor ZYZC_BgGrayColor02]]];
    
    //第二栏
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, UNIT_HEIGHT+KEDGE_DISTANCE,bgImg.width-2*KEDGE_DISTANCE,UNIT_HEIGHT-2*KEDGE_DISTANCE)];
    _textField.borderStyle=UITextBorderStyleNone;
    _textField.placeholder=@"手机号码";
    _textField.delegate=self;
    _textField.keyboardType=UIKeyboardTypeNumberPad;
    _textField.clearButtonMode= UITextFieldViewModeWhileEditing;
    _textField.tintColor=[UIColor ZYZC_MainColor];
    [bgImg addSubview:_textField];
    
    [bgImg addSubview:[UIView lineViewWithFrame:CGRectMake(0, 2*UNIT_HEIGHT, bgImg.width, 0.5) andColor:[UIColor ZYZC_BgGrayColor02]]];
    
    //第三栏
    _codeText=[[UITextField alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 2*UNIT_HEIGHT+KEDGE_DISTANCE, 100, UNIT_HEIGHT-2*KEDGE_DISTANCE)];
    _codeText.placeholder=@"输入验证码";
    _codeText.borderStyle=UITextBorderStyleNone;
    _codeText.keyboardType=UIKeyboardTypeNumberPad;
    _codeText.tintColor=[UIColor ZYZC_MainColor];
     _codeText.clearButtonMode= UITextFieldViewModeWhileEditing;
    [bgImg addSubview:_codeText];
    
    CGFloat btn_width=100;
    _codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame=CGRectMake(bgImg.width-btn_width-KEDGE_DISTANCE, 2*UNIT_HEIGHT+KEDGE_DISTANCE, btn_width, UNIT_HEIGHT-2*KEDGE_DISTANCE);
    [self normalCodeBtn];
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    _codeBtn.layer.cornerRadius=KCORNERRADIUS;
    _codeBtn.layer.masksToBounds=YES;
    [_codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:_codeBtn];
    
    //登录按钮
    CGFloat loginBtn_height=50;
    _loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame =CGRectMake(KEDGE_DISTANCE, bgImg.bottom+30, self.view.width-2*KEDGE_DISTANCE, loginBtn_height);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.backgroundColor=[UIColor whiteColor];
    [_loginBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font= [UIFont boldSystemFontOfSize:24];
    _loginBtn.layer.cornerRadius=KCORNERRADIUS;
    _loginBtn.layer.masksToBounds=YES;
    [_loginBtn addTarget:self action:@selector(login)];
    [_scroll addSubview:_loginBtn];
    
    _loginBtn.enabled=NO;
    
    //监听文本改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [_textField becomeFirstResponder];
}

#pragma mark --- 文本改变
-(void)textChange:(NSNotification *)notify
{
    if (notify.object==_textField) {
        BOOL phoneMatch=[self validateInput:_textField];
        if (phoneMatch)
        {
            [self prepareGetCodeBtn];
        }
        else
        {
            [self normalCodeBtn];
        }
    }
    else if(notify.object==_codeText)
    {
        if (_codeText.text.length==6) {
            _loginBtn.enabled=YES;
            _loginBtn.backgroundColor=[UIColor ZYZC_MainColor];
            [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
        else
        {
            _loginBtn.enabled=NO;
            _loginBtn.backgroundColor=[UIColor whiteColor];
            [_loginBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark --- scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark --- 一般状态的发送验证码按钮
-(void)normalCodeBtn
{
    _codeBtn.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
}

#pragma mark --- 准备发送验证码按钮
-(void)prepareGetCodeBtn
{
    _codeBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark --- 返回
-(void)back
{
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 选择区号
-(void)enterChoose
{
    [self.view endEditing:YES];
    
}

#pragma mark --- 获取验证码
-(void)getCode
{
    _codeBtn.enabled=NO;
    
    [_codeText becomeFirstResponder];
    
    //验证手机号是否正确
    BOOL phoneMatch=[self validateInput:_textField];
    if (!phoneMatch) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:nil message:self.errorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _codeBtn.enabled=YES;
        return;
    }
    //定时器开始倒计时
    [self getTimer];
    
//    NSLog(@"%@",GET_PHONE_CODE(_textField.text));
//    NSString *url=[NSString stringWithFormat:@"%@mobileAPI/sendLoginCode.action?mobile=%@",BASE_URL,mobile];
    
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"get_mobile_code"];
    NSDictionary *parameter=@{@"mobile":_textField.text};
    //获取验证码
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSLog(@"result：%@",result);
        if (isSuccess) {
            
        }
        else
        {
            [MBProgressHUD showError:result[@"errorMsg"]];
            [self prepareGetCodeBtn];
            //停掉定时器
            [_timer invalidate];
            _timer = nil;
            _codeBtn.enabled = YES;
        }
    } andFailBlock:^(id failResult) {
        NSLog(@"failResult：%@",failResult);
        [MBProgressHUD showError:@"网络错误,获取失败"];
        [self prepareGetCodeBtn];
        //停掉定时器
        [_timer invalidate];
        _timer = nil;
        _codeBtn.enabled = YES;
    }];
}

#pragma mark --- 登录
-(void)login
{
    [self.view endEditing:YES];
    
//    NSString *url=[NSString stringWithFormat:@"%@mobileAPI/loginByCode.action?mobile=%@&code=%@",BASE_URL,mobile,code]
    NSString *url= [[ZYZCAPIGenerate sharedInstance] API:@"login_by_mobileCode"];
    NSDictionary *parameter=@{@"mobile":_textField.text,
                              @"code":_codeText.text
                              };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //验证码登录
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess)
    {
        DDLog(@"%@",result);
        [MBProgressHUD hideHUDForView:self.view];
        if (isSuccess) {
            //如果没有用户信息，填写用户信息
            //主要保存scr
            ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"][@"user"] ];
            [ZYZCAccountTool saveAccount:accountModel];
            
            if ([result[@"data"][@"setinfo"] isEqual:@1]) {
                FinishBaseInfoController *baseInfoController=[[FinishBaseInfoController alloc]init];
                baseInfoController.userId=result[@"data"][@"user"][@"userId"];
                [self presentViewController:baseInfoController animated:YES completion:nil];
            }
            else if([result[@"data"][@"setinfo"] isEqual:@0])
            {
                //如果已有用户信息，则保存用户信息到本地
                ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"][@"user"] ];
                //标记从手机登陆
                accountModel.loginType=From_Mobile;
                [ZYZCAccountTool saveAccount:accountModel];
                //回到首页
                __weak typeof (&*self)weakSelf=self;
                [self dismissViewControllerAnimated:NO completion:^{
                    [weakSelf getRootViewController];
                }];
            }
        }
        else
        {
            [MBProgressHUD showShortMessage:result[@"errorMsg"]];
        }
    }
    andFailBlock:^(id failResult)
    {
        DDLog(@"%@",failResult);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showShortMessage:@"网络错误,登录失败"];
    }];
}


#pragma mark - 获取倒计时定时器
-(void)getTimer{
    
    _second=60;
    [self normalCodeBtn];
    [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重试",_second] forState:UIControlStateNormal];
    
    if (_timer==nil) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    }
}

#pragma mark --- 倒计时
-(void)countdown
{
    if (_second > 1)
    {
        _second--;
        [self normalCodeBtn];
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重试",_second] forState:UIControlStateNormal];
        
    }
    else
    {
        [self prepareGetCodeBtn];
        [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        //停掉定时器
        [_timer invalidate];
        _timer = nil;
        _codeBtn.enabled = YES;
    }
}

#pragma mark --- 判断手机号是否正确
-(BOOL)validateInput:(UITextField *)input{
    if (input.text.length <= 0) {
        self.errorMessage = @"手机号码不能为空";
    }else{
        NSString *phoneRegex = @"^(0|86|17951)?1(3|5|7|8|4)[0-9]{9}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL isMatch = [phoneTest evaluateWithObject:input.text];
        if (isMatch) {
            self.errorMessage = nil;
        }else{
            self.errorMessage = @"手机号码不符合规范";
        }
    }
    return self.errorMessage == nil ? YES : NO;
}

#pragma mark --- 设置根控制器
-(void)getRootViewController
{
    UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZYZCTabBarController *mainTab=[storyboard instantiateViewControllerWithIdentifier:@"ZYZCTabBarController"];
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController=mainTab;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];

}

-(void)dealloc
{
//    NSLog(@"delloc:%@",self.class);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
