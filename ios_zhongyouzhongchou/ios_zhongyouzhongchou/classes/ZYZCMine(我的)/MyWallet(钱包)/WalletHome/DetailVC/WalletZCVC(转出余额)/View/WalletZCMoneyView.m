
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
#import "ReactiveCocoa.h"
#import "MBProgressHUD+MJ.h"

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


@end

@implementation WalletZCMoneyView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setUpSubviews];
    
    [self judgeWechatId];
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
/* 判断是否有微信登录 */
- (void)judgeWechatId{
    ZYZCAccountModel *accountModel = [ZYZCAccountTool account];
    DDLog(@"%@",accountModel.openid);
    if (!accountModel.openid) {
        //手机登录,需要绑定支付的微信id
        
    }else{
        //微信登录,还是需要绑定微信的id吗?
        
    
    }
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}
@end
