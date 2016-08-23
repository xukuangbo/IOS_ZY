//
//  GoalPeoplePickerView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "GoalPeoplePickerView.h"
#import "MoreFZCDataManager.h"
#define MIN_PEOPLE 2
@interface GoalPeoplePickerView ()
@property(nonatomic, strong) UILabel *numberLab;
@end

@implementation GoalPeoplePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.size=CGSizeMake(KSCREEN_W-4*KEDGE_DISTANCE, 60);
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    _numberLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, self.height)];
    _numberLab.font=[UIFont systemFontOfSize:30];
    _numberLab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_numberLab];
    
    CGFloat btnWidth=(self.width-50)/8;
    CGFloat btnHeight=42;
    for (int i=0; i<8; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_numberLab.right+(btnWidth)*i, (self.height-btnHeight)/2, btnWidth,btnHeight);
        [btn setImage:[UIImage imageNamed:@"icn_hum_pre"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"icn_hum"] forState:UIControlStateNormal];

        if (i<MIN_PEOPLE) {
            btn.selected=YES;
            btn.tag=KFZC_PERSON_BTN_TAG;
        }
        else
        {
            btn.selected=NO;
            btn.tag=KFZC_PERSON_BTN_TAG+(i-MIN_PEOPLE+1);
        }
        [btn addTarget:self action:@selector(chooseNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
#pragma mark --- btn点击事件
-(void)chooseNumber:(UIButton *)sender
{
    for (int i=KFZC_PERSON_BTN_TAG; i<KFZC_PERSON_BTN_TAG+8-(MIN_PEOPLE-1); i++) {
        UIButton *btn=(UIButton *)[self viewWithTag:i];
        if (i<=sender.tag) {
            btn.selected=YES;
        }
        else
        {
            btn.selected=NO;
        }
    }
    
    NSInteger myNumberPeople=MIN_PEOPLE+sender.tag-KFZC_PERSON_BTN_TAG;
    _numberLab.attributedText=[self changeTextFontAndColorByString:[NSString stringWithFormat:@"%zd人",myNumberPeople]];
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    manager.goal_numberPeople=[NSString stringWithFormat:@"%zd",myNumberPeople];
}

#pragma mark --- numberPeople的set方法
-(void)setNumberPeople:(NSInteger)numberPeople
{
    _numberPeople=numberPeople;
    if (numberPeople>=MIN_PEOPLE) {
        UIButton *btn=(UIButton *)[self viewWithTag:KFZC_PERSON_BTN_TAG+(_numberPeople-MIN_PEOPLE)];
        [self chooseNumber:btn];
    }
     _numberLab.attributedText=[self changeTextFontAndColorByString:[NSString stringWithFormat:@"%zd人",numberPeople]];
}

#pragma mark --- 字符串的字体更改
-(NSMutableAttributedString *)changeTextFontAndColorByString:(NSString *)str
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    if (str.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(str.length-1, 1)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_TextGrayColor] range:NSMakeRange(str.length-1, 1)];
    }
    return  attrStr;
}

@end
