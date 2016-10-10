//
//  FinishBaseInfoController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define HEAD_HEIGHT  184+80*KCOFFICIEMNT
#define ONE_HEIGHT   50
#define TEXT_LIMIT   15
#define SAVE_BASE_INFO [NSString stringWithFormat:@"%@register/updateUserBaseInfo.action",BASE_URL]

#import "FinishBaseInfoController.h"
#import "FXBlurView.h"
#import "ZYCustomIconView.h"
@interface FinishBaseInfoController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) ZYCustomIconView *faceImgView;
@property (nonatomic, strong) UIImageView      *infoView;
@property (nonatomic, strong) FXBlurView       *blurView;
@property (nonatomic, strong) UIView           *blurColorView;
@property (nonatomic, strong) UILabel          *nikeName;
@property (nonatomic, strong) UIImageView      *bgImg;
@property (nonatomic, strong) UITextField      *nickTextField;
@property (nonatomic, strong) UITextField      *sexTextField;
@property (nonatomic, strong) UITextField      *jobTextField;
@property (nonatomic, strong) UIImage          *iocnImage;
@property (nonatomic, strong) NSNumber         *sex;
@end

@implementation FinishBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self setBackItem];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)configUI
{
    //背景图
    _infoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, HEAD_HEIGHT)];
    _infoView.contentMode=UIViewContentModeScaleAspectFill;
    _infoView.layer.masksToBounds=YES;
    _infoView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _infoView.image=[UIImage imageNamed:@"icon_placeholder"];
    [self.view addSubview:_infoView];
    [self addFXBlurView];
    
    //头像
    CGFloat faceWidth=80*KCOFFICIEMNT;
    _faceImgView=[[ZYCustomIconView alloc]initWithFrame:CGRectMake((self.view.width-faceWidth)/2, 64+KEDGE_DISTANCE, faceWidth, faceWidth)];
    _faceImgView.userId=_userId;
    _faceImgView.image=[UIImage imageNamed:@"icon_placeholder"];
    _faceImgView.layer.cornerRadius=KCORNERRADIUS;
    _faceImgView.layer.masksToBounds=YES;
    _faceImgView.layer.borderWidth=2;
    _faceImgView.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.view addSubview:_faceImgView];
    
    UILabel *alertLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _faceImgView.height-20, _faceImgView.width, 20)];
    alertLab.text=@"点击上传";
    alertLab.font=[UIFont systemFontOfSize:13];
    alertLab.textColor=[UIColor whiteColor];
    alertLab.shadowOffset=CGSizeMake(1, 1);
    alertLab.shadowColor=[UIColor ZYZC_TextBlackColor];
    alertLab.textAlignment=NSTextAlignmentCenter;
    [_faceImgView addSubview:alertLab];
    
    __weak typeof (&*self)weakSelf=self;
    _faceImgView.finishChoose=^(UIImage *iconImg)
    {
        weakSelf.iocnImage=iconImg;
        weakSelf.infoView.image=iconImg;
        alertLab.hidden=YES;
        [weakSelf addFXBlurView];
    };

    
    //昵称
    _nikeName=[[UILabel alloc]initWithFrame:CGRectMake(0, _faceImgView.bottom+KEDGE_DISTANCE, self.view.width, 20)];
    _nikeName.text=@"昵称";
    _nikeName.textColor=[UIColor whiteColor];
    _nikeName.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_nikeName];
    
    //返回键
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(KEDGE_DISTANCE, 20, 40, 40) ;
    [backBtn setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _nikeName.bottom+30, self.view.width-2*KEDGE_DISTANCE, ONE_HEIGHT*3)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _bgImg.userInteractionEnabled=YES;
    [self.view addSubview:_bgImg];
    
    //昵称编辑框
    _nickTextField=[[UITextField alloc]init];
    _nickTextField.placeholder=[NSString stringWithFormat:@"编辑昵称(%d字以内)",TEXT_LIMIT];
    //性别编辑框
    _sexTextField=[[UITextField alloc]init];
    _sexTextField.placeholder=@"选择性别";
    //事业编辑框
    _jobTextField=[[UITextField alloc]init];
    _jobTextField.placeholder=@"从事实业";
    
    NSArray *titleArr=@[@"昵称",@"性别",@"职业"];
    NSArray *textFieldArr=@[_nickTextField,_sexTextField,_jobTextField];
    for (int i= 0; i<3; i++) {
        UIView *oneView=[self createOneLineViewWithFrame:CGRectMake(0, ONE_HEIGHT*i, _bgImg.width, ONE_HEIGHT) andTextField:textFieldArr[i] andTitle:titleArr[i]];
        [_bgImg addSubview:oneView];
    }
    
    //选择性别
     UIView *sexChooseView=[[UIView alloc]initWithFrame:_sexTextField.bounds];
    [_sexTextField addSubview:sexChooseView];
    [sexChooseView addTarget:self action:@selector(chooseSex)];
    
    //保存按钮
    CGFloat btnHeight=60;
    UIButton  *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(KEDGE_DISTANCE, self.view.height-btnHeight-20, self.view.width-2*KEDGE_DISTANCE, btnHeight);
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=KCORNERRADIUS;
    sureBtn.layer.masksToBounds=YES;
    sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
    [sureBtn addTarget:self action:@selector(saveBaseInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    //监听键盘的出现和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //监听文本改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark --- 选择性别
-(void)chooseSex
{
    [self.view endEditing:YES];
    //弹出性别选择
    __weak typeof(&*self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.sexTextField.text = @"男";
        weakSelf.sex=@1;
    }];
    UIAlertAction *girlAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.sexTextField.text = @"女";
        weakSelf.sex=@2;
    }];
    UIAlertAction *unknownAction = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.sexTextField.text = @"保密";
        weakSelf.sex=@0;
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:manAction];
    [alertController addAction:girlAction];
    [alertController addAction:unknownAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark --- 文本改变
-(void)textChange:(NSNotification *)notify
{
    if (notify.object==_nickTextField) {
        if (_nickTextField.text.length>=TEXT_LIMIT) {
            _nickTextField.text=[_nickTextField.text substringToIndex:TEXT_LIMIT];
        }
        
        if (_nickTextField.text.length) {
            _nikeName.text=_nickTextField.text;
        }
        else
        {
            _nikeName.text=@"昵称";
        }
    }
    else if(notify.object==_jobTextField)
    {
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [self.view endEditing:YES];
    return YES;
}

#pragma mark --- 保存数据
-(void)saveBaseInfo
{
    if (!_iocnImage) {
        [MBProgressHUD showError:@"头像不能为空"];
        return;
    }
    if (!_nickTextField.text.length) {
        [MBProgressHUD showError:@"昵称不能为空"];
        return;
    }
    if (!_sexTextField.text.length) {
        [MBProgressHUD showError:@"性别不能为空"];
        return;
    }
    if (!_jobTextField.text.length) {
        [MBProgressHUD showError:@"职业不能为空"];
        return;
    }
    
    __weak typeof (&*self)weakSelf=self;
   [_faceImgView uploadImageToOSS:_iocnImage andResult:^(BOOL result,NSString *imgUrl) {
       if (result)
       {
           //保存数据到服务器
           [weakSelf saveData:imgUrl];
       }
       else
       {
           [MBProgressHUD showError:@"保存头像失败"];
       }
   }];
}

#pragma mark --- 保存数据到服务器
-(void)saveData:(NSString *)imgUrl
{
    NSDictionary *param=@{
                          @"userId":_userId,
                          @"faceImg":imgUrl,
                          @"realName":_nickTextField.text,
                          @"sex":_sex,
                          @"title":_jobTextField.text
                          };
//    NSLog(@"loginParam:%@",param);
    //保存数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool postHttpDataWithEncrypt:NO andURL:SAVE_BASE_INFO andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         DDLog(@"userInfo:%@",result);
         [MBProgressHUD hideHUDForView:self.view];
         if (isSuccess) {
             //保存基本信息到本地
             ZYZCAccountModel *accountModel=[[ZYZCAccountModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
             accountModel.headimgurl=imgUrl;
             ZYZCAccountModel *oldAccountModel=[ZYZCAccountTool account];
             accountModel.scr=oldAccountModel.scr;
             [ZYZCAccountTool saveAccount:accountModel];
             
             //回到主页
             __weak typeof (&*self)weakSelf=self;
             
             [self dismissViewControllerAnimated:NO completion:^{
                 //更换根控制器
                 [weakSelf getRootViewController];
                 
             }];
         }
         else
         {
             [MBProgressHUD showError:result[@"errorMsg"]];
         }
     }
      andFailBlock:^(id failResult)
     {
         [MBProgressHUD hideHUDForView:self.view];
         [MBProgressHUD showError:@"网络错误,保存失败"];
//         NSLog(@"%@",failResult);
     }];
}

#pragma mark --- 设置根控制器
-(void)getRootViewController
{
    UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZYZCTabBarController *mainTab=[storyboard instantiateViewControllerWithIdentifier:@"ZYZCTabBarController"];
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController=mainTab;
}


#pragma mark --- 键盘将要出现
- (void)keyboardWillShow:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGFloat changeHeight=value.CGRectValue.size.height;
    if (_bgImg.bottom>self.view.height-changeHeight) {
        _bgImg.bottom=self.view.height-changeHeight;
    }
}

#pragma mark --- 键盘将要消失
- (void)keyboardWillHidden:(NSNotification *)notify
{
    _bgImg.top=_nikeName.bottom+30;
}

#pragma mark --- 创建某一栏视图
-(UIView *)createOneLineViewWithFrame:(CGRect)frame andTextField:(UITextField *)textField andTitle:(NSString *)title
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UIImageView *pointImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, (view.height-8)/2, 8, 8)];
    pointImg.image=[UIImage imageNamed:@"icn_self_infor_label"];
    [view addSubview:pointImg];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(pointImg.right+KEDGE_DISTANCE, 0, 60, view.height)];
    titleLab.text=title;
    titleLab.textColor=[UIColor ZYZC_TextBlackColor];
    [view addSubview:titleLab];
    
    textField.frame=CGRectMake(titleLab.right+10, 0, view.width-titleLab.right-10-KEDGE_DISTANCE, view.height);
    textField.delegate=self;
    textField.clearButtonMode= UITextFieldViewModeWhileEditing;
    textField.tintColor=[UIColor ZYZC_MainColor];
    textField.returnKeyType=UIReturnKeyDone;
    textField.textColor=[UIColor ZYZC_TextBlackColor];
    [view addSubview:textField];
    
    [view addSubview:[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, view.height-0.5, view.width-2*KEDGE_DISTANCE, 0.5) andColor:[UIColor ZYZC_BgGrayColor02]]];
    
    return view;
}

#pragma mark --- 返回
-(void)back
{
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark --- 添加毛玻璃
-(void)addFXBlurView
{
    if (_blurView) {
        [_blurView removeFromSuperview];
    }
    //创建毛玻璃
    _blurView = [[FXBlurView alloc] initWithFrame:_infoView.bounds];
    [_blurView setDynamic:NO];
    _blurView.blurRadius=10;
    [self.view addSubview:_blurView];
    
    _blurColorView=[[UIView alloc]initWithFrame:_blurView.bounds];
    _blurColorView.backgroundColor=[UIColor ZYZC_MainColor];
    _blurColorView.alpha=0.7;
    [_blurView addSubview:_blurColorView];
    [self.view insertSubview:_blurView atIndex:1];
    
}

-(void)dealloc
{
//    NSLog(@"dealloc：%@",self.class);
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //移除文本改变的通知监听
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
