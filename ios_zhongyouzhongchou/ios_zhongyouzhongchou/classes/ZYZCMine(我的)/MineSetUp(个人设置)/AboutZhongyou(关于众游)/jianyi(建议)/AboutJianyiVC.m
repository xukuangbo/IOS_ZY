//
//  AboutJianyiVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AboutJianyiVC.h"
#import "WriteTextView.h"
#import "MBProgressHUD+MJ.h"
@interface AboutJianyiVC ()<UITextViewDelegate>
@property (nonatomic, strong) WriteTextView *writeTextView;
@end

@implementation AboutJianyiVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}


- (void)configUI
{
    [self setBackItem];
    
    self.title = @"意见建议";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    //正文
    _writeTextView = [[WriteTextView alloc] init];
    _writeTextView.delegate = self;
    _writeTextView.backgroundColor = [UIColor clearColor];
    _writeTextView.left = KEDGE_DISTANCE;
    _writeTextView.top = KNAV_HEIGHT + KEDGE_DISTANCE;
    _writeTextView.height = 300;
    _writeTextView.width = KSCREEN_W - 2 * KEDGE_DISTANCE;
    _writeTextView.textColor = [UIColor ZYZC_TextGrayColor];
    _writeTextView.textAlignment = NSTextAlignmentLeft;
    _writeTextView.font = [UIFont systemFontOfSize:15];
    _writeTextView.backgroundColor = [UIColor whiteColor];
    _writeTextView.layer.cornerRadius = 5;
    _writeTextView.layer.masksToBounds = YES;
    _writeTextView.placeholder = @"为了更好的让大家旅行，请编辑建议或意见";
    _writeTextView.placeholderColor = [UIColor ZYZC_TextGrayColor];
    _writeTextView.inputAccessoryView = [self createAccessoryView];
    [self.view addSubview:_writeTextView];
    
    
    //设置右上角发送
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.size = CGSizeMake(40, 40);
    [sureButton setTitle:@"发送" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_writeTextView becomeFirstResponder];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor ZYZC_MainColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_writeTextView resignFirstResponder];
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
    [_writeTextView resignFirstResponder];
}


#pragma mark ---surebuttonaction
- (void)sureButtonAction
{
    if (_writeTextView.text.length <= 0) {
        //没有文字的话
        [MBProgressHUD showError:@"请输入意见建议"];
    }else{
//        [MBProgressHUD showMessage:@"正在提交"];
        
        
        NSDictionary *parameters = @{
                                     @"userId" : [ZYZCAccountTool getUserId],
                                     @"content" : _writeTextView.text
                                     };
        __weak typeof(&*self) weakSelf = self;
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Post_Jianyi andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
//            NSLog(@"%@",result);
            
            [weakSelf successAction];
        
        } andFailBlock:^(id failResult) {
            [weakSelf errorAction];
        }];
    }
    
}

- (void)successAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"上传成功"];
    });
}

- (void)errorAction
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"上传失败"];
    });
}
@end
