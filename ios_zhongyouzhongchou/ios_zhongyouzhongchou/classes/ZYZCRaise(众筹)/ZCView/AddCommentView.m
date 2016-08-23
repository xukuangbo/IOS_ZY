//
//  AddCommentView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AddCommentView.h"
#import "MBProgressHUD+MJ.h"
@interface AddCommentView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel    *placeHolderLab;
@end

@implementation AddCommentView

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
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, KSCREEN_W, 49);
        self.backgroundColor=[UIColor ZYZC_BgGrayColor01];
         [self configUI];
        //监听键盘的出现和收起
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        //监听文字发生变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
        
        //监听键盘高度改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

-(void)configUI
{
    CGFloat buttonWidth=90;
    _editFieldView=[[UITextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 8, self.width-buttonWidth, 33)];
    _editFieldView.layer.cornerRadius=4;
    _editFieldView.layer.borderWidth=0.5;
    _editFieldView.font=[UIFont systemFontOfSize:15];
    _editFieldView.layer.borderColor=[UIColor colorWithWhite:0.549 alpha:1.000].CGColor;
//    _editFieldView.returnKeyType=UIReturnKeyDone;
    _editFieldView.delegate=self;
    [self addSubview:_editFieldView];
    
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 6.5, _editFieldView.width, 20)];
    _placeHolderLab.text=@"点击编写评论";
    _placeHolderLab.font=[UIFont systemFontOfSize:15];
    _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor02];
    [_editFieldView addSubview:_placeHolderLab];

    
    _sendComentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _sendComentBtn.frame=CGRectMake(_editFieldView.right, 0, buttonWidth, self.height);
    _sendComentBtn.layer.cornerRadius=KCORNERRADIUS;
    _sendComentBtn.layer.masksToBounds=YES;
    [_sendComentBtn setTitle:@"发表" forState:UIControlStateNormal];
    [_sendComentBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    _sendComentBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _sendComentBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_sendComentBtn addTarget:self  action:@selector(sendMyComment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendComentBtn];
    [self addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, self.width, 1) andColor:nil]];
}

#pragma mark --- 发表评论
-(void)sendMyComment
{
    _editFieldView.text=[_editFieldView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL isEmptyStr=[ZYZCTool isEmpty:_editFieldView.text];
    if (isEmptyStr) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"文字不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    NSDictionary *parameters= @{
                                @"userId":[ZYZCAccountTool getUserId],
                                @"productId":_productId,
                                @"content":_editFieldView.text
                              };
    if (_editFieldView.text.length) {
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:COMMENT_PRODUCT andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
//            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_success")];
                if (!_editFieldView.resignFirstResponder) {
                   [_editFieldView resignFirstResponder];
                }
                _editFieldView.text=nil;
                _placeHolderLab.hidden=NO;
                _editFieldView.height=33;
                self.height=49;
                self.top=KSCREEN_H-self.height;
                _sendComentBtn.top=self.height-_sendComentBtn.height;
                 [_sendComentBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                if (_commentSuccess) {
                    _commentSuccess(_editFieldView.text);
                }
            }
            else
            {
                 [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_fail")];
            }
            
        } andFailBlock:^(id failResult) {
//            NSLog(@"%@",failResult);
            
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }];
    }
}

#pragma mark --- textField代理方法

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _placeHolderLab.hidden=YES;
    return YES;
}
-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if (!_editFieldView.text.length) {
        _placeHolderLab.hidden=NO;
    }
    else
    {
        _placeHolderLab.hidden=YES;
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    _editFieldView.text=[_editFieldView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL isEmptyStr=[ZYZCTool isEmpty:_editFieldView.text];
    if (isEmptyStr) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"文字不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

    [_editFieldView resignFirstResponder];
    return YES;
}

#pragma mark --- 文字发生改变
-(void)textChange:(NSNotification *)notify
{
    CGFloat textHeight=MAX([ZYZCTool calculateStrLengthByText:_editFieldView.text andFont:_editFieldView.font andMaxWidth:_editFieldView.width-10].height,33);
    if (textHeight<=100) {
        CGFloat changeHeight=textHeight-_editFieldView.height;
        _editFieldView.height=textHeight;
        self.height+=changeHeight;
        self.top-=changeHeight;
        _sendComentBtn.top=self.height-_sendComentBtn.height;
    }
    
    if (_editFieldView.text.length) {
        _placeHolderLab.hidden=YES;
        [_sendComentBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    }
    else
    {
        _placeHolderLab.hidden=NO;
        [_sendComentBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark --- 键盘出现和收起方法
-(void)keyboardWillShow:(NSNotification *)notify
{
     NSDictionary *dic = notify.userInfo;
     NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGFloat height=value.CGRectValue.size.height;
    self.top=KSCREEN_H-height-self.height;
}

-(void)keyboardWillHidden:(NSNotification *)notify
{
    self.top=KSCREEN_H-self.height;
}

#pragma mark --- 键盘高度改变
-(void)keyboardWillChangeFrame:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGFloat height=value.CGRectValue.size.height;
    self.top=KSCREEN_H-height-self.height;

}

-(void)dealloc
{
    DDLog(@"dealloc:%@",self.class);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
