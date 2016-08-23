//
//  GoalScheduleView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "GoalScheduleView.h"
@interface GoalScheduleView ()
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *backLab;
@property (nonatomic, strong) UILabel *centerLab;
@end

@implementation GoalScheduleView

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
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    _startLab=[self createLabWithFrame:CGRectMake(0, 0, (self.width-15)/2, self.height)];
    [self addSubview:_startLab];
    _backLab=[self createLabWithFrame:CGRectMake((self.width+15)/2, 0, (self.width-15)/2, self.height)];
    [self addSubview:_backLab];
    _centerLab=[self createLabWithFrame:CGRectMake(_startLab.right, 0, 15, self.height)];
    _centerLab.text=@"~";
//    [self initViews];
    [self addSubview:_centerLab];
    [self getNormalState];
}

#pragma mark --- 一般状态下
-(void)getNormalState
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_startDate&&manager.goal_backDate) {
        _startLab.text=[self changeDateString:manager.goal_startDate] ;
        _startLab.textColor=[UIColor ZYZC_TextGrayColor];
        _backLab.text=[self changeDateString:manager.goal_backDate];
        _backLab.textColor=[UIColor ZYZC_TextGrayColor];
        _centerLab.textColor=[UIColor ZYZC_TextGrayColor];
    }
}

-(void)initViews
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_startDate&&manager.goal_backDate) {
        self.startDay=manager.goal_startDate;
        self.endDay=manager.goal_backDate;
        return;
    }
    _startLab.text=[ZYZCTool getLocalDate];
    _startLab.textColor=[UIColor ZYZC_TextGrayColor];
    _backLab.text=[ZYZCTool getLocalDate];
    _backLab.textColor=[UIColor ZYZC_TextGrayColor];
}

-(void)setStartDay:(NSString *)startDay
{
    _startDay=startDay;
    _startLab.text=[self changeDateString:startDay];
    _startLab.textColor=[UIColor ZYZC_TextBlackColor];
    _centerLab.textColor=[UIColor ZYZC_TextBlackColor];;
}

-(void)setEndDay:(NSString *)endDay
{
    _endDay =endDay;
    _backLab.text=[self changeDateString:endDay];
     _backLab.textColor=[UIColor ZYZC_TextBlackColor];
}

-(UILabel *)createLabWithFrame:(CGRect)frame
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=[UIFont systemFontOfSize:20];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor ZYZC_TextGrayColor];
    return lab;
}

#pragma mark --- “2016-06－01” to “2016/06/01”
-(NSString *)changeDateString:(NSString *)dateStr
{
    NSArray *arr=[dateStr componentsSeparatedByString:@"-"];
    NSString *newDateStr=[arr componentsJoinedByString:@"/"];
    return newDateStr;
}


@end












