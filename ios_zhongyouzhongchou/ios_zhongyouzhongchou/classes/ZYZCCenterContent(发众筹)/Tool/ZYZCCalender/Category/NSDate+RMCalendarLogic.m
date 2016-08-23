//
//  NSDate+RMCalendarLogic.m
//  RMCalendar
//

#import "NSDate+RMCalendarLogic.h"

@implementation NSDate (RMCalendarLogic)

/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    
}


//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}



/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}



//计算这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}


- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dayInTheFollowingDay:(int)day andDate:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

//获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday fromDate:self];
}


//-----------------------------------------
//
//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //  [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd Z"];
    
//    NSDate *destDate= [dateFormatter dateFromString:dateString];
    if (dateString.length==10) {
//        NSString *year=[dateString substringToIndex:4];
//        NSLog(@"year:%@",year);
//        NSString *month=[dateString substringWithRange:NSMakeRange(5, 2)];
//        NSLog(@"month:%@",month);
//        NSString *day=[dateString substringFromIndex:9];
//        NSLog(@"day:%@",day);
//        NSString *newDateStr=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        NSString *newDateStr=[NSString stringWithFormat:@"%@ +0000",dateString];
        NSDate *destDate= [dateFormatter dateFromString:newDateStr];
        return destDate;
    }
    return nil;
}



//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    if(!today||!beforday)
    {
        return 0;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//日历控件对象
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    int day = (int)[components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    return day;
}

#pragma mark --- 获取两个日历间的所有日历
+ (NSArray *)getDatesBetweenDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSMutableArray *dateArr=[NSMutableArray array];
    
    int days=[self getDayNumbertoDay:startDate beforDay:endDate];
    for (int i=0; i<days; i++) {
        NSDate *oneDate=[startDate dayInTheFollowingDay:i];
        [dateArr addObject:oneDate];
    }
    return dateArr;
}

//周日是“1”，周一是“2”...
- (int)getWeekIntValueWithDate
{
    int weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps= [calendar components:(NSCalendarUnitYear |
                                                   NSCalendarUnitMonth |
                                                   NSCalendarUnitDay |
                                                   NSCalendarUnitWeekday) fromDate:self];
    return weekIntValue = (int)[comps weekday];
}




//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate
{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps_today= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:self];
    
    
    //获取星期对应的数字
    int weekIntValue = [self getWeekIntValueWithDate];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -1){
        return @"明天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -2){
        return @"后天";
        
    }else{
        //直接返回当时日期的字符串(这里让它返回空)
        return [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }
}



//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week
{
    NSString *str_week;
    
    switch (week) {
        case 1:
            str_week = @"周日";
            break;
        case 2:
            str_week = @"周一";
            break;
        case 3:
            str_week = @"周二";
            break;
        case 4:
            str_week = @"周三";
            break;
        case 5:
            str_week = @"周四";
            break;
        case 6:
            str_week = @"周五";
            break;
        case 7:
            str_week = @"周六";
            break;
    }
    return str_week;
}

/**
 *  判断两个日期的大小
 *
 */
+(int)compareDate:(NSDate *)date1 withDate:(NSDate*)date2{
    int ci;
    NSComparisonResult result = [date1 compare:date2];
    switch (result)
    {
            //date02比date01小
        case NSOrderedAscending: ci=1;break;
            //date02比date01大
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default:
//            NSLog(@"erorr dates %@, %@", date1, date2);
        break;
    }
    return ci;
}

+(NSInteger )getAgeFromBirthday:(NSString *)birthday
{
    NSInteger age=0;
    if (birthday.length) {
        NSDate *brithDay=[NSDate dateFromString:[self changStrToDateStr:birthday]];
        int days=[NSDate getDayNumbertoDay:brithDay beforDay:[NSDate date]]+1;
        age=days/365;
    }
    return age;
}

#pragma mark --- 将2016-1-1或20160101格式转成2016-01－01
+ (NSString *)changStrToDateStr:(NSString *)string
{
    if (string.length==10) {
        return string;
    }
    //此处可能存在两种类型的数据需要转换：2016-1-1，20160101
    //判断是哪一种
    NSRange range=[string rangeOfString:@"-"];
    //第一种情况  2016-1-1
    if (range.length) {
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
    //第二种情况  20160101
    else
    {
        if (string.length==8) {
            NSMutableString *newStr=[NSMutableString stringWithString:string];
            [newStr insertString:@"-" atIndex:4];
            [newStr insertString:@"-" atIndex:string.length-2];
            return newStr;
        }
        return nil;
    }
}

@end
