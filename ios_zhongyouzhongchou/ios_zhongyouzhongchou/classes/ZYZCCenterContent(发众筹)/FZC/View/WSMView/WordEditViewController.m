//
//  WordEditViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WordEditViewController.h"

@interface WordEditViewController ()<UITextViewDelegate>
{
    UIView *navView;
}
@end

@implementation WordEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self configUI];
}

-(void)configUI
{
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    navView.backgroundColor=[UIColor ZYZC_MainColor];
    [self.view addSubview:navView];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, KSCREEN_W, 44)];
    lab.text=_myTitle;
    lab.font=[UIFont boldSystemFontOfSize:20];
    lab.textColor=[UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:lab];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_W, KSCREEN_H-64-250-40)];
    _textView.delegate=self;
    _textView.text=_preText;
    _textView.font=[UIFont systemFontOfSize:15];
    [_textView becomeFirstResponder];
    _textView.contentSize=CGSizeMake(0, _textView.height);
    _textView.inputAccessoryView=[self createAccessoryView];
    [self.view addSubview:_textView];
    
}

#pragma mark --- 创建键盘上的附属视图
-(UIView *)createAccessoryView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 40)];
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(view.width-60-KEDGE_DISTANCE, 5, 60, 30);
    doneBtn.layer.cornerRadius=5;
    doneBtn.layer.masksToBounds=YES;
    doneBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    view.backgroundColor=[UIColor ZYZC_LineGrayColor];
    
    return view;
}

#pragma mark --- 点击键盘上的确定按钮
-(void)doneClick
{
    BOOL isEmptyStr=[ZYZCTool isEmpty:_textView.text];
    if (isEmptyStr) {
        _textView.text=nil;
    }

    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
    if (_textBlock) {
        _textBlock(_textView.text);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 添加取消按钮
-(void)addMoreViews
{
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(0, 27, 60, 30) ;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
}

-(void)cancel
{
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark --- 限制文字字数
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (range.location>=10)
//    {
//        return  NO;
//    }
//    else
//    {
//        return YES;
//    }
//}



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
