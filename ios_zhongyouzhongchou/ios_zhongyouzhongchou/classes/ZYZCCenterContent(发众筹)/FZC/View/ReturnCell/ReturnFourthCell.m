//
//  ReturnFourthCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ReturnFourthCell.h"
#import "GoalPeoplePickerView.h"
#import "MoreFZCReturnTableView.h"
#import "UIView+GetSuperTableView.h"
#import "FZCContentEntryView.h"
@interface ReturnFourthCell ()
@property (nonatomic, weak) GoalPeoplePickerView *pickerView;

@property (nonatomic, weak) UIButton *lastButton;
/**
 *  用于存放的大view
 */
@property (nonatomic, weak) UIView *bigContentView;

@property (nonatomic, strong) FZCContentEntryView *contentEntryView;

@end
@implementation ReturnFourthCell


#pragma mark - system方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        ReturnCellBaseBGView *bgImageView = [ReturnCellBaseBGView viewWithRect:CGRectMake(ReturnFourthCellMargin, 0, KSCREEN_W - ReturnFourthCellMargin * 2, ReturnFourthCellHeight) title:@"一起游" image:[UIImage imageNamed:@"btn_xs_one"] selectedImage:nil desc:ZYLocalizedString(@"support_together")];
        [self.contentView addSubview:bgImageView];
        self.bgImageView = bgImageView;
        self.bgImageView.userInteractionEnabled = YES;
        self.bgImageView.index = 3;
        
        __weak typeof(&*self) weakSelf = self;
        
        
        _bgImageView.descLabelClickBlock = ^(){
                MoreFZCReturnTableView *tableView = ((MoreFZCReturnTableView *)weakSelf.getSuperTableView);
                //取到当前的row
                ReturnFourthCell *cell = (ReturnFourthCell *)weakSelf;
                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                
                BOOL isOpen = [tableView.openArray[indexPath.row] intValue];
                
                if (isOpen == NO) {
                    //这里要改变里面的内容
                    CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_together") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
                    tableView.heightArray[indexPath.row] = @(ReturnFourthCellHeight + textSize.height - self.bgImageView.descLabel.height );
                    tableView.openArray[indexPath.row] = @1;
                    
                }else
                {
                    tableView.heightArray[indexPath.row] = @(ReturnFourthCellHeight);
                    tableView.openArray[indexPath.row] = @0;
                }
                
                [tableView reloadData];
        };
        
        /**
         *  创建大内容视图
         */
        [self createBigContentView];
        /**
         *  添加描述内容
         */
        [self createWSMView];
        /**
         *  这里开始写出游人数
         */
        [self createOutplaypeople];
        /**
         *  支持金额
         */
        [self createMoneyView];
    }
    return self;
}

/**
 *  创建大内容视图
 */
- (void)createBigContentView
{
    CGFloat bigContentViewX = 0;
    CGFloat bigContentViewY = self.bgImageView.descLabel.bottom + ReturnFourthCellMargin;
    CGFloat bigContentViewW = self.bgImageView.width;
    CGFloat bigContentViewH = self.bgImageView.height - self.bgImageView.descLabel.bottom - ReturnFourthCellMargin;
    UIView *bigContentView = [[UIView alloc] initWithFrame:CGRectMake(bigContentViewX, bigContentViewY, bigContentViewW, bigContentViewH)];
    [self.bgImageView addSubview:bigContentView];
    self.bigContentView = bigContentView;
}

#pragma mark --- 添加图文、语音、视频
-(void) createWSMView
{
    //1.灰色虚线
    UIView *outPeoplelineView = [UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, 0, self.bigContentView.width-2*KEDGE_DISTANCE, 1) andColor:[UIColor ZYZC_LineGrayColor]];
    [self.bigContentView addSubview:outPeoplelineView];

    _contentEntryView=[[FZCContentEntryView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, 0,0)];
    _contentEntryView.contentBelong=TOGTHER_CONTENTBELONG;
    [self.contentView addSubview:_contentEntryView];
    _contentEntryView.videoAlertText=nil;
//    _contentEntryView.placeHolderText=TRAVEL_PLACEHOLSER;
    [self.bigContentView addSubview:_contentEntryView];
    
    //_contentEntryView加载数据
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    [_contentEntryView reloadDataByWord:manager.return_togtherWordDes andImgUrlStr:manager.return_togtherImgUrlStr andVoiceUrl:manager.return_togtherVoice andVideoUrl:manager.return_togtherVideo andVideoImg:manager.return_togtherVideoImg];
}

/**
 *  这里开始写出游人数
 */
- (void)createOutplaypeople
{
    //这里开始写出游人数
    //1.灰色虚线
    UIView *outPeoplelineView = [UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, _contentEntryView.bottom+KEDGE_DISTANCE, self.bigContentView.width-2*KEDGE_DISTANCE, 1) andColor:[UIColor ZYZC_LineGrayColor]];
    [self.bigContentView addSubview:outPeoplelineView];

    //2.1创建人数设置
    UILabel *entryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ReturnFourthCellMargin, outPeoplelineView.bottom, self.bgImageView.width - ReturnFourthCellMargin * 2, 30)];
    entryTitleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    entryTitleLabel.text = @"旅伴人数（含自己）:";
    [self.bigContentView addSubview:entryTitleLabel];
    
    //人数设置封装的view,给个属性接收
    GoalPeoplePickerView *pickerView = [[GoalPeoplePickerView alloc] initWithFrame:CGRectMake(ReturnFourthCellMargin, entryTitleLabel.bottom, 0, 0)];
    //读取第二个界面的人数
    if ([MoreFZCDataManager sharedMoreFZCDataManager].goal_numberPeople) {
        pickerView.numberPeople = [[MoreFZCDataManager sharedMoreFZCDataManager].goal_numberPeople integerValue];
    }else{
        pickerView.numberPeople = 4;
    }
    self.pickerView = pickerView;
    [self.bigContentView addSubview:pickerView];
    
}
/**
 *  支持金额
 */
- (void)createMoneyView
{
    //1.灰色虚线
    UIView *outPeoplelineView = [UIView lineViewWithFrame:CGRectMake(ReturnFourthCellMargin, self.pickerView.bottom + 10, self.bigContentView.width - ReturnFourthCellMargin * 2, 1) andColor:[UIColor ZYZC_LineGrayColor]];
    [self.bigContentView addSubview:outPeoplelineView];
    //2.1创建金额设置
    UILabel *entryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ReturnFourthCellMargin, outPeoplelineView.bottom, self.bigContentView.width - ReturnFourthCellMargin * 2, 30)];
    entryTitleLabel.text = @"支持旅费（旅费众筹金额的百分比）";
    entryTitleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    [self.bigContentView addSubview:entryTitleLabel];
    
    //这里创建一个view是那种view
    UIImageView *peopleMoneyView = [[UIImageView alloc] initWithFrame:CGRectMake(ReturnFourthCellMargin , entryTitleLabel.bottom, self.bigContentView.width - ReturnFourthCellMargin * 2, 40)];
    peopleMoneyView.image = [UIImage imageNamed:@"jdt_zer"];
    peopleMoneyView.height = (CGFloat)peopleMoneyView.image.size.height / peopleMoneyView.image.size.width * peopleMoneyView.width;
    peopleMoneyView.userInteractionEnabled = YES;
    //添加4个button
    CGFloat buttonW = peopleMoneyView.width * 0.25;
    CGFloat buttonH = peopleMoneyView.height;
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonW * i, 0, buttonW, buttonH);
        button.showsTouchWhenHighlighted = YES;
        button.tag = i;
        [peopleMoneyView addSubview:button];
        //设置最开始的lastbutton
        if (i == 0) {
            self.lastButton = button;
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.peopleMoneyView = peopleMoneyView;
    [self.bigContentView addSubview:peopleMoneyView];
    
    //最后一个，金额的显示
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.width, 40)];
    moneyLabel.centerX = peopleMoneyView.centerX;
    moneyLabel.centerY = peopleMoneyView.bottom + 0.5 * moneyLabel.height;
//    moneyLabel.backgroundColor = [UIColor redColor];
    self.moneyLabel = moneyLabel;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.bigContentView addSubview:moneyLabel];
    
    NSInteger returnCellSupportButton = 0;
    //这里是为了给他一个初始值
    [self changeMoneyCountByTag:returnCellSupportButton];
}

/**
 *  根据给的tag值去改变图片
 */
- (void)changeMoneyCountByTag:(NSInteger)tag
{
    
    switch (tag) {
        case 0:
            self.peopleMoneyView.image = [UIImage imageNamed:@"jdt_zer"];
            break;
        case 1:
            self.peopleMoneyView.image = [UIImage imageNamed:@"jdt_fiv"];
            break;
        case 2:
            self.peopleMoneyView.image = [UIImage imageNamed:@"jdt_ten"];
            break;
        case 3:
            self.peopleMoneyView.image = [UIImage imageNamed:@"jdt_fif"];
            break;
        default:
            break;
    }
    //百分比
    CGFloat f = tag * 0.05;
    //这里应该改变文字
    CGFloat returnMoneyCount = [[MoreFZCDataManager sharedMoreFZCDataManager].raiseMoney_totalMoney floatValue] * f;
    
    NSString *moneyString = [NSString stringWithFormat:@"￥ %.2f 元",returnMoneyCount];
    [self changeMoneyLabelStringWithString:moneyString];
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    manager.return_togetherRateMoney= [NSString stringWithFormat:@"%f",returnMoneyCount];
    
}



#pragma mark - setUI方法

#pragma mark - requsetData方法

#pragma mark - set方法

- (void)setOpen:(BOOL)open
{
    _open = open;
    
    if (open == YES) {
        //这里就是展开，改变所有东西的值
        NSString *support_together = ZYLocalizedString(@"support_together");
        CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:support_together andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        self.bgImageView.height = ReturnFourthCellHeight + textSize.height - self.bgImageView.descLabel.height;
        self.bgImageView.descLabel.numberOfLines = 0;
        self.bgImageView.descLabel.height = textSize.height;
        self.bgImageView.downButton.bottom = self.bgImageView.descLabel.bottom;
        self.bgImageView.downButton.hidden = YES;
        
        self.bigContentView.top = self.bgImageView.descLabel.bottom + ReturnFourthCellMargin;
        
    }else{
        //第四高度
        CGFloat fourthRowHeight = 0;
        CGSize fourthSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_together") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        if (fourthSize.height <= 71) {//真正的高度
            fourthRowHeight = fourthSize.height + 307;
            self.bgImageView.descLabel.userInteractionEnabled = NO;
            self.bgImageView.descLabel.height = fourthSize.height;
            self.bgImageView.downButton.hidden = YES;
        }else{
            fourthRowHeight = ReturnFourthCellHeight;
            self.bgImageView.descLabel.height = BgDescLabelNormalHeight;
            self.bgImageView.downButton.hidden = NO;
        }
        
        self.bgImageView.height = fourthRowHeight;
        self.bgImageView.descLabel.numberOfLines = 3;
        self.bgImageView.downButton.bottom = self.bgImageView.descLabel.bottom;
        self.bigContentView.top = self.bgImageView.descLabel.bottom + ReturnFourthCellMargin;
    }
}
#pragma mark - button点击方法

- (void)reloadManagerData
{
    MoreFZCDataManager *mgr = [MoreFZCDataManager sharedMoreFZCDataManager];
    if (mgr.goal_numberPeople) {
        self.pickerView.numberPeople = [mgr.goal_numberPeople integerValue];
    }
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSNumber *supportType=[user objectForKey:KMOREFZC_RETURN_SUPPORTTYPE];
    if (supportType) {
        [self changeMoneyCountByTag:[supportType integerValue]];
    }
    
    [user setObject:nil forKey:KMOREFZC_RETURN_SUPPORTTYPE];
    [user synchronize];
    
    NSInteger buttonTag=0;
    if ([mgr.return_togetherMoneyPercent isEqualToString:@"5"]) {
        buttonTag=1;
    }
    else if([mgr.return_togetherMoneyPercent isEqualToString:@"10"])
    {
        buttonTag=2;
    }
    else if([mgr.return_togetherMoneyPercent isEqualToString:@"15"])
    {
        buttonTag=3;
    }
    [self changeMoneyCountByTag:buttonTag];
}
#pragma mark - delegate方法
/**
 *  选金额的点击效果
 */
- (void)buttonAction:(UIButton *)button
{
//    if (self.lastButton == button) {
//        return;
//    }
    [self changeMoneyCountByTag:button.tag];
    self.lastButton = button;
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithInteger:button.tag] forKey:KMOREFZC_RETURN_SUPPORTTYPE];
    [user synchronize];
}

/**
 *  显示label的金钱数字
 */
- (void)changeMoneyLabelStringWithString:(NSString *)string
{
//    NSLog(@"%ld",string.length);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(attrString.length - 1, 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(attrString.length - 1, 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(2, string.length - 4)];
    self.moneyLabel.attributedText = attrString;
    
    
}

@end
