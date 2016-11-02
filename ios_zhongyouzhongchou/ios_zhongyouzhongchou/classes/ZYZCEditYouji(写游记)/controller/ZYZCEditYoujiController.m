//
//  ZYZCEditYoujiController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/11.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define HEIGHT01  300

#import "ZYZCEditYoujiController.h"
@interface ZYZCEditYoujiController ()<UIScrollViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIScrollView  *scroll;
@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) UILabel       *placeHolderLab;

@end

@implementation ZYZCEditYoujiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"写游记";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self configUI];
    [self setBackItem];
    
    //监听键盘的出现和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //监听文字发生变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    //监听键盘高度改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)configUI
{
    _scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 64+ KEDGE_DISTANCE, self.view.width-2*KEDGE_DISTANCE, self.view.height-2*KEDGE_DISTANCE)];
    _scroll.backgroundColor=[UIColor whiteColor];
    _scroll.layer.cornerRadius=KCORNERRADIUS;
    _scroll.layer.masksToBounds=YES;
    _scroll.delegate=self;
    _scroll.contentSize=CGSizeMake(0, 1000);
    [self.view addSubview:_scroll];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, HEIGHT01, _scroll.width-2*KEDGE_DISTANCE, _scroll.height-_textView.top)];
    _textView.delegate=self;
    _textView.font=[UIFont systemFontOfSize:18];
    _textView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [_scroll addSubview:_textView];
    
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 6.5, _textView.width, 20)];
    _placeHolderLab.text=@"点击编辑正文";
    _placeHolderLab.font=[UIFont systemFontOfSize:18];
    _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor];
    [_textView addSubview:_placeHolderLab];
}

#pragma mark --- 文字发生改变
-(void)textChange:(NSNotification *)notify
{
    
}

#pragma mark --- 键盘出现
-(void)keyboardWillShow:(NSNotification *)notify
{
//    NSDictionary *dic = notify.userInfo;
//    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
//    CGFloat height=value.CGRectValue.size.height;
    _scroll.contentSize=CGSizeMake(0, _scroll.contentSize.height+HEIGHT01);
    _scroll.contentOffset=CGPointMake(0, HEIGHT01);
}

#pragma mark --- 键盘收起
-(void)keyboardWillHidden:(NSNotification *)notify
{
//    _scroll.contentSize=CGSizeMake(0, _scroll.contentSize.height-HEIGHT01);
//    _scroll.contentOffset=CGPointMake(0, -HEIGHT01);
}

#pragma mark --- 键盘高度改变
-(void)keyboardWillChangeFrame:(NSNotification *)notify
{
//    NSDictionary *dic = notify.userInfo;
//    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
//    CGFloat height=value.CGRectValue.size.height;
    
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
