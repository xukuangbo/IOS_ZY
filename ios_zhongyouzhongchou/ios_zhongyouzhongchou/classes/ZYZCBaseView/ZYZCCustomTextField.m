//
//  ZYZCNumberKeyBoard.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCCustomTextField.h"
#import "UIView+GetSuperTableView.h"
@interface ZYZCCustomTextField ()
@property (nonatomic, strong) UILabel *textlab;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ZYZCCustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.needBackgroudView=YES;
        self.needAccess=YES;
        self.shouldLimitTwoDecimal=YES;
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate=self;
        self.needBackgroudView=YES;
        self.needAccess=YES;
        self.shouldLimitTwoDecimal=YES;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate=self;
    self.shouldLimitTwoDecimal=YES;
}

//-(void)setDelegate:(id<UITextFieldDelegate>)delegate
//{
//    self.customTextFieldDelegate=(id<ZYZCCustomTextFieldDelegate>)delegate;
//}

-(UIView *)myInputAccessoryView
{
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 40)];

    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(subView.width-60-KEDGE_DISTANCE, 5, 60, 30);
    doneBtn.layer.cornerRadius=5;
    doneBtn.layer.masksToBounds=YES;
    doneBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:doneBtn];
    subView.backgroundColor=[UIColor ZYZC_LineGrayColor];
    
    _textlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, doneBtn.left-20, subView.height-10)];
    _textlab.backgroundColor=[UIColor whiteColor];
    _textlab.layer.cornerRadius=5;
    _textlab.layer.masksToBounds=YES;
    [subView addSubview:_textlab];
    _textlab.hidden=YES;
    return subView;
}

-(void)setNeedAccess:(BOOL)needAccess
{
    _needAccess=needAccess;
    if (_needAccess) {
        self.inputAccessoryView=[self myInputAccessoryView];
    }
    else
    {
        self.inputAccessoryView=nil;
    }
}

-(void)setShowTextInAccess:(BOOL)showTextInAccess
{
    _showTextInAccess=showTextInAccess;
    _textlab.hidden=!_showTextInAccess;
    if (showTextInAccess) {
        _textlab.text=self.text;
    }
}

#pragma mark ---点击确认按钮
-(void )doneClick
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
    if ([self respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self textFieldShouldReturn:self];
    }
}

#pragma mark ---实现textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //监听键盘的出现和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //监听文本改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    if (_textlab) {
        if (self.text.length) {
            _textlab.text=self.text;
        }
        else
        {
            if (self.keyboardType==UIKeyboardTypeDecimalPad) {
                _textlab.text=@"0";
            }
        }
    }
    
    if ([_customTextFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return  [_customTextFieldDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_customTextFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_customTextFieldDelegate textFieldDidBeginEditing:textField];
    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if ([_customTextFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return  [_customTextFieldDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //移除文本改变的通知监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    if ([_customTextFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
         [_customTextFieldDelegate textFieldDidEndEditing:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //如果是有小数点的键盘,要做处理
    BOOL result=YES;
    if (self.keyboardType == UIKeyboardTypeDecimalPad)
    {
         NSString  *limitStr = @"0123456789.";
         NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:limitStr] invertedSet];
         NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        result = [string isEqualToString:filtered];
    }
    
    if (self.keyboardType == UIKeyboardTypeNumberPad)
    {
        NSString  *limitStr = @"0123456789";
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:limitStr] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        result = [string isEqualToString:filtered];
    }

    if (result) {
        if ([_customTextFieldDelegate respondsToSelector:@selector(textField: shouldChangeCharactersInRange: replacementString:)]) {
            return [_customTextFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        }
    }
    else
    {
        return NO;
    }

    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([_customTextFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return  [_customTextFieldDelegate textFieldShouldClear:textField];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(_textlab)
    {
        textField.text=_textlab.text;
    }
    
    if (textField.keyboardType==UIKeyboardTypeDecimalPad) {
        if (textField.text.length>1&&[textField.text hasSuffix:@"."]) {
            textField.text=[textField.text substringToIndex:textField.text.length-1];
        }
    }
    if ([_customTextFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return  [_customTextFieldDelegate textFieldShouldReturn:textField];
    }
    return YES;
}


//键盘弹起，添加背景黑
-(void)keyboardWillShow:(NSNotification *)notify
{
    if (!_bgView&&_needBackgroudView) {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,KSCREEN_W ,KSCREEN_H)];
        _bgView.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.300];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_bgView];
        
        [_bgView addTarget:self action:@selector(hiddenKeyboard)];
    }
}

//键盘收起，移除背景黑
-(void)keyboardWillHidden:(NSNotification *)notify
{
    if (_bgView&&_needBackgroudView) {
        [_bgView removeFromSuperview];
        _bgView=nil;
    }
}

-(void)hiddenKeyboard
{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
    
    if(_tapBgViewBlock)
    {
        _tapBgViewBlock();
    }
}


-(void)textChange:(NSNotification *)notify
{
    if ([notify.object isKindOfClass:[ZYZCCustomTextField class]]) {
         ZYZCCustomTextField *textField=(ZYZCCustomTextField *)notify.object;
        //如果是有小数点的键盘,要做处理
        if (self.keyboardType==UIKeyboardTypeDecimalPad) {
            //如果首个字符为“.”，则更改为“0.”
            if (textField.text.length==1&&
                [textField.text isEqualToString:@"."]) {
                textField.text=@"0.";
            }
            //如果有多个“.”，则只出现一个"."
            if (textField.text.length>1) {
                NSString *subStr=[textField.text substringToIndex:textField.text.length-1];
                NSString *lastStr=[textField.text substringFromIndex:textField.text.length-1];
                NSRange range=[subStr rangeOfString:@"."];
                if (range.length) {
                    if ([lastStr isEqualToString:@"."]) {
                        textField.text=subStr;
                    }
                }
            }
            
            //处理非0前有多个0的情况
            if ([textField.text isEqualToString:@"00"]) {
                textField.text=@"0";
            }
            if (textField.text.length==2&&[textField.text hasPrefix:@"0"]&&![textField.text hasSuffix:@"."]) {
                textField.text=[textField.text substringFromIndex:textField.text.length-1];
            }
            
            //保留两位小数
            if (_shouldLimitTwoDecimal) {
                NSRange pointRange=[textField.text rangeOfString:@"."];
                if (pointRange.length) {
                    if ( pointRange.location+1+2<textField.text.length) {
                        textField.text=[textField.text substringToIndex:(pointRange.location+1+2)];
                    }
                }
            }
        }
        
        //如果是数字键盘
        else if (self.keyboardType==UIKeyboardTypeNumberPad)
        {
            //处理非0前有多个0的情况
            if ([textField.text isEqualToString:@"00"]) {
                textField.text=@"0";
            }
            if (textField.text.length==2&&[textField.text hasPrefix:@"0"]) {
                textField.text=[textField.text substringFromIndex:textField.text.length-1];
            }
        }
    }

    _textlab.text=self.text;
}

@end
