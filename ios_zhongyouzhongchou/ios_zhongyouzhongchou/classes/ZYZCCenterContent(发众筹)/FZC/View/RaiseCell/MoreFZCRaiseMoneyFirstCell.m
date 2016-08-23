//
//  MoreFZCRaiseMoneyFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#import "MoreFZCRaiseMoneyFirstCell.h"
#import "MoreFZCViewController.h"
#import "MBProgressHUD+MJ.h"
@implementation MoreFZCRaiseMoneyFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}




/**
 *  重写configUI方法，此方法在父视图的init方法里面调用
 */
- (void)configUI
{
    [super configUI];
    self.bgImg.height= kRaiseMoneyRealHeight;
    self.titleLab.text= @"预筹旅费金额(元)";
    
    //然后呢，我可以在这里添加一个明细的按钮
    [self createOpenButton];
    
    [self createDetailView];
    
    if ([MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_sightMoney) {
        self.moneyTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_sightMoney;
    }else{
//        self.sightTextfiled.text = nil;
    }
    if ([MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_transMoney) {
        self.transportTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_transMoney;
    }else{
//        self.transportTextfiled.text = nil;
    }
    if ([MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_liveMoney) {
        self.liveTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_liveMoney;
    }else{
//        self.liveTextfiled.text = nil;
    }
    if ([MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_eatMoney) {
        self.eatTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_eatMoney;
    }else{
//        self.eatTextfiled.text = nil;
    }
    if ([MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney) {
        self.moneyTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney;
    }else{
        //        self.eatTextfiled.text = nil;
    }
    
}

/**
 *  创建明细按钮
 */
- (void)createOpenButton
{
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.hidden = YES;
    openButton.frame = CGRectMake(0, 15 , 80, 25);
    openButton.right = self.bgImg.width;
    [openButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [openButton setTitle:@"添加明细" forState:UIControlStateNormal];
    [openButton setTitle:@"点击收起" forState:UIControlStateSelected];
    //设置边框颜色
    openButton.layer.borderWidth = 1;
    openButton.layer.borderColor = [UIColor ZYZC_MainColor].CGColor;
    openButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //设置圆角
    openButton.layer.cornerRadius = 5;
    openButton.clipsToBounds = YES;
    //添加点击动作
    [openButton addTarget:self action:@selector(openButtonACtion:) forControlEvents:UIControlEventTouchUpInside];
    self.openButton = openButton;
    [self.contentView addSubview:openButton];
}
/**
 *  明细内容的view
 */
- (void)createDetailView
{
    //创建一个添加明细的view
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(self.titleLab.left + KEDGE_DISTANCE, self.titleLab.bottom + KEDGE_DISTANCE * 2, self.titleLab.width, 100)];
//    detailView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:detailView];
    self.detailView = detailView;
    
    //这里应该创建一个6000元的textfiled
    ZYZCCustomTextField *moneyTextFiled = [[ZYZCCustomTextField alloc] init];
    moneyTextFiled.customTextFieldDelegate = self;
    moneyTextFiled.left = KEDGE_DISTANCE;
    moneyTextFiled.height = 40;
    moneyTextFiled.bottom = detailView.height - 10;
    moneyTextFiled.width = detailView.width - KEDGE_DISTANCE * 2;
    moneyTextFiled.textAlignment = NSTextAlignmentCenter;
    UILabel *sightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, moneyTextFiled.height, moneyTextFiled.height)];
    sightLabel.textAlignment = NSTextAlignmentCenter;
    sightLabel.font = [UIFont systemFontOfSize:15];
    moneyTextFiled.leftView = sightLabel;
    moneyTextFiled.clearsOnBeginEditing = YES;
    moneyTextFiled.leftViewMode = UITextFieldViewModeAlways;
    sightLabel.text = @"￥";
    moneyTextFiled.placeholder = @"0.00 元";
    [detailView addSubview:moneyTextFiled];
    self.moneyTextfiled = moneyTextFiled;
    self.moneyTextfiled.keyboardType=UIKeyboardTypeDecimalPad;
    self.moneyTextfiled.customTextFieldDelegate=self;
    
    __weak typeof (&*self )weakself=self;
    self.moneyTextfiled.tapBgViewBlock=^()
    {
        [weakself textFieldShouldReturn:weakself.moneyTextfiled];
    };
    
    //在明细的view里面添加4个内容
    
    self.sightTextfiled = [self textfiledWithCGRect:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE + (35 + KEDGE_DISTANCE) * 0, detailView.width - KEDGE_DISTANCE * 2, 35) superView:detailView leftViewTitle:@"景点:"];
    self.transportTextfiled = [self textfiledWithCGRect:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE + (35 + KEDGE_DISTANCE) * 1, detailView.width - KEDGE_DISTANCE * 2, 35) superView:detailView leftViewTitle:@"交通:"];
    self.liveTextfiled = [self textfiledWithCGRect:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE + (35 + KEDGE_DISTANCE) * 2, detailView.width - KEDGE_DISTANCE * 2, 35) superView:detailView leftViewTitle:@"住宿:"];
    self.eatTextfiled = [self textfiledWithCGRect:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE + (35 + KEDGE_DISTANCE) * 3, detailView.width - KEDGE_DISTANCE * 2, 35) superView:detailView leftViewTitle:@"餐饮:"];
    
}


/**
 *  创建4个输入框
 */
- (ZYZCCustomTextField *)textfiledWithCGRect:(CGRect)rect superView:(UIView *)superView leftViewTitle:(NSString *)title
{
    ZYZCCustomTextField *sightTextfiled = [[ZYZCCustomTextField alloc] initWithFrame:rect];
    sightTextfiled.font = [UIFont systemFontOfSize:15];
    sightTextfiled.textColor = [UIColor ZYZC_TextGrayColor];
    sightTextfiled.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    sightTextfiled.hidden = YES;
    [superView addSubview:sightTextfiled];
//    sightTextfiled.backgroundColor = [UIColor blueColor];
    sightTextfiled.keyboardType = UIKeyboardTypeDecimalPad;
    sightTextfiled.returnKeyType = UIReturnKeyDone;
    sightTextfiled.clearsOnBeginEditing = YES;
    //设置左边的文字
    UILabel *sightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sightTextfiled.height, sightTextfiled.height)];
    sightLabel.textColor = [UIColor ZYZC_TextGrayColor];
    sightLabel.font = [UIFont systemFontOfSize:15];
//    sightLabel.backgroundColor = [UIColor cyanColor];
    sightTextfiled.leftView = sightLabel;
    sightTextfiled.leftViewMode = UITextFieldViewModeAlways;
    sightLabel.text = title;
    sightTextfiled.customTextFieldDelegate = self;
    
    return sightTextfiled;
}

- (void)setOpen:(BOOL)open
{
        _open = open;
    
        if (open == YES) {//1
            //这里就是展开，改变所有东西的值
            self.bgImg.height = 120 + 200;
            self.openButton.selected = YES;
            self.sightTextfiled.hidden = self.transportTextfiled.hidden = self.liveTextfiled.hidden = self.eatTextfiled.hidden = NO;
            self.detailView.height = 200 + 60;
            self.moneyTextfiled.bottom = self.detailView.height - KEDGE_DISTANCE;
            
        }else{
            //这里就是收起，改变所有东西的值
            self.bgImg.height = 120;
            self.openButton.selected = NO;
            self.sightTextfiled.hidden = self.transportTextfiled.hidden = self.liveTextfiled.hidden = self.eatTextfiled.hidden = YES;
            self.detailView.height = 60;
            self.moneyTextfiled.bottom = self.detailView.height - KEDGE_DISTANCE;
        }
}



/**
 *  添加明细点击事件,交给tableview处理？
 */
- (void)openButtonACtion:(UIButton *)button
{
    self.open = !self.open;
    
    //这里的算钱是为了防止他们直接点返回
    if ([MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney){
        self.moneyTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney;
    }
    
    if (self.open == YES) {
        self.sightTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_sightMoney;
        self.transportTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_transMoney;
        self.liveTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_liveMoney;
        self.eatTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_eatMoney;
    }else{
        [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_sightMoney = self.sightTextfiled.text;
        [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_transMoney = self.transportTextfiled.text;
        [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_liveMoney = self.liveTextfiled.text;
        [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_eatMoney = self.eatTextfiled.text;
    }
    

    
    if (self.changeHeightBlock) {
         self.changeHeightBlock(self.open);
    }
    
}
#pragma mark - UITextFliedDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text integerValue] > 1000000) {
        
        textField.text = nil;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"预筹金额不得超过一百万" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertVC addAction:sureAction];
        
        [self.viewController presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
    }else if ([textField.text floatValue] == 0) {
        
        textField.text = nil;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"欲筹金额不能为0" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertVC addAction:sureAction];
        
        [self.viewController presentViewController:alertVC animated:YES completion:nil];
        
        return  NO;
    }else{
//        NSLog(@"没超过");
        return YES;
    }
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //监听键盘的出现和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
    
}

#pragma mark --- 键盘出现方法
-(void)keyboardWillShow:(NSNotification *)notify
{
    self.openButton.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardHide:(NSNotification *)notify
{
    //键盘隐藏的时候
    self.openButton.enabled = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //让键盘的openbtn可以点击
    CGFloat totalMoney = 0;
    if (textField == self.moneyTextfiled) {
        totalMoney = [self.moneyTextfiled.text floatValue];
    }else{
        totalMoney = [self.transportTextfiled.text floatValue]+ [self.sightTextfiled.text floatValue] + [self.liveTextfiled.text floatValue] + [self.eatTextfiled.text floatValue];
    }
    //这里可以拿到数据，存到单例里面去
    [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney = [NSString stringWithFormat:@"%.2f",totalMoney];
    
    self.moneyTextfiled.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_sightMoney = self.sightTextfiled.text;
    [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_transMoney = self.transportTextfiled.text;
    [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_liveMoney = self.liveTextfiled.text;
    [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_eatMoney = self.eatTextfiled.text;
    
    
}



///**
// *  点击空白让键盘落下
// */
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.moneyTextfiled endEditing:YES];
//    [self.sightTextfiled endEditing:YES];
//    [self.transportTextfiled endEditing:YES];
//    [self.liveTextfiled endEditing:YES];
//    [self.eatTextfiled endEditing:YES];
//    
//    CGFloat totalMoney = [self.transportTextfiled.text floatValue]+ [self.sightTextfiled.text floatValue] + [self.liveTextfiled.text floatValue] + [self.eatTextfiled.text floatValue];
//    [MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney = [NSString stringWithFormat:@"%.2f",totalMoney];
//    self.moneyTextfiled.text = [NSString stringWithFormat:@"%.2f",totalMoney];
//}
@end
