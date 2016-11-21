//
//  CalendarViewController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CalendarViewController.h"
#import "WeekDayView.h"
#import "RMCalendarCollectionViewLayout.h"
#import "RMCollectionCell.h"
#import "RMCalendarMonthHeaderView.h"
#import "MBProgressHUD+MJ.h"
#import "MoreFZCDataManager.h"
#import "ZYCustomSegmentView.h"
typedef NS_ENUM(NSInteger, ChooseState) {
    ChooseNone,
    ChooseStart,
    ChooseStartAndBack
};

@interface CalendarViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) ZYCustomSegmentView *segmentedview;
@property (nonatomic, strong) NSArray *occupyDays;
@property (nonatomic, strong) NSDate  *selectDate;
@property (nonatomic, strong) RMCalendarModel *keepStartDateMdel;
@property (nonatomic, assign) ChooseState chooseState;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, assign) CellDayType preStyle;
@end


@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";

/**
 *  初始化模型数组对象
 */
- (NSMutableArray *)calendarMonth {
    if (!_calendarMonth) {
        _calendarMonth = [NSMutableArray array];
    }
    return _calendarMonth;
}

- (RMCalendarLogic *)calendarLogic {
    if (!_calendarLogic) {
        _calendarLogic = [[RMCalendarLogic alloc] init];
    }
    return _calendarLogic;
}

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr {
    self = [super init];
    if (!self) return nil;
    self.days = days;
    self.type = type;
    self.modelArr = modelArr;
    return self;
}

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type {
    self = [super init];
    if (!self) return nil;
    self.days = days;
    self.type = type;
    return self;
}

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr {
    return [[self alloc] initWithDays:days showType:type modelArrar:modelArr];
}

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type {
    return [[self alloc] initWithDays:days showType:type];
}

- (void)setModelArr:(NSMutableArray *)modelArr {
#if __has_feature(objc_arc)
    _modelArr = modelArr;
#else
    if (_modelArr != modelArr) {
        [_modelArr release];
        _modelArr = [modelArr retain];
    }
#endif
}

-(void)setIsEnable:(BOOL)isEnable {
    _isEnable = isEnable;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"旅行时间";
    _chooseState=ChooseNone;
    [self configUI];
}
-(void)configUI
{
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 50, 44) ;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(cleanData) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setTitle:@"重置" forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self createChooseView];
    [self createCollectionView];
    [self createBottomView];
    [self getMyOccupyDays];
}
-(void)createChooseView
{
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 64+KEDGE_DISTANCE, KSCREEN_W-2*KEDGE_DISTANCE, 90)];
    bgView.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"出发时间",@"返回时间",nil];
    _segmentedview =[[ZYCustomSegmentView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, bgView.width-2*KEDGE_DISTANCE, 30) andItems:segmentedArray];
    _segmentedview.selectedIndex = 0;
    [bgView addSubview:_segmentedview];
    
    _scheduleView=[[GoalScheduleView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _segmentedview.bottom+10, bgView.width-2*KEDGE_DISTANCE, 30)];
    _scheduleView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:_scheduleView];
    
    __weak typeof (&*self)weakSelf=self;
    _segmentedview.changeSelectIndex=^(NSInteger index)
    {
        if (index==0) {
            [weakSelf cleanData];
        }
        else if (index==1)
        {
            if (!weakSelf.startDate) {
                [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_startTime")];
                weakSelf.segmentedview.selectedIndex=0;
            }
        }
    };
}

-(void)cleanData
{
    _segmentedview.selectedIndex=0;
    self.calendarMonth = [self getMonthArrayOfDays:self.days showType:self.type isEnable:self.isEnable modelArr:self.modelArr];
    _keepStartDateMdel=nil;
    _chooseState=ChooseNone;
    _startDate=nil;
    _endDate=nil;
    [_scheduleView getNormalState];
    [self.collectionView reloadData];
}

-(void)changeSegmented:(UISegmentedControl *)segemented
{
    if (segemented.selectedSegmentIndex==0) {
        [self cleanData];
    }
}

//-(void)createShowTimeView
//{
//    _scheduleView=[[GoalScheduleView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_segmentedview.frame)+10, KSCREEN_W-20, 30)];
//    _scheduleView.backgroundColor=[UIColor whiteColor];
//    _scheduleView.layer.cornerRadius=5;
//    _scheduleView.layer.masksToBounds=YES;
//    [self.view addSubview:_scheduleView];
//}

-(void)createCollectionView
{
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 164+KEDGE_DISTANCE, KSCREEN_W-20, KSCREEN_H-_scheduleView.bottom-10)];
    bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    bgImg.userInteractionEnabled=YES;
    [self.view addSubview:bgImg];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"WeekDayView" owner:self options:nil];
    WeekDayView *weekDayView=[nib objectAtIndex:0];
    weekDayView.frame=CGRectMake(10, 2.5, bgImg.frame.size.width-20, 40);
    [bgImg addSubview:weekDayView];

    // 定义Layout对象
    RMCalendarCollectionViewLayout *layout = [[RMCalendarCollectionViewLayout alloc] init];
    
    // 初始化CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((bgImg.frame.size.width-COLLECTION_WIDTH)/2, CGRectGetMaxY(weekDayView.frame), COLLECTION_WIDTH, KSCREEN_H-bgImg.frame.origin.y-42.5-54) collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator=NO;
    
#if !__has_feature(objc_arc)
    [layout release];
#endif
    
    // 注册CollectionView的Cell
    [self.collectionView registerClass:[RMCollectionCell class] forCellWithReuseIdentifier:DayCell];
    
    [self.collectionView registerClass:[RMCalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
    //   self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [bgImg addSubview:self.collectionView];
    
    self.calendarMonth = [self getMonthArrayOfDays:self.days showType:self.type isEnable:self.isEnable modelArr:self.modelArr];
}

/**
 *  获取Days天数内的数组
 *
 *  @param days 天数
 *  @param type 显示类型
 *  @param arr  模型数组
 *  @return 数组
 */
- (NSMutableArray *)getMonthArrayOfDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable modelArr:(NSArray *)arr
{
    NSDate *date = [NSDate date];
    
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    
    _selectDate=manager.productEndTime?[[NSDate dateFromString:manager.productEndTime] dayInTheFollowingDay:1]:[[NSDate date] dayInTheFollowingDay:2] ;

    //返回数据模型数组
    return [self.calendarLogic reloadCalendarView:date selectDate:nil occupyDates:_occupyDays needDays:days showType:type isEnable:isEnable priceModelArr:arr];
}

#pragma mark --- 获取我已参与的日期
-(void )getMyOccupyDays
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *url=[NSString stringWithFormat:@"%@cache=false&orderType=1&pageNo=1&pageSize=100&userId=%@&status_not=0,2",GET_MY_OCCUPY_TIME,[ZYZCAccountTool getUserId]];
    
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"list_listMyProductsTime"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"false" forKey:@"cache"];
    [parameter setValue:@"1" forKey:@"orderType"];
    [parameter setValue:@"1" forKey:@"pageNo"];
    [parameter setValue:@"100" forKey:@"pageSize"];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    [parameter setValue:@"0,2" forKey:@"status_not"];
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        //        NSLog(@"%@",result);
        if (isSuccess) {
            NSDictionary *dateDic=result[@"data"];
            NSMutableArray *datesArr=[NSMutableArray array];
            for (int i=0; i<dateDic.count/2; i++) {
                NSString *startStr=[self changStrToDateStr:
                                    dateDic[[NSString stringWithFormat:@"startTime%d",i]]];
                NSString *endStr=[self changStrToDateStr:
                                  dateDic[[NSString stringWithFormat:@"EndTime%d",i]]];
                
                NSDate *startDate= [NSDate dateFromString:startStr];
                NSDate *endDate  = [NSDate dateFromString:endStr];
                if (startDate) {
                    NSArray *dateArr=[NSDate getDatesBetweenDate:startDate toDate:endDate];
                    for (NSDate *date in dateArr) {
                        BOOL hasExit=NO;
                        for (NSDate *obj in datesArr) {
                            if ([date isEqual:obj]) {
                                hasExit=YES;
                            }
                        }
                        if (!hasExit) {
                            [datesArr addObject:date];
                        }
                    }
                    [datesArr addObject:endDate];
                }
            }
            _occupyDays=datesArr;
            self.calendarMonth = [self getMonthArrayOfDays:self.days showType:self.type isEnable:self.isEnable modelArr:self.modelArr];
            [_collectionView reloadData];
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.view];

    }];
}

#pragma mark --- 将2016-1-1格式转成2016-01－01
-(NSString *)changStrToDateStr:(NSString *)string
{
    if (string.length==10) {
        return string;
    }
    
    NSMutableArray *subArr=[NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"-"]];
    for (int i=0;i<subArr.count;i++) {
        NSString *str=subArr[i];
        if (str.length<2) {
            NSString *newStr=[NSString stringWithFormat:@"0%@",str];
            [subArr replaceObjectAtIndex:i withObject:newStr];
        }
    }
    return [subArr componentsJoinedByString:@"-"];
}

#pragma mark - CollectionView 数据源

// 返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.calendarMonth.count;
}
// 返回每组行数
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arrary = [self.calendarMonth objectAtIndex:section];
    return arrary.count;
}

#pragma mark - CollectionView 代理

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    NSArray *months = [self.calendarMonth objectAtIndex:indexPath.section];
    RMCalendarModel *model =[months objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        RMCalendarModel *model = [month_Array objectAtIndex:15];
        
        RMCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
        monthHeader.backgroundColor = [UIColor whiteColor] ;
        reusableview = monthHeader;
    }
    return reusableview;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *months = [self.calendarMonth objectAtIndex:indexPath.section];
    RMCalendarModel *model = [months objectAtIndex:indexPath.row];
    
    //已过去的时间不可选
    if (model.style == CellDayTypePast)
    {
        return;
    }
    /**
     *  选择出发时间与返回时间
     *
     */
    
    if (_chooseState==ChooseStartAndBack)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否重新选择时间段" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    
    //选择开始时间
    else if (_chooseState==ChooseNone) {
        //截止日期之前不可选
        if ([NSDate compareDate:model.date withDate:[_selectDate dayInTheFollowingDay:0]]==1) {
            [MBProgressHUD showShortMessage:@"该时刻出发时间不可选"];
            return;
        }

        _keepStartDateMdel=model;
        if ((model.style == CellDayTypeClick || model.style == CellDayTypeFutur || model.style == CellDayTypeWeek)&&model.style!=CellDayTypeNoPassOccupy) {
            CellDayType cellDayType=model.style;
            [self.calendarLogic selectLogic:model PreStyle:_preStyle];
            _preStyle=cellDayType;
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_startChoose_time")];
            return;
        }
        _segmentedview.selectedIndex=1;
        //将开始日期显示到界面上
        _scheduleView.startDay=[NSDate stringFromDate:model.date];
        _startDate=model.date;
        //记录已选出发时间状态
        _chooseState=ChooseStart;
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_endTime")];
    }
    else if(_chooseState==ChooseStart)//选择返回时间
    {
        //返回时间小于等于出发时间时
        if ([NSDate compareDate:_keepStartDateMdel.date withDate:model.date]<=0) {
            [MBProgressHUD showShortMessage:@"返回时间不可小于出发时间"];
            return;
        }
        //返回时间大于出发时间，判断时间段内是否存在已安排时间
        for (NSDate *obj in _occupyDays) {
            if ([NSDate compareDate:_keepStartDateMdel.date withDate:obj]==1){
                if ([NSDate compareDate:obj withDate:model.date]==1) {
                    [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_endChoose_time")];
                    return;
                }
            }
        }
        if (model.style == CellDayTypeClick || model.style == CellDayTypeFutur || model.style == CellDayTypeWeek) {
            //更改选中状态
            [self.calendarLogic changeStateToCellDayTypeClick:model];
            //将返回日期显示到界面上
            
            _scheduleView.endDay=[NSDate stringFromDate:model.date];
            _endDate=model.date;
            _travelTotalDays=[NSDate getDayNumbertoDay:_keepStartDateMdel.date beforDay:model.date];
            
            self.sureBtn.enabled=YES;//确定按钮可点击
        }
        _chooseState=ChooseStartAndBack;
    }
    
    [self.collectionView reloadData];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self cleanData];
    }
}

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

#pragma mark --- 复写父类点击方法
-(void)clickBtn
{
    if (!_startDate) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_startTime")];
        return;
    }
    if(!_endDate)
    {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_endTime")];
        return;
    }
    //单例纪录开始时间
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    manager.goal_startDate=[NSDate stringFromDate:_startDate];
    //单例纪录返回时间
    manager.goal_backDate=[NSDate stringFromDate:_endDate];
    //单例纪录旅行总天数
    manager.goal_TotalTravelDay=[NSString stringWithFormat:@"%zd", _travelTotalDays+1];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //当众筹截止时间距出发时间少于15天时，弹出提示框。
    //“你的出行前准备时间太短，记得提前与旅伴联系哦”
    
//    if (manager.productEndTime)
//    {
//        int number=[NSDate getDayNumbertoDay:[NSDate dateFromString:manager.productEndTime] beforDay:[NSDate dateFromString:manager.goal_startDate]];
//        if(number<=15){
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"截止时间距出发时间%d天",number] message:@"您的出行前准备时间太短，记得提前与旅伴联系哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }

}

-(void)dealloc {
#if !__has_feature(objc_arc)
    [self.collectionView release];
    [super dealloc];
#endif
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
