//
//  ReturnThirdCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#import "ReturnCellBaseBGView.h"
#import "ReturnThirdCell.h"
#import "MoreFZCViewController.h"
#import "MoreFZCReturnTableView.h"
#import "UIView+GetSuperTableView.h"
@interface ReturnThirdCell ()

@end

@implementation ReturnThirdCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configUI];
    }
    return self;
}

#pragma mark - system方法

#pragma mark - setUI方法
- (void)configUI
{
    [self createBgView];
    
    [self createPeopleView];
    
    MoreFZCDataManager  *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if ([manager.return_returnPeopleStatus isEqualToString:@"1"]) {
        _peopleView.userInteractionEnabled=YES;
        if (_bgImageView.iconButtonClickBlock) {
            _bgImageView.iconButtonClickBlock();
        }
    }
}

- (void)createBgView
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    ReturnCellBaseBGView *bgImageView = [ReturnCellBaseBGView viewWithRect:CGRectMake(ReturnThirdCellMargin, 0, KSCREEN_W - 20, ReturnThirdCellHeight) title:@"回报众筹" image:[UIImage imageNamed:@"btn_xs_one_n_pre"] selectedImage:[UIImage imageNamed:@"btn_xs_one_pre"] desc:ZYLocalizedString(@"support_return")];
    bgImageView.index = 2;
    self.bgImageView = bgImageView;
    [self.contentView addSubview:bgImageView];
    self.bgImageView.userInteractionEnabled = YES;
//    self.bgImageView.backgroundColor = [UIColor redColor];
    __weak typeof(&*self) weakSelf = self;
    
    
    _bgImageView.descLabelClickBlock = ^(){
        
            MoreFZCReturnTableView *tableView = ((MoreFZCReturnTableView *)weakSelf.getSuperTableView);
            //取到当前的row
            NSIndexPath *indexPath = [tableView indexPathForCell:weakSelf];
            
            BOOL isOpen = [tableView.openArray[indexPath.row] intValue];
            
            if (isOpen == NO) {
                //这里要改变里面的内容
                CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_return") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
                tableView.heightArray[indexPath.row] = @(ReturnThirdCellHeight + textSize.height - BgDescLabelNormalHeight);
                tableView.openArray[indexPath.row] = @1;
                
            }else
            {
                tableView.heightArray[indexPath.row] = @(ReturnThirdCellHeight);
                tableView.openArray[indexPath.row] = @0;
            }
            
            [tableView reloadData];
    };
    
    //图片点击动作
    
    _bgImageView.iconButtonClickBlock = ^(){
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        weakSelf.bgImageView.iconButton.selected = !weakSelf.bgImageView.iconButton.selected;
//        if (weakSelf.bgImageView.iconButton.selected == YES) {
//            self.peopleView.userInteractionEnabled=YES;
//        }else{
//            self.peopleView.userInteractionEnabled=NO;
//        }
        
        //这里要存到单例里面去
        [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleStatus = [NSString stringWithFormat:@"%zd",_bgImageView.iconButton.selected];
    };
}

/**
 *  创建可以填写的view
 */
- (void)createPeopleView
{
    UIView *peopleView = [[UIView alloc] initWithFrame:CGRectMake(ReturnThirdCellMargin, self.bgImageView.descLabel.bottom + ReturnThirdCellMargin, self.bgImageView.width-2*KEDGE_DISTANCE, 200+CONTENTHEIGHT)];
    [self.bgImageView addSubview:peopleView];
    self.peopleView = peopleView;
//    self.peopleView.userInteractionEnabled=NO;
    
    self.peopleTextfiled = [self viewWithFrame:CGRectMake(0, 1, self.peopleView.width, 81) titleName:@"人数设置:" leftViewName:nil textfiledPlaceholder:@"请输入人数"];
    self.peopleTextfiled.keyboardType=UIKeyboardTypeNumberPad;
    if ([MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleNumber) {
        self.peopleTextfiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleNumber;
    }
    __weak typeof (&*self)weakSelf=self;
    self.peopleTextfiled.tapBgViewBlock=^()
    {
        [weakSelf textFieldShouldReturn:weakSelf.peopleTextfiled];
    };
    
    self.moneyTextFiled = [self viewWithFrame:CGRectMake(0, self.peopleTextfiled.bottom + 2, self.peopleView.width, 81) titleName:@"支持金额:" leftViewName:@"￥" textfiledPlaceholder:@"00.00元"];
    if ([MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleNumber) {
        self.moneyTextFiled.text = [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleMoney;
    }
    
    self.moneyTextFiled.tapBgViewBlock=^()
    {
        [weakSelf textFieldShouldReturn:weakSelf.moneyTextFiled];
    };
    
    //先创建一个标题view
    //1.灰色虚线
    UIView *entrylineView = [UIView lineViewWithFrame:CGRectMake(0, self.moneyTextFiled.bottom * 2 + 10, self.peopleView.width-2*KEDGE_DISTANCE, 1) andColor:[UIColor ZYZC_LineGrayColor]];
    [self.peopleView addSubview:entrylineView];
    //2.1创建人数设置
    UILabel *entryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, entrylineView.bottom, self.peopleView.width, 30)];
    entryTitleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    entryTitleLabel.text = @"回报描述";
    [self.peopleView addSubview:entryTitleLabel];
    
    //创建完后可以创建哪个语音录入的内容
    _entryView = [[FZCContentEntryView alloc] initWithFrame:CGRectMake(0, entryTitleLabel.bottom, self.peopleView.width, CONTENTHEIGHT)];
    _entryView.contentBelong=RETURN_01_CONTENTBELONG;
    _entryView.placeHolderText=@"你可以发挥自己的技能特长为支持者提供实物回报或服务，如代购产品、目的地特产、旅拍摄影、翻译等";
    [self.peopleView addSubview:_entryView];
    
    //_entryView加载数据
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    [_entryView reloadDataByWord:manager.return_wordDes andImgUrlStr:manager.return_imgUrlStr andVoiceUrl:manager.return_voiceUrl andVoiceLen:manager.return_voiceLen andVideoUrl:manager.return_movieUrl andVideoImg:manager.return_movieImg];
    
}
#pragma mark - requsetData方法

#pragma mark - set方法
- (void)setOpen:(BOOL)open
{
        _open = open;
        
        if (open == YES) {
            //这里就是展开，改变所有东西的值
            NSString *support_return = ZYLocalizedString(@"support_return");
            CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:support_return andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
            self.bgImageView.height = ReturnThirdCellHeight + textSize.height - BgDescLabelNormalHeight;
            self.bgImageView.descLabel.numberOfLines = 0;
            self.bgImageView.descLabel.height = textSize.height;
            self.bgImageView.downButton.bottom = self.bgImageView.descLabel.bottom;
            
            self.peopleView.top = self.bgImageView.descLabel.bottom + ReturnThirdCellMargin;
            
        }else{
            //低二高度
            CGFloat thirdRowHeight = 0;
            CGSize thirdSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_return") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
            if (thirdSize.height <= 71) {
                thirdRowHeight = thirdSize.height + (277 + CONTENTHEIGHT);
                self.bgImageView.descLabel.userInteractionEnabled = NO;
                self.bgImageView.descLabel.height = thirdSize.height;
                self.bgImageView.descLabel.height = thirdSize.height;
                self.bgImageView.downButton.hidden = YES;
            }else{
                thirdRowHeight = ReturnThirdCellHeight;
                self.bgImageView.descLabel.height = BgDescLabelNormalHeight;
                self.bgImageView.descLabel.height = 71;
                self.bgImageView.downButton.hidden = NO;
            }
            
            self.bgImageView.height = thirdRowHeight;
            self.bgImageView.descLabel.numberOfLines = 3;
            self.bgImageView.downButton.bottom = self.bgImageView.descLabel.bottom;
            self.peopleView.top = self.bgImageView.descLabel.bottom + ReturnThirdCellMargin;
        }
    
}

#pragma mark - button点击方法

#pragma mark - delegate方法

/**
 *  用于创建两个比较相似的view，金钱和人数设置
 */
- (ZYZCCustomTextField *)viewWithFrame:(CGRect)frame titleName:(NSString *)titleName leftViewName:(NSString *)leftName textfiledPlaceholder:(NSString *)placeholder
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.peopleView addSubview:view];
    //1.灰色虚线
    UIView *lineView = [UIView lineViewWithFrame:CGRectMake(0, 0, view.width-2*KEDGE_DISTANCE, 1) andColor:[UIColor ZYZC_LineGrayColor]];
    [view addSubview:lineView];
    //2.1创建人数设置
    UILabel *numberPeopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, view.width, 30)];
    numberPeopleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    numberPeopleLabel.text = titleName;
    [view addSubview:numberPeopleLabel];
    
    //2.2创建人数设置输入框
    //这里应该创建一个00.00元的textfiled
    ZYZCCustomTextField *TextFiled = [[ZYZCCustomTextField alloc] init];
    TextFiled.left = 77.5;
    TextFiled.height = 40;
    TextFiled.top = numberPeopleLabel.bottom + ReturnThirdCellMargin;
    TextFiled.width = view.width - TextFiled.left * 2;
    TextFiled.textAlignment = NSTextAlignmentCenter;
    TextFiled.returnKeyType = UIReturnKeyDone;
    TextFiled.keyboardType=UIKeyboardTypeDecimalPad;
//    TextFiled.text = placeholder;
    TextFiled.placeholder = placeholder;
    TextFiled.customTextFieldDelegate = self;
//    TextFiled.textColor = [UIColor ZYZC_TextGrayColor];
    TextFiled.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    TextFiled.clearsOnBeginEditing = YES;
//    TextFiled.backgroundColor = [UIColor cyanColor];
    [view addSubview:TextFiled];
    

    //￥钱的字样
    if (leftName) {
        UILabel *sightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TextFiled.height, TextFiled.height)];
        sightLabel.textAlignment = NSTextAlignmentCenter;
        sightLabel.font = [UIFont systemFontOfSize:15];
        sightLabel.text = leftName;
        TextFiled.leftView = sightLabel;
        TextFiled.leftViewMode = UITextFieldViewModeAlways;
    }
    return TextFiled;
}


- (void)reloadManagerData
{
    MoreFZCDataManager *mgr = [MoreFZCDataManager sharedMoreFZCDataManager];
    if (mgr.return_returnPeopleNumber) {
        self.peopleTextfiled.text = mgr.return_returnPeopleNumber;
    }
    if (mgr.return_returnPeopleMoney) {
        self.moneyTextFiled.text = mgr.return_returnPeopleMoney;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_peopleTextfiled]) {
        if ([textField.text integerValue] > 1000) {
            
            textField.text = nil;
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"回报众筹人数上限为一千人" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertVC addAction:sureAction];
            
            [self.viewController presentViewController:alertVC animated:YES completion:nil];
            
            return NO;
        }else if ([textField.text integerValue] == 0) {
            
            textField.text = nil;
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"回报人数不能为0" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertVC addAction:sureAction];
            
            [self.viewController presentViewController:alertVC animated:YES completion:nil];
            
            return NO;
        }
        else{
            self.bgImageView.iconButton.selected=NO;
            _bgImageView.iconButtonClickBlock();
//            NSLog(@"没超过");
            
            return YES;
        }

    }else if ([textField isEqual:_moneyTextFiled]){
        CGFloat totalMoney = [[MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney floatValue];
        if ([textField.text floatValue] > totalMoney) {
            
            textField.text = nil;
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"回报金额上限不能超过预筹金额" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertVC addAction:sureAction];
            
            [self.viewController presentViewController:alertVC animated:YES completion:nil];
            
            return NO;
        }else if ([textField.text floatValue] == 0) {
            
            textField.text = nil;
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"回报众筹金额不能为0" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertVC addAction:sureAction];
            
            [self.viewController presentViewController:alertVC animated:YES completion:nil];
            
            return NO;
        }
        else{
            self.bgImageView.iconButton.selected=NO;
            _bgImageView.iconButtonClickBlock();
//            NSLog(@"没超过");
            return YES;
        }
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_peopleTextfiled) {
        if (_peopleTextfiled.text.length > 0) {
//            NSLog(@"________%@",_peopleTextfiled.text);
            
            [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleNumber = self.peopleTextfiled.text;
        }
        
    }else if (textField== _moneyTextFiled){
        
//        NSLog(@"________%@",_moneyTextFiled.text);
        [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleMoney = self.moneyTextFiled.text;
    }
    
}
//
//- (void)editingDidEnd:(NSNotification *)notification
//{
//    if ([notification.object isEqual:_peopleTextfiled]) {
//        if (_peopleTextfiled.text.length > 0) {
//            NSLog(@"________%@",_peopleTextfiled.text);
//            
//            [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleNumber = self.peopleTextfiled.text;
//        }
//        
//    }else if ([notification.object isEqual:_moneyTextFiled]){
//        
//        NSLog(@"________%@",_moneyTextFiled.text);
//        [MoreFZCDataManager sharedMoreFZCDataManager].return_returnPeopleMoney = self.moneyTextFiled.text;
//    }
//}
@end
