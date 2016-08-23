//
//  RMCalendarLogic.m
//  RMCalendar
//


#import "RMCalendarLogic.h"

@interface RMCalendarLogic()

/**
 *  今天的日期
 */
@property (nonatomic, strong) NSDate *today;
/**
 *  之后的日期
 */
@property (nonatomic, strong) NSDate *before;
/**
 *  选中的日期
 */
@property (nonatomic, strong) NSDate *select;

/**
 *  已占用时间段
 */
@property (nonatomic, strong) NSArray *occupyDays;
/**
 *  日期模型
 */
@property (nonatomic, strong) RMCalendarModel *model;
/**
 *  价格模型数组
 */
//@property (nonatomic, strong) NSArray *priceModelArr;

@property (nonatomic, assign) BOOL isEnable;

@end

@implementation RMCalendarLogic

//#warning 初始化 模型数组，可根据功能进行修改
//- (NSArray *)priceModelArr {
//    if (!_priceModelArr) {
//        _priceModelArr = [NSArray array];
//    }
//    return _priceModelArr;
//}

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate occupyDates:(NSArray *)occupyDays needDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable priceModelArr:(NSArray *)arr {
    self.isEnable = isEnable;
    return [self reloadCalendarView:date selectDate:selectDate occupyDates:occupyDays needDays:days showType:type priceModelArr:arr];
}

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate occupyDates:(NSArray *)occupyDays needDays:(int)days showType:(CalendarShowType)type priceModelArr:(NSArray *)arr {
//#warning 此处根据自己需求可修改
    // 存放价格模型
//    self.priceModelArr = arr;
    return [self reloadCalendarView:date selectDate:selectDate occupyDates:occupyDays needDays:days showType:type];
}

- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate occupyDates:(NSArray *)occupyDays needDays:(int)days showType:(CalendarShowType)type {
    //如果为空就从当天的日期开始
    if(date == nil){
        date = [NSDate date];
    }
    
    //默认选择中的时间
//    if (selectDate == nil) {
//        selectDate = date;
//    }
    
    self.today = date;//起始日期
    
    self.before = [date dayInTheFollowingDay:days];//计算它days天以后的时间
    
    self.select = selectDate;//选择的日期
    
    self.occupyDays=occupyDays;//已占用时间段
    
    NSDateComponents *todayDC= [self.today YMDComponents];
    
    NSDateComponents *beforeDC= [self.before YMDComponents];
    
    NSInteger todayYear = todayDC.year;
    
    NSInteger todayMonth = todayDC.month;
    
    NSInteger beforeYear = beforeDC.year;
    
    NSInteger beforeMonth = beforeDC.month;
    
    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);
    
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    if (type == CalendarShowTypeSingle) {
        months = 0;
    }
    
    for (int i = 0; i <= months; i++) {
        
        NSDate *month = [self.today dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        if (type == CalendarShowTypeMultiple) {
            [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
        }
        
//        [self calculateDaysIsWeekendandArray:calendarDays];
        
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
}

//计算上月份的天数

- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    int daysCount = (int)[dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    int partialDaysCount = (int)weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (int i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        RMCalendarModel *calendarDay = [RMCalendarModel calendarWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [array addObject:calendarDay];
    }
    
    
    return NULL;
}



//计算下月份的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        RMCalendarModel *calendarDay = [RMCalendarModel calendarWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;
        [array addObject:calendarDay];
    }
}


//计算当月的天数

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        RMCalendarModel *calendarDay = [RMCalendarModel calendarWithYear:components.year month:components.month day:i];
        
        //        calendarDay.Chinese_calendar = [self LunarForSolarYear:components.year Month:components.month Day:i];
        
        calendarDay.week = [[calendarDay date]getWeekIntValueWithDate];
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}


- (void)changStyle:(RMCalendarModel *)model
{
    
    NSDateComponents *calendarToDay  = [self.today YMDComponents];//今天
    NSDateComponents *calendarSelect = [self.select YMDComponents];//默认选择的那一天
    model.isEnable = self.isEnable;
    
    //被点击选中
    if(calendarSelect.year == model.year &
       calendarSelect.month == model.month &
       calendarSelect.day == model.day){
        
        model.style = CellDayTypeClick;
        self.model = model;
    //没被点击选中
    }else{
        //昨天乃至过去的时间设置一个灰度
        if (calendarToDay.year >= model.year &
            calendarToDay.month >= model.month &
            calendarToDay.day > model.day) {
            
            model.style = CellDayTypePast;
            
            //之后的时间时间段
        }else
        {
             model.style = CellDayTypeFutur;
            
//            已占用时间
            for (NSDate *obj in self.occupyDays) {
                NSDateComponents *calendarObj= [obj YMDComponents];
                if (calendarObj.year==model.year&&
                    calendarObj.month==model.month&&
                    calendarObj.day==model.day) {
                    model.style=CellDayTypeNoPassOccupy;
                    if ([obj compare:[NSDate date]]==-1) {
                        model.style=CellDayTypePassOccupy;
                    }
                }
            }
        }
//            if (calendarbefore.year <= model.year &
//                  calendarbefore.month <= model.month &
//                  calendarbefore.day <= model.day) {
        
        
//            //已被安排的时间段
//        }else{
//            
//            //周末
//            if (model.week == 1 || model.week == 7){
//                model.style = CellDayTypeWeek;
//                
//                //工作日
//            }else{
//                model.style = CellDayTypeFutur;
//            }
//        }
    
//        //已占用时间
//        for (NSDate *obj in self.occupyDays) {
//            NSDateComponents *calendarObj= [obj YMDComponents];
//            if (calendarObj.year==model.year&&
//                calendarObj.month==model.month&&
//                calendarObj.day==model.day) {
//                model.style=CellDayTypeNoPassOccupy;
////                if ([obj compare:[NSDate date]]==-1) {
////                    model.style=CellDayTypePassOccupy;
////                }
//            }
//            
//        }
        
    //===================================
    //这里来判断节日
    //今天
//    if (calendarToDay.year == model.year &&
//        calendarToDay.month == model.month &&
//        calendarToDay.day == model.day) {
//        model.holiday = @"今天";
//明天
//    }else if(calendarToDay.year == calendarDay.year &&
//             calendarToDay.month == calendarDay.month &&
//             calendarToDay.day - calendarDay.day == -1){
//        calendarDay.holiday = @"明天";
//
//        //后天
//    }else if(calendarToDay.year == calendarDay.year &&
//             calendarToDay.month == calendarDay.month &&
//             calendarToDay.day - calendarDay.day == -2){
//        calendarDay.holiday = @"后天";
        //1.1元旦
    }
//        else if (model.month == 1 &&
//              model.day == 1){
//        model.holiday = @"元旦";
//        
//        //2.14情人节
//    }else if (model.month == 2 &&
//              model.day == 14){
//        model.holiday = @"情人节";
//        
//        //3.8妇女节
//    }else if (model.month == 3 &&
//              model.day == 8){
//        model.holiday = @"妇女节";
//        
//        //5.1劳动节
//    }else if (model.month == 5 &&
//              model.day == 1){
//        model.holiday = @"劳动节";
//        
//        //6.1儿童节
//    }else if (model.month == 6 &&
//              model.day == 1){
//        model.holiday = @"儿童节";
//        
//        //8.1建军节
//    }else if (model.month == 8 &&
//              model.day == 1){
//        model.holiday = @"建军节";
//        
//        //9.10教师节
//    }else if (model.month == 9 &&
//              model.day == 10){
//        model.holiday = @"教师节";
//        
//        //10.1国庆节
//    }else if (model.month == 10 &&
//              model.day == 1){
//        model.holiday = @"国庆节";
//        
//        //11.1植树节
//    }else if (model.month == 11 &&
//              model.day == 1){
//        model.holiday = @"植树节";
//        
//        //11.11光棍节
//    }else if (model.month == 11 &&
//              model.day == 11){
//        model.holiday = @"光棍节";
//        
//    }else{
//        
//        
//        //            这里写其它的节日
//        
//    }
// }
}

/**
 *  选择开始时间状态
 *
 *
 */
- (void)selectLogic:(RMCalendarModel *)dayModel PreStyle:(CellDayType)preStyle
{
    if (dayModel.style == CellDayTypeClick) {
        return;
    }
    dayModel.style = CellDayTypeClick;
    if (preStyle) {
        self.model.style=preStyle;
    }
    else
    {
         self.model.style = CellDayTypeFutur;
    }
    //    //周末
//    if (self.model.week == 1 || self.model.week == 7){
//        self.model.style = CellDayTypeWeek;
//        
//        //工作日
//    }else{
//        self.model.style = CellDayTypeFutur;
//    }
    self.model = dayModel;
}

-(void)changeStateToCellDayTypeClick:(RMCalendarModel *)dayModel
{
    dayModel.style = CellDayTypeClick;
    self.model = dayModel;
}

@end
