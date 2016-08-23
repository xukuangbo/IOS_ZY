//
//  ZCSupportAnyYuanView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define LIMIT_MONEY   1000000.00

#import "ZCSupportAnyYuanView.h"
@interface ZCSupportAnyYuanView()

@end

@implementation ZCSupportAnyYuanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI
{
    [super configUI];
    
    [self.limitLab removeFromSuperview];
    
    //编辑任意金额
    _textField=[[ZYZCCustomTextField alloc]initWithFrame:CGRectMake(self.titleLab.right, self.titleLab.top-2, 80, self.titleLab.height+4)];
    _textField.customTextFieldDelegate=self;
    _textField.placeholder=@"¥";
    _textField.backgroundColor= [UIColor ZYZC_TabBarGrayColor];
    _textField.font=[UIFont systemFontOfSize:14];
    _textField.showTextInAccess=YES;
    _textField.keyboardType=UIKeyboardTypeDecimalPad;
    [self addSubview:_textField];
    __weak typeof (&*self)weakSelf=self;
    _textField.tapBgViewBlock=^()
    {
        [weakSelf keyboardHidden];
    };
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(_textField.right, self.titleLab.top, 20, self.titleLab.height)];
    lab.text=@"元";
    lab.textColor=[UIColor ZYZC_TextBlackColor];
    lab.font=[UIFont systemFontOfSize:15];
    [self addSubview:lab];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.productEndTime) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField.text floatValue]>LIMIT_MONEY) {
        textField.text=nil;
        [textField resignFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitAlertShow) name:UIKeyboardDidHideNotification object:nil];
    }
    else
    {
         [self keyboardHidden];
    }
    
    return YES;
}

-(void)keyboardHidden
{
    if ([_textField.text floatValue]>0) {
//        self.chooseSupport=YES;
        self.sureSupport=NO;
        
    }
    else
    {
        self.sureSupport=YES;
    }
    [self supportMoney];
}


-(void)limitAlertShow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"支持金额不能超过一百万!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


//
//-(void)supportMoney
//{
//    [super supportMoney];
//    if (!self.sureSupport) {
//        _textField.text=nil;
//        self.chooseSupport=NO;
//    }
//}

@end
