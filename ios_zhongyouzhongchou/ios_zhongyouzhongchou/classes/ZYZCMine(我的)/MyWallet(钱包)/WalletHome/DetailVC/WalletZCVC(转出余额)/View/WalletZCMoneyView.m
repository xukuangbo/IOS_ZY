
//
//  WalletZCMoneyView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletZCMoneyView.h"
#import "UIView+ZYLayer.h"
#import "ZYZCCustomTextField.h"
//#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import "MBProgressHUD+MJ.h"
#import "WXApiManager.h"
#import "NetWorkManager.h"
@interface WalletZCMoneyView ()<ZYZCCustomTextFieldDelegate>
/* 可转出余额  */
@property (weak, nonatomic) IBOutlet UILabel *kzcMoneyLabel;
/* 输入框容器 */
@property (weak, nonatomic) IBOutlet UIView *inputMapView;
/* 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *inputBgView;
/* 输入标题 */
@property (weak, nonatomic) IBOutlet UILabel *inputMapTitleLabel;
/* 输入框 */
@property (weak, nonatomic) IBOutlet ZYZCCustomTextField *inputMapTextfiled;
/* 更换绑定按钮 */
@property (weak, nonatomic) IBOutlet UILabel *changeBindLabel;
/* 确认使用按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commitButton;


@property (nonatomic, strong) ZYZCAccountModel *bindModel;
@end

@implementation WalletZCMoneyView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setUpSubviews];
    
    [self requestBindData];
    
    [ZYNSNotificationCenter addObserver:self selector:@selector(BindWechatNotification:) name:BindWechatNoti object:nil];
}

- (void)dealloc
{
    DDLog(@"%@被移除了",[self class]);
    
    [ZYNSNotificationCenter removeObserver:self];
}

- (void)setUpSubviews{
    self.backgroundColor = [UIColor clearColor];
    
    //1.可转出余额
    _kzcMoneyLabel.attributedText = [ZYZCTool getAttributesString:self.kzcMoney withRMBFont:30 withBigFont:45 withSmallFont:20 withTextColor:nil];
    
    //2.输入标题
    _inputMapTitleLabel.font = [UIFont systemFontOfSize:15];
    _inputMapTitleLabel.textColor = [UIColor ZYZC_titleBlackColor];
    
    //3.输入框
    UILabel *RMBLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    RMBLabel.text = @"¥";
    RMBLabel.font = [UIFont systemFontOfSize:20];
    RMBLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _inputMapTextfiled.leftView = RMBLabel;
    _inputMapTextfiled.leftViewMode=UITextFieldViewModeAlways;
    _inputMapTextfiled.customTextFieldDelegate = self;
    _inputMapTextfiled.needBackgroudView = NO;
    _inputMapTextfiled.keyboardType = UIKeyboardTypeDecimalPad;
    _inputMapTextfiled.needAccess = YES;

    //3.输入容器背景图片
    _inputMapView.layerCornerRadius = 5;
    _inputBgView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    //4.更换绑定按钮
    [_changeBindLabel addTarget:self action:@selector(bingWxAction)];
    [self changeBindContentWithStatus:NO WechatModel:nil];
    
    //5.确认使用按钮
    _commitButton.layerCornerRadius = 5;
    [self changeCommitButtonUIWithStatus:NO];
}
#pragma mark - set方法
- (void)setKzcMoney:(CGFloat)kzcMoney{
    _kzcMoney = kzcMoney;
    
    _kzcMoneyLabel.attributedText = [ZYZCTool getAttributesString:kzcMoney withRMBFont:30 withBigFont:45 withSmallFont:20 withTextColor:nil];
}

#pragma mark - 自定义方法
/* 改变可选择按钮状态 */
- (void)changeCommitButtonUIWithStatus:(BOOL)canSelect{
    
    if (!canSelect) {
        [_commitButton setTitleColor:[UIColor ZYZC_TextGrayColor04] forState:UIControlStateNormal];
        _commitButton.backgroundColor = KCOLOR_RGBA(221, 221, 221,0.95);
        _commitButton.enabled = NO;
    }else{
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitButton.backgroundColor = [UIColor ZYZC_MainColor];
        _commitButton.enabled = YES;
    }
}

/* 更换绑定label内容 */
- (void)changeBindContentWithStatus:(BOOL)status WechatModel:(ZYZCAccountModel *)model{
    if (status == 0) {//未绑定
        NSString *str = @"还未绑定微信钱包 前去微信绑定";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        //1.绑定颜色
        NSRange bindRangge = [str rangeOfString:@"前去微信绑定" options:NSBackwardsSearch];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_MainColor] range:bindRangge];
        //2.内容颜色
        NSRange contentRange = NSMakeRange(0, str.length - bindRangge.length);
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_TextBlackColor] range:contentRange];
        
        _changeBindLabel.attributedText = attrString;
    }else{//已绑定
        
        NSString *str = [NSString stringWithFormat:@"转出到(%@)微信钱包 更换",model.userName];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        //1.绑定颜色
        NSRange bindRangge = [str rangeOfString:@"更换" options:NSBackwardsSearch];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_MainColor] range:bindRangge];
        //2.内容颜色
        NSRange contentRange = NSMakeRange(0, str.length - bindRangge.length);
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_TextBlackColor] range:contentRange];
        
        _changeBindLabel.attributedText = attrString;
    }
}

#pragma mark - NetWork请求是否有绑定过微信id
- (void)requestBindData{
    
    NSString *httpUrl = [[ZYZCAPIGenerate sharedInstance] API:@"u_checkUserBand.action"];
    @weakify(self);
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:httpUrl andParameters:nil andSuccessGetBlock:^(id result, BOOL isSuccess) {
        //        NSLog(@"%@",result);
        @strongify(self);
        if (isSuccess) {
            NSString *bandStatus = result[@"data"][@"band"];
            if ([bandStatus isEqualToString:@"0"]) {//未绑定
                [self changeBindContentWithStatus:NO WechatModel:nil];
            }else{//已绑定
                ZYZCAccountModel *accountModel =  [ZYZCAccountModel mj_objectWithKeyValues:result[@"data"][@"data"]];
                [self changeBindContentWithStatus:YES WechatModel:accountModel];
            }
        }else
        {
            [MBProgressHUD showError:@"网络错误" toView:self];
        }
    }andFailBlock:^(id failResult) {
        @strongify(self);
        [MBProgressHUD showError:@"网络错误" toView:self];
    }];

}
#pragma mark - 点击动作
- (void)bingWxAction{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kWechatAuthScope;// @"post_timeline,sns"
    req.state = kWechatAuthState;//  req.openID = kWechatAuthOpenID;
    [WXApi sendAuthReq:req viewController:self.viewController delegate:[WXApiManager sharedManager]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    CGFloat inputMoney = [new_text_str floatValue];
    //1.判断是否超过可转出金额
    if (inputMoney > _kzcMoney) {
        [MBProgressHUD showError:@"金额超出" toView:self];
        return NO;
    }else{
        //改变按钮状态
        if (inputMoney > 0) {
            [self changeCommitButtonUIWithStatus:YES];
        }else{
            [self changeCommitButtonUIWithStatus:NO];
        }
        return YES;
    }
    
}


#pragma mark - 通知
/* */
- (void)BindWechatNotification:(NSNotification *)noti{
    BaseResp *resp = (BaseResp *)noti.object;
    SendAuthResp *authResp = (SendAuthResp *)resp;
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"wxAPI_getToken"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:authResp.code forKey:@"code"];
    @weakify(self);
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        @strongify(self);
        if (result[@"data"][@"errcode"]) {//获取失败，比如
            return ;
        } else {
            //获取成功，获取微信信息，并注册我们的平台
            ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"]];
            if (accountModel.access_token) {
                [self requstPersonalData:accountModel];
            }
        }
    } andFailBlock:^(id failResult) {
        @strongify(self);
        [MBProgressHUD showError:@"网路错误" toView:self];
    }];

}

/**
 *  获取微信用户的个人信息
 */
- (void)requstPersonalData:(ZYZCAccountModel *)account
{
    if (account) {
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",account.access_token,account.openidapp];
        @weakify(self);
        [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
            //            NSLog(@"%@",result);
            @strongify(self);
            ZYZCAccountModel *accountModel=[ZYZCAccountModel mj_objectWithKeyValues:result];
            self.bindModel = accountModel;
//            有微信的数据后可以向我们的服务器发送绑定信息
            [self bindZhuanZhangWechatId:accountModel];
        } andFailBlock:^(id failResult) {
            //            NSLog(@"%@",failResult);
            @strongify(self);
            [MBProgressHUD showError:@"网络错误" toView:self];
        }];
    }
}

- (void)bindZhuanZhangWechatId:(ZYZCAccountModel *)accountModel{
    NSDictionary *parameter = @{
                                @"openid": accountModel.unionid,
                                @"openidapp": accountModel.openidapp,
                                @"nickname": accountModel.nickname,
                                @"sex": accountModel.sex,
                                @"language": accountModel.language,
                                @"city": accountModel.city,
                                @"province": accountModel.province,
                                @"country": accountModel.country,
                                @"headimgurl":accountModel.headimgurl
                                };
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    @weakify(self);
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"register_bandWx.action"];
    [ZYZCHTTPTool postHttpDataWithEncrypt:NO andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        @strongify(self);
        if (isSuccess) {

            [MBProgressHUD hideHUDForView:self];
            [self changeBindContentWithStatus:YES WechatModel:self.bindModel];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self];
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
    } andFailBlock:^(id failResult) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self];
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
    }];
}
@end
