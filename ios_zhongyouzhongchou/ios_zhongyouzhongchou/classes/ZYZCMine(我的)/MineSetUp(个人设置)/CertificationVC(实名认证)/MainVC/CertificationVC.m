//
//  CertificationVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CertificationVC.h"
#import "UIView+ZYLayer.h"
#import "RealNameCardView.h"
#import <Masonry.h>
#import "UIView+ZYLayer.h"
#import "MMNumberKeyboard.h"

@interface CertificationVC ()<UITextFieldDelegate,MMNumberKeyboardDelegate>
@property (weak, nonatomic) IBOutlet UIView *headBg;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIImageView *headBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *Bg1;
@property (weak, nonatomic) IBOutlet UIImageView *Bg2;
@property (weak, nonatomic) IBOutlet UIImageView *Bg3;
@property (weak, nonatomic) IBOutlet UIView *upLoadImage;

//已认证的人物卡片
@property (nonatomic, strong) RealNameCardView *realNameCardView;

//三个文本输入
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (nonatomic, strong) MMNumberKeyboard *phoneKeyBoard;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (nonatomic, strong) MMNumberKeyboard *nameKeyBoard;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextfield;
@property (nonatomic, strong) MMNumberKeyboard *idCardKeyBoard;

//协议三件套
@property (weak, nonatomic) IBOutlet UIView *xieyiSelectView;
@property (weak, nonatomic) IBOutlet UILabel *xieyiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xieyiImageView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

//是否确认协议
@property (nonatomic, assign) BOOL isSelectXieyi;
@end

@implementation CertificationVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setBackItem];
    
    self.title = @"实名认证";
    
    [self requestHaveShiming];
    //协议label添加点击区域
}

#pragma mark - 自定义方法
- (void)setUpYesRealViews{
    _realNameCardView = [[[NSBundle mainBundle] loadNibNamed:@"RealNameCardView" owner:nil options:nil] lastObject];
    [self.view addSubview:_realNameCardView];
    
    [_realNameCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headBg.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(_realNameCardView.mas_width).multipliedBy(9 / 16.0);
    }];
    
}

- (void)setUpNoRealViews{
    
    _Bg1.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _Bg2.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _Bg3.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    
    //1.1设置电话输入框
    _phoneKeyBoard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    _phoneKeyBoard.allowsDecimalPoint = NO;
    _phoneKeyBoard.delegate = self;
    _phoneTextfield.inputView = _phoneKeyBoard;
    
    _nameTextfield.returnKeyType = UIReturnKeyDone;
    _idCardTextfield.returnKeyType = UIReturnKeyDone;
    
    //2.上传图片
    [_upLoadImage addTarget:self action:@selector(upLoadImageAction)];
    
    //3.协议设置
    _xieyiImageView.image = [UIImage imageNamed:@"shiming_yes_select"];
    _isSelectXieyi = YES;
    _xieyiLabel.attributedText = [self changeXieYiTextFontAndColorByString:_xieyiLabel.text];
    _xieyiImageView.backgroundColor = [UIColor clearColor];
    
    //添加点击区域
    UIView *selectXieyi = [UIView new];
    UIView *pushXieyiView = [UIView new];
    [selectXieyi addTarget:self action:@selector(xieyiSelectAction)];
    [pushXieyiView addTarget:self action:@selector(pushToXieyiAction)];
    
    [_xieyiSelectView addSubview:selectXieyi];
    [_xieyiSelectView addSubview:pushXieyiView];
    
    //4.确认提交按钮
    _commitButton.layerCornerRadius = 5;
    _commitButton.multipleTouchEnabled = NO;
    [self changeCommitButtonUIWithStatus:NO];
    
    [pushXieyiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_xieyiLabel.mas_left);
        make.top.bottom.right.equalTo(_xieyiSelectView);
    }];
    
    [selectXieyi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_xieyiLabel.mas_left);
        make.top.bottom.left.equalTo(_xieyiSelectView);
    }];
    
    [ZYNSNotificationCenter addObserver:self selector:@selector(textfieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (NSMutableAttributedString *)changeXieYiTextFontAndColorByString:(NSString *)str{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    if (str.length) {
        NSRange range1 = [str rangeOfString:@"同意"];
        NSRange range2 = NSMakeRange(range1.location + range1.length, str.length - range1.length - range1.location);
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_titleBlackColor] range:range1];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_MainColor] range:range2];
    }
    return  attrStr;
}

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

//目前需要两种判断,一种是只判断是否变绿,二是判断是否能提交,不能提交要显示那个按钮没填
- (BOOL)judgeCanCommit{
    if ([self judgePhone] && [self juedeNameTextfield] && [self judgeIdCard] && [self judgeUploadImage]) {
        return YES;
    }else{
        return NO;
    }
}
/* 判断手机格式正确与否 */
- (BOOL)judgePhone{
    if (_phoneTextfield.text.length <= 0) {
        
        return NO;
    }else{
        NSString *phoneFormat = @"^(0|86|17951)?1(3|5|7|8|4)[0-9]{9}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneFormat];
        BOOL isMatch = [phoneTest evaluateWithObject:_phoneTextfield.text];
        if (isMatch) {
            return YES;
        }else{
            return NO;
        }
    }
}

/* 判断身份证号码是否正确 */
- (BOOL)judgeIdCard{
    if (_idCardTextfield.text.length <= 0) {
        
        return NO;
    }else{
        NSString *idCardFormat = @"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardFormat];
        BOOL isMatch = [phoneTest evaluateWithObject:_idCardTextfield.text];
        if (isMatch) {
            return YES;
        }else{
            return NO;
        }
    }
}
/* 判断名字 */
- (BOOL)juedeNameTextfield{
    if (_nameTextfield.text.length > 0) {
        return YES;
    }else{
        return NO;
    }
}
/* 判断是否有上传图片 */
- (BOOL)judgeUploadImage{
    return YES;
}

- (BOOL)judgeSelectXieyi{
    if (_isSelectXieyi == YES) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - netWork
- (void)requestHaveShiming{
    BOOL isHave = NO;
    
    //1.背景图
    _headBg.backgroundColor = [UIColor ZYZC_MainColor];
    _headBgImage.image = [UIImage imageNamed:@"real_background"];
    if (isHave == YES) {
        
        [self setUpYesRealViews];
        
        _bodyView.hidden = YES;
        _descLabel.text = @"你已通过实名认证";

        //拿到头像和真实姓名展示
    }else{
        
        [self setUpNoRealViews];
        _bodyView.hidden = NO;
        _descLabel.text = @"你填写的资料将被严格保密";
    }
}


#pragma mark - 点击动作
- (void)upLoadImageAction{
    DDLog(@"上传到图片");
    
}

- (void)xieyiSelectAction{
    DDLog(@"点击了协议");
    _isSelectXieyi = !_isSelectXieyi;
    
    [self changeCommitButtonUIWithStatus:_isSelectXieyi];
    
    if (_isSelectXieyi == YES) {//确认选择
        _xieyiImageView.image = [UIImage imageNamed:@"shiming_yes_select"];
    }else{
        _xieyiImageView.image = [UIImage imageNamed:@"shiming_no_select"];
    }
}

- (void)pushToXieyiAction{
    DDLog(@"推送到协议控制器");
}

#pragma mark - textfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:_phoneTextfield]) {//电话输入
        if (textField.text.length <= 11) {
            
            return YES;
        }else{
            return NO;
        }
        
    }else if ([textField isEqual:_nameTextfield]){
        
        
    }else if ([textField isEqual:_idCardTextfield]){
        
        if (textField.text.length <= 18) {
            
            return YES;
        }else{
            return NO;
        }
    }
    
    //在这里判断是否能让变绿
    if ([self judgeCanCommit]) {
        
        [self changeCommitButtonUIWithStatus:YES];
    }else{
        [self changeCommitButtonUIWithStatus:NO];
    }
    
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - MMNumberKeyboardDelegate
- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text{
    
    
    return YES;
}


- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard{
    
    [self.view endEditing:YES];
    return YES;
}


- (BOOL)numberKeyboardShouldDeleteBackward:(MMNumberKeyboard *)numberKeyboard{
    
    return YES;
}

- (void)textfieldDidChange:(NSNotification *)noti{
    
}
@end
