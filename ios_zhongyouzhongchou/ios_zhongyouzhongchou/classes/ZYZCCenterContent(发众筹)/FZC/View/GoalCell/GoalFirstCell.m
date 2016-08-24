//
//  GoalFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//
/**
 *  最多目的地数（包括出发地）
 */
#define MAX_NUM_DEST 8

#import "GoalFirstCell.h"
#import "MoreFZCChooseSceneController.h"
#import "CalendarViewController.h"
#import "GoalScheduleView.h"
#import "NecessaryView.h"
#import "MoreFZCDataManager.h"
#import "ChooseTimeViewController.h"
@interface GoalFirstCell()
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) GoalScheduleView *scheduleView;
@property (nonatomic, strong) UIButton *startDestBtn;//出发地
@property (nonatomic, strong) UIImageView *arrowImg; //箭头
@property (nonatomic, strong) UIButton *firstDestBtn;//第一个目的地
@property (nonatomic, strong) UIView   *otherDestsView;//其他目的地
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) GoalPeoplePickerView *peoplePickerView;

@property (nonatomic, strong) FZCSingleTitleView *stopTitleView;

@property (nonatomic, strong) UILabel *productEndTimeLab;//截止时间

@property (nonatomic, assign) CGFloat lastSceneX;
@property (nonatomic, strong) NSMutableArray *sceneArr;//目的地视图
@property (nonatomic, strong) NSMutableArray *sceneTitleArr;//目的地名
@end

@implementation GoalFirstCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)configUI
{
    [super configUI];
    self.bgImg.height=FIRSTCELLHEIGHT;
    self.titleLab.text=@"旅行目的地";
    _lastSceneX=0;
    _sceneArr=[NSMutableArray array];
    
    //旅游目的地添加到该_scroll上
    _scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(2*KEDGE_DISTANCE, self.topLineView.bottom, KSCREEN_W-5*KEDGE_DISTANCE-30, 35)];
    _scroll.contentSize=CGSizeMake(_scroll.width, 0);
    _scroll.showsHorizontalScrollIndicator=NO;
    [self.contentView addSubview:_scroll];
    
    //添加出发地
    _startDestBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _startDestBtn.frame=CGRectMake(0, 5, 80, _scroll.height-5);
    [_startDestBtn addTarget:self action:@selector(chooseDest:) forControlEvents:UIControlEventTouchUpInside];
     [_startDestBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    [_scroll addSubview:_startDestBtn];
    
    //添加箭头
    _arrowImg=[[UIImageView alloc]init];
    _arrowImg.frame=CGRectMake(_startDestBtn.right+KEDGE_DISTANCE, 20, 15, 5);
    _arrowImg.image=[UIImage imageNamed:@"icn_des_jt"];
    [_scroll addSubview:_arrowImg];

    //添加第一个目的地
    _firstDestBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _firstDestBtn.frame=CGRectMake(_arrowImg.right+KEDGE_DISTANCE, 5, 80, _scroll.height-5);
    [_firstDestBtn addTarget:self action:@selector(chooseDest:) forControlEvents:UIControlEventTouchUpInside];
     [_firstDestBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
     [_scroll addSubview:_firstDestBtn];
    
    
    //添加其他的目的地
    _otherDestsView=[[UIView alloc]initWithFrame:CGRectMake(_firstDestBtn.right, 0, 1, _scroll.height)];
    [_scroll addSubview:_otherDestsView];
    
    [self changeStartDestButton];
    [self changeFirstDestButton];

    //创建添加目的地按钮
    _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame=CGRectMake(_scroll.right+KEDGE_DISTANCE, CGRectGetMaxY(self.topLineView.frame)+5, 30, 30);
    [_addBtn setImage:[UIImage imageNamed:@"btn_and"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addScene) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    _addBtn.enabled=NO;
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_goals.count>=2) {
        _addBtn.enabled=YES;
        if (manager.goal_goals.count>=MAX_NUM_DEST) {
            _addBtn.enabled=NO;
        }
        for (NSInteger i=2; i<manager.goal_goals.count; i++) {
            [self addSceneByTitle:manager.goal_goals[i]];
        }
    }
    
    //旅行截止时间标题
    [self createStopTimeView];
    
    //旅行时间,出游人数标题
    NSArray *titleArr=@[@"旅行时间",@"旅伴人数（含自己）"];
    for (int i=0; i<2; i++) {
        UILabel *tavelTimeLab=[self createLabAndUnderlineWithFrame:CGRectMake(2*KEDGE_DISTANCE, _stopTitleView.bottom+10+70*i, self.bgImg.width-2*KEDGE_DISTANCE, 20) andTitle:titleArr[i]];
        [self.contentView addSubview:tavelTimeLab];
    }
    
    //添加旅行日程显示视图
    _scheduleView=[[GoalScheduleView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE*2, _stopTitleView.bottom+40, KSCREEN_W-40, 40)];
    [self.contentView addSubview:_scheduleView];
    
//    //添加旅行数据到日期视图上
//    if (manager.goal_startDate&&manager.goal_backDate) {
//        _scheduleView.startDay=manager.goal_startDate;
//        _scheduleView.endDay=manager.goal_backDate;
//    }
    
    //添加点击手势在日程显示视图上
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getSchedule:)];
    [_scheduleView addGestureRecognizer:tap];
    
    //添加人数选择视图
    _peoplePickerView=[[GoalPeoplePickerView alloc]initWithFrame:CGRectMake(2*KEDGE_DISTANCE, _stopTitleView.bottom+110, 0, 0)];
    if (manager.goal_numberPeople) {
        _peoplePickerView.numberPeople=[manager.goal_numberPeople integerValue];
    }
    else{
        _peoplePickerView.numberPeople=4;
    }
    [self.contentView addSubview:_peoplePickerView];
}

#pragma mark --- 截止时间
 
- (void)createStopTimeView
{
    CGFloat stopTitleViewX = 2 * KEDGE_DISTANCE;
    CGFloat stopTitleViewY = _scroll.bottom + KEDGE_DISTANCE;
    CGFloat stopTitleViewW = KSCREEN_W - 2 * stopTitleViewX;
    CGFloat stopTitleViewH = 35;
    
    _productEndTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(stopTitleViewX, stopTitleViewY, stopTitleViewW, stopTitleViewH)];
    _productEndTimeLab.font=[UIFont systemFontOfSize:20];
    _productEndTimeLab.textColor=[UIColor ZYZC_TextGrayColor];
    
    _stopTitleView = [[FZCSingleTitleView alloc] initWithTitle:@"众筹截止时间" ContentView:_productEndTimeLab];
    [self.contentView addSubview:_stopTitleView];
    
    [_stopTitleView addTarget:self action:@selector(chooseProductEndTime)];
    
    //初始化截止时间数据显示
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    NSDate *date=[[NSDate alloc]init];
    _productEndTimeLab.text=manager.productEndTime?[ZYZCTool turnDateToCustomDate:[NSDate dateFromString:manager.productEndTime]]:[ZYZCTool turnDateToCustomDate:[date dayInTheFollowingDay:1]];
    
    CGFloat dateWidth=[ZYZCTool calculateStrLengthByText:_productEndTimeLab.text andFont:_productEndTimeLab.font andMaxWidth:_productEndTimeLab.width].width;
    [_productEndTimeLab addSubview:[UIView lineViewWithFrame:CGRectMake(0, _productEndTimeLab.height-1, dateWidth, 1) andColor:nil]];
}

#pragma mark --- 选择众筹截止时间
-(void)chooseProductEndTime
{
    ChooseTimeViewController *calendarChooseVC=[ChooseTimeViewController calendarWithDays:365 showType:CalendarShowTypeMultiple];
    __weak typeof(&*self)weakSelf=self;
    calendarChooseVC.chooseDateBlock=^(NSDate *date)
    {
        //改变截止时间
        weakSelf.productEndTimeLab.text=[ZYZCTool turnDateToCustomDate:date];
        weakSelf.productEndTimeLab.textColor=[UIColor ZYZC_TextBlackColor];
    };
    
    [self.viewController.navigationController pushViewController:calendarChooseVC animated:YES];
}

#pragma mark --- 选择行程日期
-(void)getSchedule:(UITapGestureRecognizer *)tap
{
    CalendarViewController *calendarVC=[CalendarViewController calendarWithDays:365 showType:CalendarShowTypeMultiple];
    __weak typeof (&*self)weakSelf=self;
    calendarVC.confirmBlock=^()
    {
        MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
        if (manager.goal_startDate.length) {
            weakSelf.scheduleView.startDay=manager.goal_startDate;
            }
        if (manager.goal_backDate.length) {
            weakSelf.scheduleView.endDay=manager.goal_backDate;
        }
    };
    [self.viewController.navigationController pushViewController:calendarVC animated:YES];
}

#pragma mark --- 选择出发地和第一个目的地
-(void)chooseDest:(UIButton *)button
{
     MoreFZCChooseSceneController *chooseScenceVC=[[MoreFZCChooseSceneController  alloc]init];
    chooseScenceVC.mySceneArr=_sceneTitleArr;
     __weak typeof (&*self)weakSelf=self;
    if (button==_startDestBtn) {
        chooseScenceVC.isStartDest=YES;
        chooseScenceVC.getOneScene=^(NSString *scene)
        {
            MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
            [manager.goal_goals replaceObjectAtIndex:0 withObject:scene];
            [weakSelf changeStartDestButton];
        };
    }
    if (button==_firstDestBtn) {
        chooseScenceVC.getOneScene=^(NSString *scene)
        {
            MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
            if (manager.goal_goals.count==1) {
                [manager.goal_goals addObject:scene];
            }
            else if (manager.goal_goals.count>=2){
                [manager.goal_goals replaceObjectAtIndex:1 withObject:scene];
            }
            weakSelf.addBtn.enabled=YES;
            [weakSelf changeFirstDestButton];
        };
    }
    [self.viewController.navigationController pushViewController:chooseScenceVC animated:YES];
}


#pragma mark --- 添加其他目的地
-(void)addScene
{
    MoreFZCChooseSceneController *chooseScenceVC=[[MoreFZCChooseSceneController  alloc]init];
    chooseScenceVC.mySceneArr=_sceneTitleArr;
    __weak typeof (&*self)weakSelf=self;
    chooseScenceVC.getOneScene=^(NSString *scene)
    {
        [weakSelf.sceneTitleArr addObject:scene];//将目的地名称保存在数组中
        MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
        manager.goal_goals=weakSelf.sceneTitleArr;//单例纪录目的地
        [weakSelf addSceneByTitle:scene];
        if (weakSelf.sceneTitleArr.count>=MAX_NUM_DEST) {
            weakSelf.addBtn.enabled=NO;
        }
    };
    chooseScenceVC.mySceneArr=_sceneTitleArr;
    [self.viewController.navigationController pushViewController:chooseScenceVC animated:YES];
}

#pragma mark --- 通过目的地名称添加目的地视图
-(void)addSceneByTitle:(NSString *)title
{
    UIView *oneScenceView=[self createOneSceneWithOriginX:_lastSceneX andTitle:title];
    [_sceneArr addObject:oneScenceView];//添加到数组中
    [_otherDestsView addSubview:oneScenceView];//添加到scroll中
    //记录最后一个目的地的位置
    _lastSceneX=oneScenceView.right;
    //改变_otherDestsView长度
    _otherDestsView.width=_lastSceneX+6;
    //改变scroll的画布大小
    _scroll.contentSize=CGSizeMake(_otherDestsView.right, 0);
    //设置scroll的偏移量来显示最新添加的目的地
    CGFloat offSet_x=_scroll.contentSize.width-_scroll.width;
    if (_scroll.contentSize.width-_scroll.width>0) {
        _scroll.contentOffset=CGPointMake(offSet_x, 0) ;
    }
}

#pragma mark --- 添加某个目的地
-(UIView *)createOneSceneWithOriginX:(CGFloat )originX andTitle:(NSString *)title
{
    CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:title andFont:[UIFont systemFontOfSize:17] andMaxWidth:KSCREEN_W].width+20;
    
    //view为底部视图
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(originX, 5, titleWidth+35, _scroll.height-5)];
  
    //添加箭头到view上
    UIImageView *arrowImg=[[UIImageView alloc]init];
    arrowImg.frame=CGRectMake(10, 15, 15, 5);
    arrowImg.image=[UIImage imageNamed:@"icn_des_jt"];
    [view addSubview:arrowImg];
  
    //添加btn在view上
    CGFloat btnOrginX=arrowImg.right+10;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(btnOrginX, 0, titleWidth, view.height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteScene:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    //添加下划线在按钮上
    [btn addSubview:[UIView lineViewWithFrame:CGRectMake(0, btn.height-1, btn.width, 1) andColor:nil]];
    //添加删除键在按钮上
    UIImageView *deleteImg=[[UIImageView alloc]initWithFrame:CGRectMake(btn.width-6, 0, 12, 12)];
    deleteImg.image=[UIImage imageNamed:@"icn_xxcc"];
    [btn addSubview:deleteImg];
    return view;
}

#pragma mark --- 删除某个目的地
-(void)deleteScene:(UIButton *)sender
{
    //删除目的地
    UIView *sceneView=sender.superview;
    //视图从数组中删除
    [_sceneArr removeObject:sceneView];
    //目的地从数组中删除
    [_sceneTitleArr removeObject:sender.titleLabel.text];
    //单例纪录目的地
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    manager.goal_goals=_sceneTitleArr;
    //视图从父视图上删除
    [sceneView removeFromSuperview];
    _lastSceneX=0;
    _otherDestsView.width=0;
    _scroll.contentSize=CGSizeMake(0, 0);
    _scroll.contentOffset=CGPointMake(0,0);
    if (_sceneArr.count>0) {
        //删除其他目的地的视图和视图数组中的内容
        for (NSInteger i=_sceneArr.count-1; i>=0; i--) {
            UIView *subView=(UIView *)_sceneArr[i];
            [_sceneArr removeObject:subView];
            [subView removeFromSuperview];
        }
        //重新添加其他目的地视图
        for (int i=2; i<_sceneTitleArr.count; i++) {
            [self addSceneByTitle:_sceneTitleArr[i]];
        }
    }
    
    if (_sceneTitleArr.count<MAX_NUM_DEST) {
        _addBtn.enabled=YES;
    }
}

#pragma mark --- 改变出发地按钮
-(void)changeStartDestButton
{
    UIView *line=(UIView *)[_startDestBtn viewWithTag:1];
    [line removeFromSuperview];
    UIImageView *turn=(UIImageView *)[_startDestBtn viewWithTag:2];
    [turn removeFromSuperview];
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    NSString *startDest=[manager.goal_goals firstObject];
    [_startDestBtn setTitle:startDest forState:UIControlStateNormal];
    CGFloat startDestWidth=[ZYZCTool calculateStrLengthByText:startDest andFont:[UIFont systemFontOfSize:17] andMaxWidth:KSCREEN_W].width+20;
    _startDestBtn.width=startDestWidth;
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, _startDestBtn.height-1, _startDestBtn.width, 1) andColor:nil];
    lineView.tag=1;
    [_startDestBtn addSubview:lineView];
    
    UIImageView *turnImg=[[UIImageView alloc]initWithFrame:CGRectMake(_startDestBtn.width-6,0, 12, 12)];
    turnImg.image=[UIImage imageNamed:@"change"];
    turnImg.tag=2;
    [_startDestBtn addSubview:turnImg];
    
    _arrowImg.left=_startDestBtn.right+KEDGE_DISTANCE;
    _firstDestBtn.left=_arrowImg.right+KEDGE_DISTANCE;
    _otherDestsView.left=_firstDestBtn.right;
    _scroll.contentSize=CGSizeMake(_otherDestsView.right, 0);
     _sceneTitleArr=[NSMutableArray arrayWithArray:manager.goal_goals];
}

#pragma mark ---改变第一个目的地
-(void)changeFirstDestButton
{
    UIView *line=(UIView *)[_firstDestBtn viewWithTag:1];
    [line removeFromSuperview];
    UIImageView *turn=(UIImageView *)[_firstDestBtn viewWithTag:2];
    [turn removeFromSuperview];
    
     MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    NSString *firstDest=@"目的地";
    if (manager.goal_goals.count>=2) {
        firstDest=manager.goal_goals[1];
    }
    [_firstDestBtn setTitle:firstDest forState:UIControlStateNormal];
    
    CGFloat firstDestWidth=[ZYZCTool calculateStrLengthByText:firstDest andFont:[UIFont systemFontOfSize:17] andMaxWidth:KSCREEN_W].width+20;
    
    _firstDestBtn.width=firstDestWidth;
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, _firstDestBtn.height-1, _firstDestBtn.width, 1) andColor:nil];
    lineView.tag=1;
    
    [_firstDestBtn addSubview:lineView];
    
    UIImageView *turnImg=[[UIImageView alloc]initWithFrame:CGRectMake(_firstDestBtn.width-6,0, 12, 12)];
    turnImg.image=[UIImage imageNamed:@"change"];
    turnImg.tag=2;
    [_firstDestBtn addSubview:turnImg];
     _otherDestsView.left=_firstDestBtn.right;
     _scroll.contentSize=CGSizeMake(_otherDestsView.right, 0);
     _sceneTitleArr=[NSMutableArray arrayWithArray:manager.goal_goals];
}

#pragma mark --- 刷新数据 人数是否发生改变
-(void)reloadViews
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_numberPeople) {
        _peoplePickerView.numberPeople=[manager.goal_numberPeople integerValue];
    }
    else
    {
        _peoplePickerView.numberPeople=4;
    }
}

//#pragma mark - UITextfieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    
//    textField.backgroundColor = [UIColor colorWithRed:arc4random() %256 / 256.0 green:arc4random()%256 / 256.0 blue:arc4random()%256 / 256.0 alpha:1];
//}
@end
