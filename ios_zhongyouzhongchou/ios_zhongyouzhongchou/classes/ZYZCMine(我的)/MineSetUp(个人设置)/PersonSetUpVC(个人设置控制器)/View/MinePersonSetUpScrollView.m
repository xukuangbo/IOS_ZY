//
//  MinePersonSetUpScrollView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 liuliang. All rights reserved.

#import "MinePersonSetUpScrollView.h"
#import "MinePersonSetUpHeadView.h"
#import "MinePersonSetUpModel.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MBProgressHUD+MJ.h"
#import "STPickerArea.h"
#import "STPickerDate.h"
#import "STPickerSingle.h"
#import "FXBlurView.h"
#import "ZYZCRCManager.h"
#import "RACEXTScope.h"
#define Limit_Name_Length 15
#define SetUpFirstCellLabelHeight 34
@interface MinePersonSetUpScrollView()<ZYZCCustomTextFieldDelegate,STPickerAreaDelegate,STPickerDateDelegate>
@property (nonatomic, strong) UIImageView *firstBg;
@property (nonatomic, strong) UIImageView *secondBg;
@property (nonatomic, strong) UIImageView *thirdBg;
@property (nonatomic, strong) UIImageView *fourthBg;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, weak) UIButton *saveButton;
@property (nonatomic, strong) FXBlurView *blurView;

@property (nonatomic, strong) NSString *lastIconImg;

@property (nonatomic, assign) BOOL hasFZC;
@end
@implementation MinePersonSetUpScrollView
#pragma mark - system方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self requestHadFZCData];
        
        [self createUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_nameTextField];
}
#pragma mark - setUI方法
- (void)createUI
{
    //头视图
     MinePersonSetUpHeadView *headView = [[MinePersonSetUpHeadView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, imageHeadHeight)];
    self.headView = headView;
    [self addSubview:headView];
    
    //第一个表格
    [self createFirstUI];
    
    [self createSecondUI];
    
    [self createThirdUI];
    
    [self createFourthUI];
    
    [self createSaveButton];
    
    self.contentSize = CGSizeMake(KSCREEN_W, self.saveButton.bottom + KEDGE_DISTANCE);
//    NSLog(@"%@",NSStringFromCGSize(self.contentSize));
    
}

/**
 *  第一个cell
 */
- (void)createFirstUI
{
    //背景白图
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = self.headView.bottom + KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = 0;
    self.firstBg = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    self.firstBg.userInteractionEnabled = YES;
    [self addSubview:self.firstBg];
    
    //姓名
    CGFloat nameTitleX = KEDGE_DISTANCE * 2;
    CGFloat nameTitleY = KEDGE_DISTANCE;
    CGFloat nameTitleW = (bgImageViewW - nameTitleX * 2) * 0.3;
    CGFloat nameTitleH = SetUpFirstCellLabelHeight;
    UILabel *nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameTitleX, nameTitleY, nameTitleW, nameTitleH)];
    nameTitleLabel.text = @"昵称";
    
    
    _nameTextFieldXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, nameTitleLabel.centerY - 4, 8, 8)];
    _nameTextFieldXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    [_firstBg addSubview:_nameTextFieldXX];
    
    ZYZCCustomTextField *nameTextField = [[ZYZCCustomTextField alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification object:nameTextField];
    nameTextField.textColor = [UIColor lightGrayColor];
    nameTextField.placeholder = @"请输入姓名";
    nameTextField.customTextFieldDelegate = self;
    nameTextField.needAccess = NO;
    nameTextField.returnKeyType = UIReturnKeyDone;
    self.nameTextField = nameTextField;
    [self createUIWithSuperView:self.firstBg titleLabel:nameTitleLabel titleView:nameTextField];
    //性别
    CGFloat sexX = KEDGE_DISTANCE * 2;
    CGFloat sexY = nameTitleLabel.bottom;
    CGFloat sexW = (bgImageViewW - nameTitleX * 2) * 0.3;
    CGFloat sexH = SetUpFirstCellLabelHeight;
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexX, sexY, sexW, sexH)];
    sexLabel.text = @"性别";
    
    _sexButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, sexLabel.centerY - 4, 8, 8)];
    
    _sexButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    
    [_firstBg addSubview:_sexButtonXX];
    
    ZYZCCustomTextField *sexButton = [[ZYZCCustomTextField alloc] init];
    sexButton.placeholder = @"请选择性别";
    sexButton.textColor = [UIColor lightGrayColor];
    sexButton.customTextFieldDelegate = self;
    self.sexButton = sexButton;
    [self createUIWithSuperView:self.firstBg titleLabel:sexLabel titleView:sexButton];
    
    //生日标题
    CGFloat birthdayLabelX = KEDGE_DISTANCE * 2;
    CGFloat birthdayLabelY = sexButton.bottom;
    CGFloat birthdayLabelW = (bgImageViewW - nameTitleX * 2) * 0.3;
    CGFloat birthdayLabelH = SetUpFirstCellLabelHeight;
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(birthdayLabelX, birthdayLabelY, birthdayLabelW, birthdayLabelH)];
    birthdayLabel.text = @"生日";
    _birthButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, birthdayLabel.centerY - 4, 8, 8)];
    
    _birthButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    
    [_firstBg addSubview:_birthButtonXX];
    
    ZYZCCustomTextField *birthButton = [[ZYZCCustomTextField alloc] init];
    birthButton.textColor = [UIColor lightGrayColor];
    birthButton.placeholder = @"请选择生日";
    birthButton.customTextFieldDelegate = self;
    self.birthButton = birthButton;
    [self createUIWithSuperView:self.firstBg titleLabel:birthdayLabel titleView:birthButton];
    
    //星座标题
    CGFloat constellationLabelX = KEDGE_DISTANCE * 2;
    CGFloat constellationLabelY = birthButton.bottom;
    CGFloat constellationLabelW = (bgImageViewW - nameTitleX * 2) * 0.3;
    CGFloat constellationLabelH = SetUpFirstCellLabelHeight;
    UILabel *constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(constellationLabelX, constellationLabelY, constellationLabelW, constellationLabelH)];
    constellationLabel.text = @"星座";
    
    _constellationButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, constellationLabel.centerY - 4, 8, 8)];
    _constellationButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    [_firstBg addSubview:_constellationButtonXX];
    
    ZYZCCustomTextField *constellationButton = [[ZYZCCustomTextField alloc] init];
    constellationButton.userInteractionEnabled = NO;
    constellationButton.textColor = [UIColor lightGrayColor];
    constellationButton.placeholder = @"您还没有选择生日哦";
    self.constellationButton = constellationButton;
    [self createUIWithSuperView:self.firstBg titleLabel:constellationLabel titleView:constellationButton];
    
    self.firstBg.layer.cornerRadius = 5;
    self.firstBg.layer.masksToBounds = YES;
    self.firstBg.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    self.firstBg.height = (SetUpFirstCellLabelHeight * 4 + KEDGE_DISTANCE * 2);
}

/**
 *  第二个cell
 */
- (void)createSecondUI
{
    //背景白图
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = self.firstBg.bottom + KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = 0;
    self.secondBg = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    self.secondBg.userInteractionEnabled = YES;
    [self addSubview:self.secondBg];
    
    //感情状况标题
    CGFloat marryLabelX = KEDGE_DISTANCE * 2;
    CGFloat marryLabelY = KEDGE_DISTANCE;
    CGFloat marryLabelW = (bgImageViewW - marryLabelX * 2) * 0.3;
    CGFloat marryLabelH = SetUpFirstCellLabelHeight;
    UILabel *marryLabel = [[UILabel alloc] initWithFrame:CGRectMake(marryLabelX, marryLabelY, marryLabelW, marryLabelH)];
    marryLabel.text = @"感情状况";
    
    _marryButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, marryLabel.centerY - 4, 8, 8)];
    _marryButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    [_secondBg addSubview:_marryButtonXX];

    ZYZCCustomTextField *marryButton = [[ZYZCCustomTextField alloc] init];
    marryButton.placeholder = @"请选择感情状况";
    marryButton.textColor =[UIColor lightGrayColor];
    marryButton.customTextFieldDelegate = self;
    marryButton.needAccess = YES;
    marryButton.returnKeyType = UIReturnKeyDone;
    self.marryButton = marryButton;
    [self createUIWithSuperView:self.secondBg titleLabel:marryLabel titleView:marryButton];
    
    //身高标题
    CGFloat heightLabelX = KEDGE_DISTANCE * 2;
    CGFloat heightLabelY = marryButton.bottom;
    CGFloat heightLabelW = (bgImageViewW - heightLabelX * 2) * 0.3;
    CGFloat heightLabelH = SetUpFirstCellLabelHeight;
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(heightLabelX, heightLabelY, heightLabelW, heightLabelH)];
    heightLabel.text = @"身高(cm)";
    
    _heightButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, heightLabel.centerY - 4, 8, 8)];
    _heightButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    [_secondBg addSubview:_heightButtonXX];
    
    ZYZCCustomTextField *heightButton = [[ZYZCCustomTextField alloc] init];
    heightButton.textColor = [UIColor lightGrayColor];
    heightButton.placeholder = @"请输入身高";
    heightButton.customTextFieldDelegate = self;
    heightButton.needAccess = YES;
    heightButton.returnKeyType = UIReturnKeyDone;
    heightButton.keyboardType = UIKeyboardTypeDecimalPad;
    self.heightButton = heightButton;
    [self createUIWithSuperView:self.secondBg titleLabel:heightLabel titleView:heightButton];

    //体重标题
    CGFloat weightLabelX = KEDGE_DISTANCE * 2;
    CGFloat weightLabelY = heightButton.bottom;
    CGFloat weightLabelW = (bgImageViewW - weightLabelX * 2) * 0.3;
    CGFloat weightLabelH = SetUpFirstCellLabelHeight;
    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLabelX, weightLabelY, weightLabelW, weightLabelH)];
    weightLabel.text = @"体重(kg)";
    
    _weightButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, weightLabel.centerY - 4, 8, 8)];
    _weightButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    [_secondBg addSubview:_weightButtonXX];
    
    ZYZCCustomTextField *weightButton = [[ZYZCCustomTextField alloc] init];
    weightButton.textColor = [UIColor lightGrayColor];
    weightButton.placeholder = @"请输入体重";
    marryButton.customTextFieldDelegate = self;
    marryButton.needAccess = YES;
    marryButton.returnKeyType = UIReturnKeyDone;
    weightButton.keyboardType = UIKeyboardTypeDecimalPad;
    self.weightButton = weightButton;
    [self createUIWithSuperView:self.secondBg titleLabel:weightLabel titleView:weightButton];
    
    self.secondBg.layer.cornerRadius = 5;
    self.secondBg.layer.masksToBounds = YES;
    self.secondBg.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    self.secondBg.height = (SetUpFirstCellLabelHeight * 3 + KEDGE_DISTANCE * 2);
}
/**
 *  第三个cell
 */
- (void)createThirdUI
{
    //背景白图
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = self.secondBg.bottom + KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = 0;
    self.thirdBg = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    self.thirdBg.userInteractionEnabled = YES;
    [self addSubview:self.thirdBg];
    
    //公司标题
    CGFloat companyLabelX = KEDGE_DISTANCE * 2;
    CGFloat companyLabelY = KEDGE_DISTANCE;
    CGFloat companyLabelW = (bgImageViewW - companyLabelX * 2) * 0.3;
    CGFloat companyLabelH = SetUpFirstCellLabelHeight;
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(companyLabelX, companyLabelY, companyLabelW, companyLabelH)];
    companyLabel.text = @"公司";
    
    ZYZCCustomTextField *companyButton = [[ZYZCCustomTextField alloc] init];
    companyButton.textColor = [UIColor lightGrayColor];
    companyButton.placeholder = @"请输入公司名称,没有填无";
    companyButton.customTextFieldDelegate = self;
    companyButton.needAccess = NO;
    companyButton.returnKeyType = UIReturnKeyDone;
    companyButton.customTextFieldDelegate = self;
    self.companyButton = companyButton;
    [self createUIWithSuperView:self.thirdBg titleLabel:companyLabel titleView:companyButton];
    //工作
    CGFloat jobLabelX = KEDGE_DISTANCE * 2;
    CGFloat jobLabelY = companyButton.bottom;
    CGFloat jobLabelW = (bgImageViewW - jobLabelX * 2) * 0.3;
    CGFloat jobLabelH = SetUpFirstCellLabelHeight;
    UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(jobLabelX, jobLabelY, jobLabelW, jobLabelH)];
    jobLabel.text = @"职业";
    
    _jobButtonXX = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE - 4, jobLabel.centerY - 4, 8, 8)];
    _jobButtonXX.image = [UIImage imageNamed:@"icn_self_infor_label"];
    [_thirdBg addSubview:_jobButtonXX];
    
    
    ZYZCCustomTextField *jobButton = [[ZYZCCustomTextField alloc] init];
    jobButton.textColor = [UIColor lightGrayColor];
    jobButton.placeholder = @"请输入工作,没有填无";
    jobButton.needAccess = NO;
    jobButton.returnKeyType = UIReturnKeyDone;
    jobButton.customTextFieldDelegate = self;
    self.jobButton = jobButton;
    [self createUIWithSuperView:self.thirdBg titleLabel:jobLabel titleView:jobButton];
    
    //学校标题
    CGFloat schoolLabelX = KEDGE_DISTANCE * 2;
    CGFloat schoolLabelY = jobButton.bottom;
    CGFloat schoolLabelW = (bgImageViewW - schoolLabelX * 2) * 0.3;
    CGFloat schoolLabelH = SetUpFirstCellLabelHeight;
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(schoolLabelX, schoolLabelY, schoolLabelW, schoolLabelH)];
    schoolLabel.text = @"学校";
    ZYZCCustomTextField *schoolButton = [[ZYZCCustomTextField alloc] init];
    schoolButton.textColor = [UIColor lightGrayColor];
    schoolButton.placeholder = @"请输入学校,没有填无";
    schoolButton.needAccess = NO;
    schoolButton.returnKeyType = UIReturnKeyDone;
    schoolButton.customTextFieldDelegate = self;
    self.schoolButton = schoolButton;
    [self createUIWithSuperView:self.thirdBg titleLabel:schoolLabel titleView:schoolButton];
    
    //学校标题
    CGFloat departmentX = KEDGE_DISTANCE * 2;
    CGFloat departmentY = schoolButton.bottom;
    CGFloat departmentW = (bgImageViewW - departmentX * 2) * 0.3;
    CGFloat departmentH = SetUpFirstCellLabelHeight;
    UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(departmentX, departmentY, departmentW, departmentH)];
    departmentLabel.text = @"专业";
    ZYZCCustomTextField *departmentButton = [[ZYZCCustomTextField alloc] init];
    departmentButton.textColor = [UIColor lightGrayColor];
    departmentButton.placeholder = @"请输入专业,没有填无";
    departmentButton.needAccess = NO;
    departmentButton.returnKeyType = UIReturnKeyDone;
    departmentButton.customTextFieldDelegate = self;
    self.departmentButton = departmentButton;
    [self createUIWithSuperView:self.thirdBg titleLabel:departmentLabel titleView:departmentButton];
    
    //所在地标题
    CGFloat locationLabelX = KEDGE_DISTANCE * 2;
    CGFloat locationLabelY = departmentButton.bottom;
    CGFloat locationLabelW = (bgImageViewW - locationLabelX * 2) * 0.3;
    CGFloat locationLabelH = SetUpFirstCellLabelHeight;
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationLabelX, locationLabelY, locationLabelW, locationLabelH)];
    locationLabel.text = @"所在地";
    ZYZCCustomTextField *locationButton = [[ZYZCCustomTextField alloc] init];
    locationButton.textColor = [UIColor lightGrayColor];
    locationButton.needAccess = NO;
    locationButton.returnKeyType = UIReturnKeyDone;
    locationButton.customTextFieldDelegate = self;
    locationButton.placeholder = @"请选择所在地";
    self.locationButton = locationButton;
    [self createUIWithSuperView:self.thirdBg titleLabel:locationLabel titleView:locationButton];
    
    self.thirdBg.layer.cornerRadius = 5;
    self.thirdBg.layer.masksToBounds = YES;
    self.thirdBg.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    self.thirdBg.height = (SetUpFirstCellLabelHeight * 5 + KEDGE_DISTANCE * 2);
}
/**
 *  第四个cell
 */
- (void)createFourthUI
{
    //背景白图
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = self.thirdBg.bottom + KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = 0;
    self.fourthBg = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    self.fourthBg.userInteractionEnabled = YES;
    [self addSubview:self.fourthBg];
    
    //邮箱标题
    CGFloat emailX = KEDGE_DISTANCE * 2;
    CGFloat emailY = KEDGE_DISTANCE;
    CGFloat emailW = (bgImageViewW - emailX * 2) * 0.3;
    CGFloat emailH = SetUpFirstCellLabelHeight;
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(emailX, emailY, emailW, emailH)];
    emailLabel.text = @"邮箱";
    
    ZYZCCustomTextField *emailButton = [[ZYZCCustomTextField alloc] init];
    emailButton.placeholder = @"请输入邮箱";
    emailButton.textColor = [UIColor lightGrayColor];
    emailButton.keyboardType = UIKeyboardTypeEmailAddress;
    emailButton.needAccess = NO;
    emailButton.returnKeyType = UIReturnKeyDone;
    emailButton.customTextFieldDelegate = self;
    self.emailButton = emailButton;
    [self createUIWithSuperView:self.fourthBg titleLabel:emailLabel titleView:emailButton];
    
    //qq
    CGFloat phoneLabelX = KEDGE_DISTANCE * 2;
    CGFloat phoneLabelY = emailButton.bottom;
    CGFloat phoneLabelW = (bgImageViewW - phoneLabelX * 2) * 0.3;
    CGFloat phoneLabelH = SetUpFirstCellLabelHeight;
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneLabelX, phoneLabelY, phoneLabelW, phoneLabelH)];
    phoneLabel.text = @"QQ";
    ZYZCCustomTextField *phoneButton = [[ZYZCCustomTextField alloc] init];
    phoneButton.textColor = [UIColor lightGrayColor];
    phoneButton.keyboardType = UIKeyboardTypeNumberPad;
    phoneButton.needAccess = YES;
    phoneButton.returnKeyType = UIReturnKeyDone;
    phoneButton.customTextFieldDelegate = self;
    phoneButton.placeholder = @"请输入QQ";
    self.phoneButton = phoneButton;
    [self createUIWithSuperView:self.fourthBg titleLabel:phoneLabel titleView:phoneButton];
    
    self.fourthBg.layer.cornerRadius = 5;
    self.fourthBg.layer.masksToBounds = YES;
    self.fourthBg.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    self.fourthBg.height = (SetUpFirstCellLabelHeight * 2 + KEDGE_DISTANCE * 2);
}

- (void)createSaveButton
{
    //保存按钮
    CGFloat saveButtonX = KEDGE_DISTANCE;
    CGFloat saveButtonY = self.fourthBg.bottom + KEDGE_DISTANCE;
    CGFloat saveButtonW = KSCREEN_W - 2 * saveButtonX;
    CGFloat saveButtonH = SetUpFirstCellLabelHeight *2;
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(saveButtonX, saveButtonY, saveButtonW, saveButtonH);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:20];
    saveButton.top = saveButtonY;
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    saveButton.titleLabel.textColor = [UIColor whiteColor];
    saveButton.backgroundColor = [UIColor ZYZC_MainColor];
    [saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    
    [self addSubview:saveButton];
    self.saveButton = saveButton;

}

- (void)createUIWithSuperView:(UIView *)superView titleLabel:(UILabel *)titleLabel titleView:(UIView *)titleView
{
    
    //标题
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    [superView addSubview:titleLabel];
    
    CGFloat titleViewX = titleLabel.right;
    CGFloat titleViewY = titleLabel.top;
    CGFloat titleViewW = superView.width - titleLabel.width - KEDGE_DISTANCE * 3;
    CGFloat titleViewH = titleLabel.height;
    
    titleView.frame = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    [superView addSubview:titleView];
}

#pragma mark - button点击方法

- (void)saveButtonAction:(UIButton *)button
{
    //点击保存的话做两层判断
    if (_wantFZC == YES) {
        //想发众筹的话，就是7个都是必填
        BOOL judge = [self judgeHasFZC];
        if (judge == NO) {
            //如果不通过就返回
            return ;
        }
    }else{
        //就是不想发众筹,然后就判断是否发过众筹
        if (_hasFZC == YES) {
            //有发过众筹的话，7个必填
            BOOL judge = [self judgeHasFZC];
            if (judge == NO) {
                //如果不通过就返回
                return;
            }
            
        }else{
            //没有发过的话，4个必填
            BOOL judge = [self judgeWantFZC];
            if (judge == NO) {
                //如果不通过就返回
                return;
            }
        }
    }
    
    //使用一个string来保存上一次的图片
    if (self.headView.iconImg) {
        [self.headView.iconView uploadImageToOSS:self.headView.iconImg andResult:^(BOOL result, NSString *imgUrl) {
            
            if (result == YES) {
                //上传成功
                [self uploadSelfInfo:imgUrl];
            }else{
                //上传失败
                [MBProgressHUD showError:@"头像上传失败"];
            }
        }];
        
    }else{
        [self uploadSelfInfo:_lastIconImg];
    }
    
}

- (void)uploadSelfInfo:(NSString *)headImgUrl
{
    
    [MBProgressHUD showMessage:@"正在上传" toView:self];
    
    NSString *userId = [ZYZCAccountTool getUserId];
    if (userId) {
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        [parameter setValue:userId forKey:@"userId"];
        
        if (_headView.image) {
            [parameter setValue:headImgUrl forKey:@"faceImg"];
        }
        
        if (_nameTextField.text.length > 0) {
            [parameter setValue:_nameTextField.text forKey:@"realName"];
        }
        if (_sexButton.text.length > 0) {
            if([_sexButton.text isEqualToString:@"男"]){
                [parameter setValue:[NSNumber numberWithInt:1]  forKey:@"sex"];
            }else if([_sexButton.text isEqualToString:@"女"]){
                [parameter setValue:[NSNumber numberWithInt:2]  forKey:@"sex"];
            }else{
                [parameter setValue:[NSNumber numberWithInt:0]  forKey:@"sex"];
            }
            
        }
        if (_birthButton.text.length > 0) {
            [parameter setValue:_birthButton.text forKey:@"birthday"];
        }
        if (_heightButton.text.length > 0) {
            [parameter setValue:_heightButton.text forKey:@"height"];
        }
        if (_weightButton.text.length > 0) {
            [parameter setValue:_weightButton.text forKey:@"weight"];
        }
        if (_constellationButton.text.length > 0) {
            [parameter setValue:_constellationButton.text forKey:@"constellation"];
        }
        if (_marryButton.text.length > 0) {
            if([_marryButton.text isEqualToString:@"单身"]){
                [parameter setValue:[NSNumber numberWithInt:0] forKey:@"maritalStatus"];
            }else if([_marryButton.text isEqualToString:@"恋爱中"]){
                [parameter setValue:[NSNumber numberWithInt:1]  forKey:@"maritalStatus"];
            }else{
                [parameter setValue:[NSNumber numberWithInt:2]  forKey:@"maritalStatus"];
            }
        }
        if (_emailButton.text.length > 0) {
            [parameter setValue:_emailButton.text forKey:@"mail"];
        }
        if (_companyButton.text.length > 0) {
            [parameter setValue:_companyButton.text forKey:@"company"];
        }
        if (_jobButton.text.length > 0) {
            [parameter setValue:_jobButton.text forKey:@"title"];
        }
        if (_schoolButton.text.length > 0) {
            [parameter setValue:_schoolButton.text forKey:@"school"];
        }
        if (_departmentButton.text.length > 0 ) {
            [parameter setValue:_departmentButton.text forKey:@"department"];
        }
        if (_province.length > 0) {
            [parameter setValue:_province forKey:@"province"];
        }
        if (_city.length > 0) {
            [parameter setValue:_city forKey:@"city"];
        }
        if (_district.length > 0) {
            [parameter setValue:_district forKey:@"district"];
        }
        if (_phoneButton.text.length > 0) {
            [parameter setValue:_phoneButton.text forKey:@"qq"];
        }
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"register_updateUserInfo"];
        @weakify(self);
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
            @strongify(self);
            DDLog(@"%@",result);
            [MBProgressHUD hideHUDForView:self];
            [MBProgressHUD showSuccess:@"保存成功"];
            [MBProgressHUD setAnimationDelay:2];
            [self.viewController.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoChange" object:nil];
            
            //名字有改动时重新获取融云的token
            if(parameter[@"realName"]||parameter[@"faceImg"])
            {
                //获取融云token
                ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
                accountModel.realName=parameter[@"realName"];
                accountModel.faceImg =parameter[@"faceImg"];
                
                [ZYZCAccountTool saveAccount:accountModel];
            }
            
        } andFailBlock:^(id failResult) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self];
            [MBProgressHUD showError:@"保存失败"];
            [MBProgressHUD setAnimationDelay:2];
        }];
        
    }
}

#pragma mark ---判断是否想发众筹
- (BOOL)judgeWantFZC
{
    //四个必填
    /**
     *  头像点击输入框
     */
    if(!_headView.image){
        [MBProgressHUD showError:ZYLocalizedString(@"hasSet_Error_icon")];
        return NO;
    }
    /**
     *  姓名点击输入框
     */
    if(_nameTextField.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    /**
     *  性别点击输入框
     */
    if(_sexButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasSet_Error_Sex")];
        return NO;
    }
    
    /**
     *  工作必填输入
     */
    if(_jobButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasSet_Error_Title")];
        return NO;
    }

    return YES;
}

- (BOOL)judgeHasFZC
{
    /**
     *  姓名点击输入框
     */
    if(_nameTextField.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    /**
     *  性别点击输入框
     */
    if(_sexButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    /**
     *  生日点击选择框
     */
    if(_birthButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    /**
     *  星座点击选择框
     */
    if(_constellationButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    
    /**
     *  婚姻状况选择框
     */
    if(_marryButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    /**
     *  身高点击选择框
     */
    if(_heightButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    /**
     *  体重点击选择框
     */
    if(_weightButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    
//        /**
//         *  公司输入
//         */
//        if(_companyButton.text.length <= 0){
//            [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_Company")];
//            return NO;
//        }
    /**
     *  职位输入
     */
    if(_jobButton.text.length <= 0){
        [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_FZC")];
        return NO;
    }
    return YES;
    
}

#pragma mark - set方法
/**
 *  刷新数据
 */
- (void)setMinePersonSetUpModel:(MinePersonSetUpModel *)minePersonSetUpModel
{
    //头视图
    _headView.minePersonSetUpModel = minePersonSetUpModel;
    
    self.lastIconImg = minePersonSetUpModel.faceImg;
    //后面的视图
    if (minePersonSetUpModel.realName.length > 0) {
        self.nameTextField.text = minePersonSetUpModel.realName;
    }
    if (minePersonSetUpModel.sex > 0) {
        if ([minePersonSetUpModel.sex intValue] == 0) {
            self.sexButton.text = @"保密";
        }else if ([minePersonSetUpModel.sex intValue] == 1){
            self.sexButton.text = @"男";
        }else{
            self.sexButton.text = @"女";
        }
    }
    if(minePersonSetUpModel.birthday.length > 0){
        _birthButton.text = minePersonSetUpModel.birthday;
    }
    if (minePersonSetUpModel.constellation.length > 0) {
        _constellationButton.text = minePersonSetUpModel.constellation;
    }
    if (minePersonSetUpModel.maritalStatus.length > 0) {
        if ([minePersonSetUpModel.maritalStatus intValue] == 0) {
            self.marryButton.text = ZYLocalizedString(@"maritalStatus_0");
        }else if ([minePersonSetUpModel.maritalStatus intValue] == 1){
            self.marryButton.text = ZYLocalizedString(@"maritalStatus_1");
        }else if ([minePersonSetUpModel.maritalStatus intValue] == 2)
        {
            self.marryButton.text = ZYLocalizedString(@"maritalStatus_2");
        }
    }
    if (minePersonSetUpModel.height > 0) {
        _heightButton.text = [NSString stringWithFormat:@"%d",minePersonSetUpModel.height];
    }
    if (minePersonSetUpModel.weight > 0) {
        _weightButton.text = [NSString stringWithFormat:@"%d",minePersonSetUpModel.weight] ;
    }
    if (minePersonSetUpModel.company.length > 0) {
        _companyButton.text = minePersonSetUpModel.company;
    }
    if (minePersonSetUpModel.title.length > 0) {
        _jobButton.text = minePersonSetUpModel.title;
    }
    if (minePersonSetUpModel.school.length > 0) {
        _schoolButton.text = minePersonSetUpModel.school;
    }
    if (minePersonSetUpModel.department.length > 0) {
        _departmentButton.text = minePersonSetUpModel.department;
    }
    //地名
    NSString *placeString = @"";
    if (minePersonSetUpModel.province.length > 0) {
        placeString = [placeString stringByAppendingString:minePersonSetUpModel.province];
        _province = minePersonSetUpModel.province;
    }
    if (minePersonSetUpModel.city.length > 0) {
        placeString = [placeString stringByAppendingString:minePersonSetUpModel.city];
        _city = minePersonSetUpModel.city;
    }
    if (minePersonSetUpModel.district.length > 0) {
        placeString = [placeString stringByAppendingString:minePersonSetUpModel.district];
        _district = minePersonSetUpModel.district;
    }
    _locationButton.text = placeString;
    
    if (minePersonSetUpModel.mail.length > 0) {
        _emailButton.text = minePersonSetUpModel.mail;
    }
    if (minePersonSetUpModel.qq.length > 0){
        _phoneButton.text = minePersonSetUpModel.qq;
    }

}

- (void)setWantFZC:(BOOL)wantFZC
{
    _wantFZC = wantFZC;
    
    //这里表示是否显示4个或者7个必填
    if (wantFZC == YES) {
        //7个
        _nameTextFieldXX.hidden = NO;
        _sexButtonXX.hidden = NO;
        _birthButtonXX.hidden = NO;
        _constellationButtonXX.hidden = NO;
        _marryButtonXX.hidden = NO;
        _heightButtonXX.hidden = NO;
        _weightButtonXX.hidden = NO;
        _jobButtonXX.hidden = NO;
        return;
    }else{
        if (_hasFZC == YES) {
            //7个
            //如果不通过就返回
            _nameTextFieldXX.hidden = NO;
            _sexButtonXX.hidden = NO;
            _birthButtonXX.hidden = NO;
            _constellationButtonXX.hidden = NO;
            _marryButtonXX.hidden = NO;
            _heightButtonXX.hidden = NO;
            _weightButtonXX.hidden = NO;
            _jobButtonXX.hidden = NO;
        }else{
            //4个
            _nameTextFieldXX.hidden = NO;
            _sexButtonXX.hidden = NO;
            _birthButtonXX.hidden = YES;
            _constellationButtonXX.hidden = YES;
            _marryButtonXX.hidden = YES;
            _heightButtonXX.hidden = YES;
            _weightButtonXX.hidden = YES;
            _jobButtonXX.hidden = NO;
            
        }
    }
}

#pragma mark - UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == _locationButton) {
        [_locationButton resignFirstResponder];
        
        STPickerArea *pickerArea = [[STPickerArea alloc]init];
        [pickerArea setDelegate:self];
        [pickerArea setContentMode:STPickerContentModeBottom];
        [pickerArea show];
        
    }else if (textField == _birthButton) {
        [_birthButton resignFirstResponder];
        
        STPickerDate *pickerDate = [[STPickerDate alloc]init];
        [pickerDate setDelegate:self];
        [pickerDate show];
    }else if (textField == _sexButton) {
        [_sexButton resignFirstResponder];
        //让其他的输入框弹回
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //弹出性别选择
        __weak typeof(&*self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.sexButton.text = @"男";
        }];
        UIAlertAction *girlAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.sexButton.text = @"女";
        }];
        UIAlertAction *unknownAction = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.sexButton.text = @"保密";
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:manAction];
        [alertController addAction:girlAction];
        [alertController addAction:unknownAction];
        
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }else if (textField == _marryButton) {
        [_marryButton resignFirstResponder];
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //弹出性别选择
        __weak typeof(&*self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *noMarrryAction = [UIAlertAction actionWithTitle:@"单身" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.marryButton.text = @"单身";
        }];
        UIAlertAction *lovingAction = [UIAlertAction actionWithTitle:@"恋爱中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.marryButton.text = @"恋爱中";
        }];
        UIAlertAction *marriedAction = [UIAlertAction actionWithTitle:@"已婚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.marryButton.text = @"已婚";
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:noMarrryAction];
        [alertController addAction:lovingAction];
        [alertController addAction:marriedAction];
        
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //如果是邮箱就判断格式
    if ([textField isEqual:_emailButton]) {
        if ([ZYZCTool validateEmail:_emailButton.text] == YES) {
            return;
        }else{
            _emailButton.text = nil;
            
            //弹出邮箱提示选择
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确格式的邮箱" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }else if ([textField isEqual:_companyButton] || [textField isEqual:_jobButton] || [textField isEqual:_schoolButton] || [textField isEqual:_departmentButton]){
        
        textField.text = [ZYZCTool filterEmoji:textField.text];
        
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}


#pragma mark ---notify
-(void)textFiledEditChanged:(NSNotification *)notify
{
    if ([notify.object isEqual:_nameTextField])
    {
        UITextField *textField = notify.object;
        if (textField.text.length>=Limit_Name_Length) {
            textField.text=[textField.text substringToIndex:Limit_Name_Length];
        }
    }
}

#pragma mark - requsetData方法

- (void)requestHadFZCData
{
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_checkMyProduct"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        //data为0表示没有发过众筹，1表示发过
        if ([result[@"data"] integerValue] == 0) {
            weakSelf.hasFZC = NO;
        }else{
            weakSelf.hasFZC = YES;
        }
    } andFailBlock:^(id failResult) {
        
    }];
}

#pragma mark - delegate方法
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    _province = province;
    _city = city;
    _district = area;
    _locationButton.text = text;
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year, (long)month, (long)day];
   _constellationButton.text = [ZYZCTool calculateConstellationWithMonth:month day:day];
    
    _birthButton.text = text;
}


- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

@end
