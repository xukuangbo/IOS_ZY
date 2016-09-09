//
//  LoginJudgeController.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/30.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "LoginJudgeController.h"
#import "WXApiManager.h"
#import "ZYZCTabBarController.h"
#import "ZYZCAccountTool.h"
#import "WXApi.h"
#import "TTTAttributedLabel.h"
#import <CoreLocation/CoreLocation.h>
#import "ZYMobileLoginController.h"
#import "LoginJudgeTool.h"
#import "AboutXieyiVC.h"
#import "AboutYinsiVC.h"
#import "MBProgressHUD+MJ.h"
@interface LoginJudgeController ()<WXApiManagerDelegate,CLLocationManagerDelegate,TTTAttributedLabelDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *wxLoginButton;
@property (nonatomic, strong) UIButton *phoneLogin;
@property (nonatomic, strong) UILabel *tsLabel;
@property (nonatomic, strong) TTTAttributedLabel *txLabel;
/**
 *  当地位置管理者
 */
@property(strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LoginJudgeController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self configUI];
        
        [self getLocation];
        
        if (![WXApi isWXAppInstalled] ||![WXApi isWXAppSupportApi]) {
            //如果没有安装微信，则显示
            _wxLoginButton.hidden = YES;
        }else{
            
            _wxLoginButton.hidden = NO;
        }
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

//在viewWillDisappear关闭定位
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark ---configUI
- (void)configUI
{
    //创建一个imageview。
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _bgImageView.image=[UIImage imageNamed:@"loginback"];
    
    [self.view addSubview:_bgImageView];
    
    //添加一个手机登录按钮
    CGFloat phoneLoginX = KEDGE_DISTANCE;
    CGFloat phoneLoginY = 0;
    CGFloat phoneLoginW = KSCREEN_W - 2 * KEDGE_DISTANCE;
    CGFloat phoneLoginH = 52;
    _phoneLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneLogin.frame = CGRectMake(phoneLoginX, phoneLoginY, phoneLoginW, phoneLoginH);
    _phoneLogin.bottom = KSCREEN_H - 70 * KCOFFICIEMNT;
    
    _phoneLogin.layer.cornerRadius = 5;
    _phoneLogin.layer.masksToBounds = YES;
    _phoneLogin.backgroundColor = [UIColor colorWithRed:5 / 256.0 green:184 / 256.0 blue:178 / 256.0 alpha:1];
    [_phoneLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_phoneLogin addTarget:self action:@selector(phoneLoginAction)];
    [_phoneLogin setTitle:@"手机动态登录" forState:UIControlStateNormal];
    [self.view addSubview:_phoneLogin];
    
    //添加一个按钮
    CGFloat wxLoginButtonX = KEDGE_DISTANCE;
    CGFloat wxLoginButtonY = 0;
    CGFloat wxLoginButtonW = KSCREEN_W - 2 * KEDGE_DISTANCE;
    CGFloat wxLoginButtonH = 52;
    _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxLoginButton.frame = CGRectMake(wxLoginButtonX, wxLoginButtonY, wxLoginButtonW, wxLoginButtonH);
    _wxLoginButton.bottom = _phoneLogin.top - 20;
    
    _wxLoginButton.layer.cornerRadius = 5;
    _wxLoginButton.layer.masksToBounds = YES;
    [_wxLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _wxLoginButton.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    _wxLoginButton.backgroundColor = [UIColor colorWithRed:39 / 256.0 green:211 / 256.0 blue:186 / 256.0 alpha:1];
    [_wxLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [_wxLoginButton addTarget:self action:@selector(wxLoginButtonAction)];
    [self.view addSubview:_wxLoginButton];
    
    /**
     *  创建一个属性文本
     */
    [self createAttrbuteLabel];
    
    [WXApiManager sharedManager].delegate = self;
}


- (void)createAttrbuteLabel
{
    _txLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _txLabel.size = CGSizeMake(KSCREEN_W - 2 * KEDGE_DISTANCE, 20);
    _txLabel.left = KEDGE_DISTANCE;
    _txLabel.bottom = KSCREEN_H - 20 * KCOFFICIEMNT;
    _txLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _txLabel.textAlignment = NSTextAlignmentCenter;
    _txLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
    _txLabel.font = [UIFont systemFontOfSize:13];
    _txLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _txLabel.text = @"登录代表你同意《众游网络使用协议》和隐私条款";
    _txLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _txLabel.delegate = self;
    //设置高亮颜色
//    _txLabel.highlightedTextColor = [UIColor greenColor];
    
    //NO 不显示下划线
    _txLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [_txLabel setText:@"登录代表你同意《众游网络使用协议》和隐私条款" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        UIFont *font = [UIFont systemFontOfSize:13];
        //设置可点击文字的范围
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"《众游网络使用协议》" options:NSCaseInsensitiveSearch];
        
        //设置可点击文本的大小
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:font range:boldRange];
        
        //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor whiteColor] CGColor] range:boldRange];
        
        
        //设置可点击文字的范围
        NSRange boldRange2 = [[mutableAttributedString string] rangeOfString:@"隐私条款" options:NSCaseInsensitiveSearch];
        
            //设置可点击文本的大小
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:font range:boldRange2];
            
            //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor whiteColor] CGColor] range:boldRange2];
        
        return mutableAttributedString;
    }];
    
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_txLabel.text];
//    
    NSRange range1 = [_txLabel.text rangeOfString:@"《众游网络使用协议》"];
    [_txLabel addLinkToURL:[NSURL URLWithString:@"xieyiVC"] withRange:range1];
    NSRange range2 = [_txLabel.text rangeOfString:@"隐私条款"];
    [_txLabel addLinkToURL:[NSURL URLWithString:@"yinsiVC"] withRange:range2];
    
    [self.view addSubview:_txLabel];
    
    
}

#pragma mark - 手机动态登录
- (void)phoneLoginAction
{
    //手机注册的界面
    ZYMobileLoginController *mobileLoginController=[[ZYMobileLoginController alloc]init];
    [self presentViewController:mobileLoginController animated:YES completion:nil];
}

#pragma mark - 登录
- (void)wxLoginButtonAction
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kWechatAuthScope;// @"post_timeline,sns"
    req.state = kWechatAuthState;//  req.openID = kWechatAuthOpenID;
    [WXApi sendAuthReq:req viewController:self delegate:[WXApiManager sharedManager]];
    
}


#pragma mark --- 从微信返回的回调方法，获取微信token
-(void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    NSString *url = GET_WX_TOKEN(response.code);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        if (result[@"data"][@"errcode"]) {//获取失败，比如
            return ;
        }
        else
        {
            //获取成功，获取微信信息，并注册我们的平台
            ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"]];
            [self requstPersonalData:accountModel];
        }
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
    }];
}

/**
 *  获取微信用户的个人信息
 */
- (void)requstPersonalData:(ZYZCAccountModel *)account
{
    if (account) {
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",account.access_token,account.openidapp];
        [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
//            NSLog(@"%@",result);
            ZYZCAccountModel  *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result];
            //            有微信的数据后可以向我们的服务器发送注册信息
            [self regisPersonalMessageWith:accountModel];
        } andFailBlock:^(id failResult) {
//            NSLog(@"%@",failResult);
        }];
    }
}

#pragma mark - 注册个人资料
- (void)regisPersonalMessageWith:(ZYZCAccountModel *)weakAccount
{
    //    {
    //        "openid": "o6_bmjrPTlm6_2sgVt7hMZOPfL2M",
    //        "nickname": "Band",
    //        "sex": 1,
    //        "language": "zh_CN",
    //        "city": "广州",
    //        "province": "广东",
    //        "country": "中国",
    //        "headimgurl":    "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0"
    //    }
    if (!weakAccount) {
        return;
    }
    
//    NSString *headImg_132=[weakAccount.headimgurl substringToIndex:weakAccount.headimgurl.length-1];
//    headImg_132=[headImg_132 stringByAppendingString:@"132"];
    NSDictionary *parameter = @{
                                @"openid": weakAccount.unionid,
                                @"openidapp": weakAccount.openidapp,
                                @"nickname": weakAccount.nickname,
                                @"sex": weakAccount.sex,
                                @"language": weakAccount.language,
                                @"city": weakAccount.city,
                                @"province": weakAccount.province,
                                @"country": weakAccount.country,
                                @"headimgurl":weakAccount.headimgurl
                                };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:NO andURL:REGISTERWEICHAT andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
         DDLog(@"%@",result);
        if (isSuccess) {
            ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"]];
            accountModel.openid=result[@"data"][@"openid"];
            accountModel.userId=result[@"data"][@"userId"];
            accountModel.openidapp=result[@"data"][@"openidapp"];
            
            if (!accountModel.realName&&accountModel.userName) {
                accountModel.realName=accountModel.userName;
            }
            
            //保存个人信息到本地
            [ZYZCAccountTool saveAccount:accountModel];
            
            //这里应该修改根控制器
            [LoginJudgeTool rootJudgeLogin];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
    } andFailBlock:^(id failResult) {
         [MBProgressHUD hideHUDForView:self.view];
         [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
    }];
}

#pragma mark - 获取当前定位城市
- (void)getLocation
{
    // 判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue]>= 8.0) {
            //如果大于ios大于8.0，就请求获取地理位置授权
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager requestWhenInUseAuthorization];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter
            = 10.0f;//
            [self.locationManager startUpdatingLocation];
        }else{
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [self.cityChoseButton setTitle:@"杭州" forState:UIControlStateNormal];
    }
}

#pragma mark - 获取用户所在位置代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    [manager stopUpdatingLocation];
}

//获取用户位置数据失败的回调方法，在此通知用户

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}



#pragma mark ---label点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if ([url.absoluteString isEqual:@"xieyiVC"]) {
        
        AboutXieyiVC *xieyiVC = [[AboutXieyiVC alloc] init];
        
        if (self.navigationController) {
            
            [self.navigationController pushViewController:xieyiVC animated:YES];
        }else{
            
            [self presentViewController:xieyiVC animated:YES completion:nil];
        }
        
    }else if ([url.absoluteString isEqual:@"yinsiVC"]){
         AboutYinsiVC *yinsi = [[AboutYinsiVC alloc] init];
        
        if (self.navigationController) {
            
            [self.navigationController pushViewController:yinsi animated:YES];
        }else{
            
            [self presentViewController:yinsi animated:YES completion:nil];
        }
        
    }
    
}
@end
